using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using Serilog;
using SteamKit2;
using SteamKit2.Internal;
using static SteamKit2.Internal.CCloud_EnumerateUserApps_Response;
using static SteamKit2.Internal.CMsgClientAppInfoRequest;
using static SteamKit2.Internal.CMsgClientPackageInfoResponse;
using static SteamKit2.SteamApps.PICSProductInfoCallback;
using static SteamKit2.SteamUserStats;

namespace SteamAutoCrack.Core.Utils
{
    class Steam3Session
    {
        private readonly ILogger _log;

        public class Credentials
        {
            public bool LoggedOn { get; set; }
            public ulong SessionToken { get; set; }

            public bool IsValid
            {
                get { return LoggedOn; }
            }
        }

        public ReadOnlyCollection<SteamApps.LicenseListCallback.License> Licenses
        {
            get;
            private set;
        }

        public Dictionary<uint, ulong> AppTokens { get; private set; }
        public Dictionary<uint, ulong> PackageTokens { get; private set; }
        public Dictionary<uint, SteamApps.PICSProductInfoCallback.PICSProductInfo> AppInfo { get; private set; }
        public Dictionary<uint, SteamApps.PICSProductInfoCallback.PICSProductInfo> PackageInfo { get; private set; }
        public Dictionary<string, byte[]> AppBetaPasswords { get; private set; }

        public SteamClient steamClient;
        public SteamUser steamUser;
        readonly SteamApps steamApps;
        readonly SteamCloud steamCloud;
        readonly SteamUserStats steamUserStats;
        readonly SteamUnifiedMessages.UnifiedService<IPublishedFile> steamPublishedFile;
        readonly SteamUnifiedMessages.UnifiedService<IInventory> steamInventory;

        readonly CallbackManager callbacks;

        readonly bool authenticatedUser;
        public bool bConnected;
        public bool bConnecting;
        public bool bAborted;
        public bool bExpectingDisconnectRemote;
        public bool bDidDisconnect;
        public bool bDidReceiveLoginKey;
        public bool bIsConnectionRecovery;
        int connectionBackoff;
        int seq; // more hack fixes
        DateTime connectTime;

        // input
        readonly SteamUser.LogOnDetails logonDetails;

        // output
        readonly Credentials credentials;

        static readonly TimeSpan STEAM3_TIMEOUT = TimeSpan.FromSeconds(30);


        public Steam3Session(SteamUser.LogOnDetails details)
        {
            _log = Log.ForContext<Steam3Session>();
            this.logonDetails = details;
            this.authenticatedUser = details.Username != null;
            this.credentials = new Credentials();
            this.bConnected = false;
            this.bConnecting = false;
            this.bAborted = false;
            this.bExpectingDisconnectRemote = false;
            this.bDidDisconnect = false;
            this.bDidReceiveLoginKey = false;
            this.seq = 0;

            this.AppTokens = new Dictionary<uint, ulong>();
            this.PackageTokens = new Dictionary<uint, ulong>();
            this.AppInfo = new Dictionary<uint, SteamApps.PICSProductInfoCallback.PICSProductInfo>();
            this.PackageInfo = new Dictionary<uint, SteamApps.PICSProductInfoCallback.PICSProductInfo>();
            this.AppBetaPasswords = new Dictionary<string, byte[]>();
            
            this.steamClient = new SteamClient();

            this.steamUser = this.steamClient.GetHandler<SteamUser>();
            this.steamApps = this.steamClient.GetHandler<SteamApps>();
            this.steamCloud = this.steamClient.GetHandler<SteamCloud>();
            var steamUnifiedMessages = this.steamClient.GetHandler<SteamUnifiedMessages>();
            this.steamPublishedFile = steamUnifiedMessages.CreateService<IPublishedFile>();
            this.steamInventory = steamUnifiedMessages.CreateService<IInventory>();

            this.callbacks = new CallbackManager(this.steamClient);

            this.callbacks.Subscribe<SteamClient.ConnectedCallback>(ConnectedCallback);
            this.callbacks.Subscribe<SteamClient.DisconnectedCallback>(DisconnectedCallback);
            this.callbacks.Subscribe<SteamUser.LoggedOnCallback>(LogOnCallback);

            Connect();

        }

        public delegate bool WaitCondition();

        private readonly object steamLock = new object();

        public bool WaitUntilCallback(Action submitter, WaitCondition waiter)
        {
            while (!bAborted && !waiter())
            {
                lock (steamLock)
                {
                    submitter();
                }

                var seq = this.seq;
                do
                {
                    lock (steamLock)
                    {
                        WaitForCallbacks();
                    }
                } while (!bAborted && this.seq == seq && !waiter());
            }

            return bAborted;
        }

        public void RequestAppInfo(uint appId, bool bForce = false)
        {
            if ((AppInfo.ContainsKey(appId) && !bForce) || bAborted)
                return;

            var completed = false;
            Action<SteamApps.PICSTokensCallback> cbMethodTokens = appTokens =>
            {
                completed = true;
                if (appTokens.AppTokensDenied.Contains(appId))
                {
                    _log.Warning("Insufficient privileges to get access token for app {0}", appId);
                }

                foreach (var token_dict in appTokens.AppTokens)
                {
                    AppTokens[token_dict.Key] = token_dict.Value;
                }
            };

            WaitUntilCallback(() =>
            {
                callbacks.Subscribe(steamApps.PICSGetAccessTokens(new List<uint> { appId }, new List<uint>()), cbMethodTokens);
            }, () => { return completed; });

            completed = false;
            Action<SteamApps.PICSProductInfoCallback> cbMethod = appInfo =>
            {
                completed = !appInfo.ResponsePending;

                foreach (var app_value in appInfo.Apps)
                {
                    var app = app_value.Value;

                    _log.Debug("Got AppInfo for {0}", app.ID);
                    AppInfo[app.ID] = app;
                }

                foreach (var app in appInfo.UnknownApps)
                {
                    AppInfo[app] = null;
                }
            };

            var request = new SteamApps.PICSRequest(appId);
            if (AppTokens.ContainsKey(appId))
            {
                request.AccessToken = AppTokens[appId];
            }

            WaitUntilCallback(() =>
            {
                callbacks.Subscribe(steamApps.PICSGetProductInfo(new List<SteamApps.PICSRequest> { request }, new List<SteamApps.PICSRequest>()), cbMethod);
            }, () => { return completed; });
        }

        public void RequestPackageInfo(IEnumerable<uint> packageIds)
        {
            var packages = packageIds.ToList();
            packages.RemoveAll(pid => PackageInfo.ContainsKey(pid));

            if (packages.Count == 0 || bAborted)
                return;

            var completed = false;
            Action<SteamApps.PICSProductInfoCallback> cbMethod = packageInfo =>
            {
                completed = !packageInfo.ResponsePending;

                foreach (var package_value in packageInfo.Packages)
                {
                    var package = package_value.Value;
                    PackageInfo[package.ID] = package;
                }

                foreach (var package in packageInfo.UnknownPackages)
                {
                    PackageInfo[package] = null;
                }
            };

            var packageRequests = new List<SteamApps.PICSRequest>();

            foreach (var package in packages)
            {
                var request = new SteamApps.PICSRequest(package);

                if (PackageTokens.TryGetValue(package, out var token))
                {
                    request.AccessToken = token;
                }

                packageRequests.Add(request);
            }

            WaitUntilCallback(() =>
            {
                callbacks.Subscribe(steamApps.PICSGetProductInfo(new List<SteamApps.PICSRequest>(), packageRequests), cbMethod);
            }, () => { return completed; });
        }

        public string GetInventoryDigest(uint appId)
        {
            var itemDefMeta = new CInventory_GetItemDefMeta_Request { appid = appId };
            var completed = false;
            string data = null;

            Action<SteamUnifiedMessages.ServiceMethodResponse> cbMethod = callback =>
            {
                completed = true;
                if (callback.Result == EResult.OK)
                {
                    var response = callback.GetDeserializedResponse<CInventory_GetItemDefMeta_Response>();
                    data = response.digest;
                }
                else
                {
                    _log.Warning($"EResult {(int)callback.Result} ({callback.Result}) while retrieving items digest for {appId}.");
                }
            };

            WaitUntilCallback(() =>
            {
                callbacks.Subscribe(steamInventory.SendMessage(api => api.GetItemDefMeta(itemDefMeta)), cbMethod);
            }, () => { return completed; });

            return data;
        }

        private void ResetConnectionFlags()
        {
            bExpectingDisconnectRemote = false;
            bDidDisconnect = false;
            bIsConnectionRecovery = false;
            bDidReceiveLoginKey = false;
        }

        void Connect()
        {
            _log.Debug("Connecting to Steam3...");

            bAborted = false;
            bConnected = false;
            bConnecting = true;
            connectionBackoff = 0;

            ResetConnectionFlags();

            this.connectTime = DateTime.Now;
            this.steamClient.Connect();
        }

        private void Abort(bool sendLogOff = true)
        {
            Disconnect(sendLogOff);
        }

        public void Disconnect(bool sendLogOff = true)
        {
            if (sendLogOff)
            {
                steamUser.LogOff();
            }

            bAborted = true;
            bConnected = false;
            bConnecting = false;
            bIsConnectionRecovery = false;
            steamClient.Disconnect();

            // flush callbacks until our disconnected event
            while (!bDidDisconnect)
            {
                callbacks.RunWaitAllCallbacks(TimeSpan.FromMilliseconds(100));
            }
        }

        private void Reconnect()
        {
            bIsConnectionRecovery = true;
            steamClient.Disconnect();
        }

        private void WaitForCallbacks()
        {
            callbacks.RunWaitCallbacks(TimeSpan.FromSeconds(1));

            var diff = DateTime.Now - connectTime;

            if (diff > STEAM3_TIMEOUT && !bConnected)
            {
                _log.Error("Timeout connecting to Steam3. Disconnecting...");
                Abort();
            }
        }

        private void ConnectedCallback(SteamClient.ConnectedCallback connected)
        {
            _log.Debug("Connected to Steam3! Logging anonymously into Steam3...");
            bConnecting = false;
            bConnected = true;
            steamUser.LogOnAnonymous();
        }

        private void DisconnectedCallback(SteamClient.DisconnectedCallback disconnected)
        {
            bDidDisconnect = true;

            // When recovering the connection, we want to reconnect even if the remote disconnects us
            if (!bIsConnectionRecovery && (disconnected.UserInitiated || bExpectingDisconnectRemote))
            {
                _log.Debug("Disconnected from Steam");

                // Any operations outstanding need to be aborted
                bAborted = true;
            }
            else if (connectionBackoff >= 10)
            {
                _log.Error("Could not connect to Steam after 10 tries");
                Abort(false);
            }
            else if (!bAborted)
            {
                if (bConnecting)
                {
                    _log.Warning("Connection to Steam failed. Trying again.");
                }
                else
                {
                    _log.Warning("Lost connection to Steam. Reconnecting...");
                }

                Thread.Sleep(1000 * ++connectionBackoff);

                // Any connection related flags need to be reset here to match the state after Connect
                ResetConnectionFlags();
                steamClient.Connect();
            }
        }

        private void LogOnCallback(SteamUser.LoggedOnCallback loggedOn)
        {
            if (loggedOn.Result == EResult.TryAnotherCM)
            {
                _log.Debug("Retrying Steam3 connection (TryAnotherCM)...");

                Reconnect();

                return;
            }

            if (loggedOn.Result == EResult.ServiceUnavailable)
            {
                _log.Error("Unable to login to Steam3: {0}", loggedOn.Result);
                Abort(false);

                return;
            }

            if (loggedOn.Result != EResult.OK)
            {
                _log.Error("Unable to login to Steam3: {0}", loggedOn.Result);
                Abort();

                return;
            }

            _log.Debug("Logged on to Steam3!");

            this.seq++;
            credentials.LoggedOn = true;
        }

    }
}
