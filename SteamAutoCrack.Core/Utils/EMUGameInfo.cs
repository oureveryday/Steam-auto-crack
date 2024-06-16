#pragma warning disable CS4014

using IniFile;
using Serilog;
using SteamKit2;
using System.ComponentModel;
using System.Data;
using System.Net;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using SteamAutoCrack.Core.Config;
using static SteamAutoCrack.Core.Utils.EMUGameInfoConfig;
using Section = IniFile.Section;

namespace SteamAutoCrack.Core.Utils
{
    public class EMUGameInfoConfig
    {
        private readonly ILogger _log;

        public EMUGameInfoConfig()
        {
            _log = Log.ForContext<EMUGameInfoConfig>();
        }

        public enum GeneratorGameInfoAPI 
        {
            [Description("SteamKit2 Client")]
            GeneratorSteamClient,
            [Description("Steam Web API")]
            GeneratorSteamWeb,
            [Description("Offline")]
            GeneratorOffline };
        public GeneratorGameInfoAPI GameInfoAPI { get; set; } = GeneratorGameInfoAPI.GeneratorSteamClient;
        /// <summary>
        /// Required when using Steam official Web API.
        /// </summary>
        public string? SteamWebAPIKey { get; set; } = String.Empty;
        public string? ConfigPath { get; set; } = Path.Combine(Config.Config.TempPath, "steam_settings");
        /// <summary>
        /// Enable generate game achievement images.
        /// </summary>
        public bool GenerateImages { get; set; } = true;
        public uint AppID { get; set; }
        /// <summary>
        /// Use Xan105 API for generating game schema.
        /// </summary>
        public bool UseXan105API { get; set; } = false;
        /// <summary>
        /// Use Steam Web App List when generating DLCs.
        /// </summary>
        public bool UseSteamWebAppList { get; set; } = false;

        public void SetAppIDFromString(string str)
        {
            if (!UInt32.TryParse(str, out var appID))
            {
                _log.Error("Invaild Steam AppID.");
                throw new Exception("Invaild Steam AppID.");
            }
            AppID = appID;
        }
    }

    public class EMUGameInfoConfigDefault
    {
        public static GeneratorGameInfoAPI GameInfoAPI  = GeneratorGameInfoAPI.GeneratorSteamClient;
        /// <summary>
        /// Required when using Steam official Web API.
        /// </summary>
        public static string? SteamWebAPIKey { get; set; } = String.Empty;
        public static readonly string ConfigPath = Path.Combine(Config.Config.TempPath, "steam_settings");
        /// <summary>
        /// Enable generate game achievement images.
        /// </summary>
        public static readonly bool GenerateImages = true;
        /// <summary>
        /// Use Xan105 API for generating game schema.
        /// </summary>
        public static readonly bool UseXan105API = false;
        /// <summary>
        /// Use Steam Web App List when generating DLCs.
        /// </summary>
        public static readonly bool UseSteamWebAppList = false;
    }

    public interface IEMUGameInfo
    {
        public Task<bool> Generate(EMUGameInfoConfig GameInfoConfig);
    }

    public class EMUGameInfo : IEMUGameInfo
    {
        private readonly ILogger _log;

        public EMUGameInfo()
        {
            _log = Log.ForContext<EMUGameInfo>();
        }

        public async Task<bool> Generate(EMUGameInfoConfig GameInfoConfig)
        {
            Generator Generator;
            _log.Information("Generating game info...");
            try
            {
                switch (GameInfoConfig.GameInfoAPI)
                {
                    case GeneratorGameInfoAPI.GeneratorSteamClient:
                        Generator = new GeneratorSteamClient(GameInfoConfig); break;
                    case GeneratorGameInfoAPI.GeneratorSteamWeb:
                        Generator = new GeneratorSteamWeb(GameInfoConfig); break;
                    case GeneratorGameInfoAPI.GeneratorOffline:
                        Generator = new GeneratorOffline(GameInfoConfig); break;
                    default: throw new Exception("Invaild game info API.");
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex,"Error: ");
                return false;
            }
            try
            {
                await Generator.InfoGenerator().ConfigureAwait(false);
                _log.Information("Generated game info.");
                return true;
            }
            catch (Exception ex)
            {
                _log.Error(ex,"Failed to generate game info.");
                return false;
            }
        }
    }

    abstract internal class Generator
    {
        protected const string UserAgent =
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) " +
            "Chrome/87.0.4280.88 Safari/537.36";
        protected readonly ILogger _log;
        protected readonly string? SteamWebAPIKey;
        protected readonly string? ConfigPath;
        protected readonly uint AppID;
        protected readonly bool GenerateImages;
        protected readonly string? TempPath;
        protected readonly bool UseXan105API = true;
        protected readonly bool UseSteamWebAppList = false;
        public Ini config_app = new Ini();
        public abstract Task InfoGenerator();
        protected JsonDocument GameSchema;
        protected List<string> DownloadedFile = new();
        DateTime LastWebRequestTime = new DateTime();
        public Generator(EMUGameInfoConfig GameInfoConfig) 
        { 
            _log = Log.ForContext<EMUGameInfo>();
            Ini.Config.AllowHashForComments(setAsDefault: true);
            SteamWebAPIKey = GameInfoConfig.SteamWebAPIKey;
            ConfigPath= GameInfoConfig.ConfigPath;
            AppID = GameInfoConfig.AppID;
            GenerateImages = GameInfoConfig.GenerateImages;
            UseXan105API = GameInfoConfig.UseXan105API;
            UseSteamWebAppList = GameInfoConfig.UseSteamWebAppList;
        }
        protected class DLC
        {
            public uint DLCId { get; set; } = 0;
            public KeyValue Info { get; set; }
        }
        public class Achievement
        {
            /// <summary>
            /// Achievement description.
            /// </summary>
            [JsonPropertyName("description")]
            public string? Description { get; set; }

            /// <summary>
            /// Human readable name, as shown on webpage, game library, overlay, etc.
            /// </summary>
            [JsonPropertyName("displayName")]
            public string? DisplayName { get; set; }

            /// <summary>
            /// Is achievement hidden? 0 = false, else true.
            /// </summary>
            [JsonPropertyName("hidden")]
            public int Hidden { get; set; }

            /// <summary>
            /// Path to icon when unlocked (colored).
            /// </summary>
            [JsonPropertyName("icon")]
            public string? Icon { get; set; }

            /// <summary>
            /// Path to icon when locked (grayed out).
            /// </summary>
            // ReSharper disable once StringLiteralTypo
            [JsonPropertyName("icongray")]
            public string? IconGray { get; set; }

            /// <summary>
            /// Internal name.
            /// </summary>
            [JsonPropertyName("name")]
            public string? Name { get; set; }
        }
        protected async Task GenerateBasic()
        {
            try
            {
                _log.Debug("Generating basic infos...");
                if (Directory.Exists(ConfigPath))
                {
                    Directory.Delete(ConfigPath, true);
                    _log.Debug("Deleted previous steam_settings folder.");
                }
                Directory.CreateDirectory(ConfigPath);
                _log.Debug("Created steam_settings folder.");
            }
            catch (UnauthorizedAccessException ex)
            {
                _log.Error(ex, "Failed to access steam_settings path. (Try run SteamAutoCrack with administrative rights)");
                throw new Exception("Failed to access steam_settings path.");
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to access steam_settings path.");
                throw new Exception("Failed to access steam_settings path.");
            }
            _log.Debug("Outputting game info to {0}", Path.GetFullPath(ConfigPath));
            try
            {
                File.WriteAllText(Path.Combine(ConfigPath, "steam_appid.txt"), AppID.ToString());
                _log.Debug("Generated steam_appid.txt");
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to write steam_appid.txt.");
                throw new Exception("Failed to write steam_appid.txt.");
            }
            _log.Debug("Generated basic infos.");
        }
        protected async Task<bool> GetGameSchema()
        {
            try
            {
                _log.Information("Getting game schema...");
                string GameSchemaUrl = UseXan105API ? "https://api.xan105.com/steam/ach/" : "https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/";
                if (!UseXan105API && (SteamWebAPIKey == String.Empty || SteamWebAPIKey == null))
                {
                    _log.Warning("Empty Steam Web API Key, skipping getting game schema...");
                    return false;
                }
                _log.Debug($"Getting schema for App {AppID}");

                string language = String.Empty;

                switch (Config.Config.Language)
                {
                    case Config.Config.Languages.en_US:
                        language += "english";
                        break;
                    case Config.Config.Languages.zh_CN:
                        language += "schinese";
                        break;
                    default:
                        language += "english";
                        break;
                }

                var client = new HttpClient();
                client.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                var apiUrl = UseXan105API ? $"{GameSchemaUrl}&appid={AppID}" : $"{GameSchemaUrl}?l={language}&key={SteamWebAPIKey}&appid={AppID}";

                client.Timeout = TimeSpan.FromSeconds(30);
                var response = await LimitSteamWebApiGET(client,
                new HttpRequestMessage(HttpMethod.Get, apiUrl));
                var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                var responseCode = response.StatusCode;
                if (responseCode == HttpStatusCode.OK)
                {
                    _log.Debug("Got game schema.");
                    GameSchema = JsonDocument.Parse(responseBody);
                }
                else if (responseCode == HttpStatusCode.Forbidden && !UseXan105API)
                {
                    _log.Error("Error 403 in getting game schema, please check your Steam Web API key. Skipping...");
                    throw new Exception("Error 403 in getting game schema.");
                }
                else
                {
                    _log.Error("Error {Code} in getting game schema. Skipping...", responseCode);
                    throw new Exception($"Error {responseCode} in getting game schema. Skipping...");
                }
                return true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to get game schema.");
                return false;
            }
        }
        protected async Task DownloadImageAsync(string imageFolder, Achievement achievement)
        {
            var wc = new WebClient();
            try
            {
                var fileName = Path.GetFileName(achievement.Icon);
                var targetPath = Path.Combine(imageFolder, fileName);
                if (!DownloadedFile.Exists((x => x == targetPath)))
                {
                    DownloadedFile.Add(targetPath);
                    await wc.DownloadFileTaskAsync(new Uri(achievement.Icon, UriKind.Absolute), targetPath);
                }
                else
                {
                    _log.Debug("Image {targetPath} already downloaded. Skipping...", targetPath);
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to download image of achievement \"{name}\", skipping...", achievement.Name);
            }
            try
            {
                var fileNameGray = Path.GetFileName(achievement.IconGray);
                var targetPathGray = Path.Combine(imageFolder, fileNameGray);
                if (!DownloadedFile.Exists((x => x == targetPathGray)))
                {
                    DownloadedFile.Add(targetPathGray);
                    await wc.DownloadFileTaskAsync(new Uri(achievement.IconGray, UriKind.Absolute), targetPathGray);
                }
                else
                {
                    _log.Debug("Gray image {targetPath} already downloaded. Skipping...", targetPathGray);
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to download gray image of achievement \"{name}\", skipping...", achievement.Name);
            }
        }
        protected async Task GenerateAchievements()
        {
            try
            {
                _log.Debug("Generating achievements...");
                var achievementList = new List<Achievement>();
                var achievementData = UseXan105API ? GameSchema.RootElement.GetProperty("data")
                    .GetProperty("achievement")
                    .GetProperty("list") :
                     GameSchema.RootElement.GetProperty("game")
                    .GetProperty("availableGameStats")
                    .GetProperty("achievements");

                achievementList = JsonSerializer.Deserialize<List<Achievement>>(achievementData.GetRawText());
                if (achievementList.Count > 0)
                {
                    var empty = achievementList.Count == 1 ? "" : "s";
                    _log.Debug($"Successfully got {achievementList.Count} achievement{empty}.");
                }
                else
                {
                    _log.Debug("No achievements found.");
                    return;
                }

                if (GenerateImages)
                {
                    _log.Debug("Downloading achievement images...");
                    var imagePath = Path.Combine(ConfigPath, "achievement_images");
                    Directory.CreateDirectory(imagePath);

                    IEnumerable<Task> downloadTasksQuery =
                    from achievement in achievementList
                    select DownloadImageAsync(imagePath, achievement);

                    List<Task> downloadTasks = downloadTasksQuery.ToList();
                    while (downloadTasks.Any())
                    {
                        Task finishedTask = await Task.WhenAny(downloadTasks);
                        downloadTasks.Remove(finishedTask);
                    }
                    _log.Debug("Downloaded achievement images.");
                }

                _log.Debug("Saving achievements...");
                foreach (var achievement in achievementList)
                {
                    // Update achievement list to point to local images instead
                    achievement.Icon = $"achievement_images/{Path.GetFileName(achievement.Icon)}";
                    achievement.IconGray = $"achievement_images/{Path.GetFileName(achievement.IconGray)}";
                }
                var achievementJson = JsonSerializer.Serialize(
                    achievementList,
                    new JsonSerializerOptions
                    {
                        Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
                        WriteIndented = true
                    });
                await File.WriteAllTextAsync(Path.Combine(ConfigPath, "achievements.json"), achievementJson)
                    .ConfigureAwait(false);

            }
            catch (KeyNotFoundException)
            {
                _log.Information("No achievements, skipping...");
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to generate achievements. Skipping...");
            }
            _log.Debug("Generated achievements.");
        }
        protected async Task GenerateStats()
        {
            try
            {
                if (UseXan105API)
                {
                    _log.Information("Using xan105 API, skipping generate stats...");
                    return;
                }
                _log.Debug("Generating stats...");
                var statData = GameSchema.RootElement.GetProperty("game")
                    .GetProperty("availableGameStats")
                    .GetProperty("stats");
                var Count = 0;

                _log.Debug("Saving stats...");
                StreamWriter sw = new StreamWriter(Path.Combine(ConfigPath, "stats.txt"));
                var newline = "";
                foreach (JsonElement stat in statData.EnumerateArray())
                {
                    string name = "";
                    string defaultValue = "";

                    if (stat.TryGetProperty("name", out JsonElement _name))
                    {
                        name = _name.GetString();
                    }
                    if (stat.TryGetProperty("defaultvalue", out JsonElement _defaultvalue))
                    {
                        defaultValue = _defaultvalue.ToString();
                    }
                    sw.Write(newline + name + "=int=" + defaultValue);
                    newline = Environment.NewLine;
                    Count++;
                }
               sw.Close();
                if (Count > 0)
                {
                    var empty = Count == 1 ? "" : "s";
                    _log.Debug($"Successfully got {Count} stat{empty}.");
                }
                else
                {
                    File.Delete(Path.Combine(ConfigPath, "stats.txt"));
                    _log.Debug("No stat found.");
                    return;
                }
            }
            catch (KeyNotFoundException)
            {
                _log.Information("No stats, skipping...");
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to generate stats. Skipping...");
            }
            _log.Debug("Generated stats.");
        }
        protected async Task<HttpResponseMessage> LimitSteamWebApiGET(HttpClient http_client, HttpRequestMessage http_request, CancellationTokenSource cts = null)
        {// Steam has a limit of 300 requests every 5 minutes (1 request per second).
            if ((DateTime.Now - LastWebRequestTime) < TimeSpan.FromSeconds(1))
                Thread.Sleep(TimeSpan.FromSeconds(1));

            LastWebRequestTime = DateTime.Now;

            if (cts == null)
            {
                cts = new CancellationTokenSource();
            }

            return await http_client.SendAsync(http_request, HttpCompletionOption.ResponseContentRead, cts.Token).ConfigureAwait(false);
        }

        protected void WriteIni()
        {
            try
            {
                _log.Debug("Writing configs.app.ini...");
                config_app.SaveTo(Path.Combine(ConfigPath, "configs.app.ini"));
            }
            catch (Exception ex)
            {
                _log.Information(ex, "Failed to Write configs.app.ini");
            }
        }
    }

    internal class GeneratorSteamClient : Generator
    {
        private static Steam3Session steam3;

        public GeneratorSteamClient(EMUGameInfoConfig GameInfoConfig) : base(GameInfoConfig) { }

        private async Task Steam3Start()
        {
            try
            {
                _log.Information("Starting Steam3 Session...");

                steam3 = new Steam3Session(
                new SteamUser.LogOnDetails
                {
                    Username = null,
                    Password = null,
                }
                );   
            }
            catch (Exception ex) 
            { 
                _log.Error(ex,"Failed to start Steam3 Session.");
                throw new Exception("Failed to start Steam3 Session.");
            }
            _log.Debug("Started Steam3 Session...");
        }

        private async Task<KeyValue> GetSteam3AppSection(uint appId, EAppInfoSection section)
        {
            try
            {
                if (steam3 == null || steam3.AppInfo == null)
                {
                    return null;
                }

                SteamApps.PICSProductInfoCallback.PICSProductInfo app;
                if (!steam3.AppInfo.TryGetValue(appId, out app) || app == null)
                {
                    return null;
                }

                var appinfo = app.KeyValues;
                string section_key;

                switch (section)
                {
                    case EAppInfoSection.Common:
                        section_key = "common";
                        break;
                    case EAppInfoSection.Extended:
                        section_key = "extended";
                        break;
                    case EAppInfoSection.Config:
                        section_key = "config";
                        break;
                    case EAppInfoSection.Depots:
                        section_key = "depots";
                        break;
                    default:
                        throw new NotImplementedException();
                }

                var section_kv = appinfo.Children.Where(c => c.Name == section_key).FirstOrDefault();
                return section_kv;
            }
            catch(Exception ex) 
            {
                _log.Error(ex, "Failed to get Steam3 App Section.");
                throw new Exception("Failed to get Steam3 App Section.");
            }
        }

        private async Task GenerateSupportedLang()
        {
            try
            {
                _log.Debug("Generating supported_languages.txt...");
                KeyValue GameInfoCommon = await GetSteam3AppSection(AppID, EAppInfoSection.Common).ConfigureAwait(false);
                if (GameInfoCommon == null)
                {
                    _log.Error("Failed to get game info, skipping generate supported languages...(AppID: {appid})", AppID);
                    return;
                }
                if (GameInfoCommon["supported_languages"] != KeyValue.Invalid)
                {
                    _log.Debug("Writing supported_languages.txt...");
                    StreamWriter sw = new StreamWriter(Path.Combine(ConfigPath, "supported_languages.txt"));
                    var newline = "";
                    GameInfoCommon["supported_languages"].Children.ForEach(delegate (KeyValue language)
                    {
                    if (language.Children.Exists(x => x.Name == "supported" && x.Value == "true"))
                        {
                            sw.Write(newline + language.Name);
                            newline = Environment.NewLine;
                        }
                        
                    });
                    sw.Close();
                    
                }
            }
            catch(Exception ex)
            {
                _log.Information(ex, "Failed to generate supported_languages.txt. Skipping...");
            }
            _log.Debug("Generated supported_languages.txt.");
        }

        private async Task GenerateDepots()
        {
            try
            {
                _log.Debug("Generating depot infos...");
                KeyValue GameInfoDepots = await GetSteam3AppSection(AppID, EAppInfoSection.Depots).ConfigureAwait(false);
                if (GameInfoDepots == null)
                {
                    _log.Error("Failed to get game info, skipping generate depots...(AppID: {appid})", AppID);
                    return;
                }
                if (GameInfoDepots != KeyValue.Invalid)
                {
                    _log.Debug("Writing depots.txt...");
                    StreamWriter swdepots = new StreamWriter(Path.Combine(ConfigPath, "depots.txt"));
                    var newline = "";
                    GameInfoDepots.Children.ForEach(delegate (KeyValue DepotIDs)
                    {
                        uint DepotID = 0;
                        if (uint.TryParse(DepotIDs.Name,out DepotID))
                        {
                            swdepots.Write(newline + DepotID);
                            newline = Environment.NewLine;
                        }
                    });
                    swdepots.Close();

                    uint buildID = 0;
                    if (GameInfoDepots.Children.Exists(x => x.Name == "branches" &&
                    x.Children.Exists(x => x.Name == "public" && 
                    x.Children.Exists(x => x.Name == "buildid" && uint.TryParse(x.Value,out buildID)))))
                    {
                        config_app.Add(new Section("app::general")
                        {
                            new Property("build_id", buildID, " allow the app/game to show the correct build id"),
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                _log.Information(ex, "Failed to generate depot infos. Skipping...");
            }
            _log.Debug("Generated depot infos.");
        }

        private async Task GenerateDLCs()
        {
            try
            {
                _log.Debug("Generating DLCs...");
                KeyValue GameInfoDLCs = await GetSteam3AppSection(AppID, EAppInfoSection.Extended).ConfigureAwait(false);
                if (GameInfoDLCs == null)
                {
                    _log.Error("Failed to get game info, skipping generate DLCs...(AppID: {appid})", AppID);
                    return;
                }
                
                List<uint> DLCIds = new List<uint>();
                if (GameInfoDLCs["listofdlc"] != KeyValue.Invalid)
                {
                    _log.Debug("Getting DLCs from Extended section...");
                    if (GameInfoDLCs["listofdlc"].Value == null)
                    {
                        _log.Information("No DLC in Extended section, skipping...(AppID: {appid})", AppID);
                        return;
                    }
                    DLCIds.AddRange(new List<string>(GameInfoDLCs["listofdlc"].Value.Split(',')).ConvertAll<uint>(x => Convert.ToUInt32(x)));
                }
               
                if (DLCIds.Count == 0)
                {
                    _log.Debug("No DLCs. Skipping...");
                    return;
                };

                if (UseSteamWebAppList)
                {
                    await SteamAppList.WaitForReady().ConfigureAwait(false);
                    _log.Debug("Using Steam Web App list.");
                    List<SteamApp> DLCInfos = new List<SteamApp>();
                    foreach (var DLCId in DLCIds)
                    {
                        DLCInfos.Add(await SteamAppList.GetAppById(DLCId).ConfigureAwait(false));
                    }

                    var dlcsection = new Section("app::dlcs") { new Property("unlock_all", "0", " should the emu report all DLCs as unlocked, default=1")};

                    foreach (var DLC in DLCInfos)
                    {
                        string name;
                        string id;
                        name = DLC.Name;
                        if (DLC.AppId.HasValue)
                        {
                            id = DLC.AppId.Value.ToString();
                        }
                        else
                        {
                            id = "";
                        }
                        dlcsection.Add(new Property(id, name));
                    
                    }

                    dlcsection.Items.Add(new BlankLine());
                    config_app.Add(dlcsection);
                }
                else
                {
                    _log.Debug("Using Steam3 App list.");
                    Dictionary<uint,KeyValue> DLCs = new Dictionary<uint, KeyValue>();
                    IEnumerable<Task> getInfoTasksQuery =
                    from DLCId in DLCIds
                    select GetAppInfo(DLCId);

                    List<Task> getInfoTasks = getInfoTasksQuery.ToList();
                    while (getInfoTasks.Any())
                    {
                        Task finishedTask = await Task.WhenAny(getInfoTasks);
                        getInfoTasks.Remove(finishedTask);
                    }
                    foreach (var DLCId in DLCIds)
                    {
                        if (!DLCs.ContainsKey(DLCId))
                        {
                            DLCs.Add(DLCId, await GetSteam3AppSection(DLCId, EAppInfoSection.Common).ConfigureAwait(false));
                        }
                    }

                    var dlcsection = new Section("app::dlcs") { new Property("unlock_all", "0", " should the emu report all DLCs as unlocked, default=1") };

                    foreach (var DLC in DLCs)
                    {
                        string name;
                        string id;
                        if (DLC.Value != null)
                        {
                            name = DLC.Value.Children.Find(x => x.Name == "name")?.Value;
                            id = DLC.Key.ToString();
                            dlcsection.Add(new Property(id, name));
                        }
                    }

                    dlcsection.Items.Add(new BlankLine());
                    config_app.Add(dlcsection);
                }
            }
            catch (Exception ex)
            {
                _log.Information(ex, "Failed to generate DLCs. Skipping...");
            }
            _log.Debug("Generated DLCs.");
        }

        private async Task GenerateInventory()
        {
            try
            {
                _log.Debug("Generating inventory info...");

                _log.Debug("Getting inventory digest...");
                string digest = null;
                await Task.Run(() =>
                {
                    digest = steam3.GetInventoryDigest(AppID);
                }).ConfigureAwait(false);
                if (digest == null)
                {
                    _log.Debug("No inventory digest, skipping...");
                    return;
                }

                _log.Debug("Getting inventory items...");
                var client = new HttpClient();
                client.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                client.Timeout = TimeSpan.FromSeconds(30);
                var response = await LimitSteamWebApiGET(client, new HttpRequestMessage(HttpMethod.Get, $"https://api.steampowered.com/IGameInventory/GetItemDefArchive/v0001?appid={AppID}&digest={digest.Trim(new char[] { '"' })}")).ConfigureAwait(false);

                if (response.StatusCode == HttpStatusCode.OK)
                {
                    if (response.Content != null)
                    {
                        var content = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                        JsonArray items = JsonNode.Parse(content.Trim(new char[] { '\0' })).Root.AsArray();
                        if (items.Count > 0)
                        {
                            _log.Debug("Found items, generating...");
                            var inventory = new JsonObject();
                            var inventorydefault = new JsonObject();
                            foreach (var item in items)
                            {
                                var x = new JsonObject();
                                var index = item["itemdefid"].ToString();

                                foreach (var t in item.AsObject())
                                {
                                    x.Add(t.Key, t.Value.ToString());
                                }
                                inventory.Add(index, x);
                                inventorydefault.Add(index, 1);
                            }
                            File.WriteAllText(Path.Combine(ConfigPath, "items.json"), inventory.ToString());
                            File.WriteAllText(Path.Combine(ConfigPath, "default_items.json"), inventorydefault.ToString());
                            return;
                        }
                    }
                    else
                    {
                        _log.Information("No inventory items. Skipping...");
                        return;
                    }
                }
                else
                {
                    throw new Exception($"Error {response.StatusCode} in getting game inventory.");
                }
                _log.Debug("Generated inventory info.");
            }
            catch (KeyNotFoundException)
            {
                _log.Information("No inventory, skipping...");
            }
            catch (Exception ex)
            {
                _log.Information(ex, "Failed to generate inventory info. Skipping...");
            }
        }

        private async Task GetAppInfo(uint appID)
        {
            await Task.Run(() =>
            {
                steam3.RequestAppInfo(appID, true);
            }).ConfigureAwait(false);;
        }

        private async Task<bool> WaitForConnected()
        {
            steam3.WaitUntilCallback(() => { }, () => { return !steam3.bConnecting; }); 
            if (steam3.bAborted)
            {
                _log.Information("Steam3 connection aborted, skipping generation...");
                return false;
            }
            return true;
        }

        public override async Task InfoGenerator()
        {
            try
            {
                await GenerateBasic().ConfigureAwait(false);
                await Steam3Start().ConfigureAwait(false);
                Task TaskA = Task.Run(async () =>
                {
                    if (GetGameSchema().GetAwaiter().GetResult())
                    {
                        var Tasks2 = new List<Task> { GenerateAchievements(), GenerateStats() };
                        while (Tasks2.Count > 0)
                        {
                            Task finishedTask2 = await Task.WhenAny(Tasks2);
                            Tasks2.Remove(finishedTask2);
                        }
                    }
                });
                
                if (await WaitForConnected().ConfigureAwait(false))
                {
                    await GetAppInfo(AppID).ConfigureAwait(false);
                    var Tasks1 = new List<Task> { GenerateSupportedLang(), GenerateDepots(), GenerateDLCs(), GenerateInventory() };
                    while (Tasks1.Count > 0)
                    {
                        Task finishedTask1 = await Task.WhenAny(Tasks1);
                        Tasks1.Remove(finishedTask1);
                    }
                }
                Task.WaitAll(TaskA);
                WriteIni();
                steam3?.Disconnect();
            }
            catch (Exception e)
            {
                if (steam3 != null)
                {
                    steam3?.Disconnect();
                }
                throw new Exception(e.ToString());
            }
        }
    }
    internal class GeneratorSteamWeb : Generator
    {
        public GeneratorSteamWeb(EMUGameInfoConfig GameInfoConfig) : base(GameInfoConfig)
        {
        }

        private async Task GenerateDLCs()
        {
            try
            {
                _log.Debug("Generating DLCs...");
                List<uint> DLCIds = new List<uint>();

                var client = new HttpClient();
                client.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                client.Timeout = TimeSpan.FromSeconds(30);
                var response = await LimitSteamWebApiGET(client, new HttpRequestMessage(HttpMethod.Get, $"https://store.steampowered.com/api/appdetails/?appids={AppID}&l=english")).ConfigureAwait(false);

                if (response.StatusCode == HttpStatusCode.OK && response.Content != null)
                {
                    var responsejson = JsonDocument.Parse(await response.Content.ReadAsStringAsync().ConfigureAwait(false));
                    if (responsejson.RootElement.GetProperty(AppID.ToString()).GetProperty("success").GetBoolean())
                    {
                       if ((responsejson.RootElement.GetProperty(AppID.ToString()).GetProperty("data").TryGetProperty("dlc",out var dlcid)))
                       {
                           foreach (var dlc in dlcid.EnumerateArray())
                           {
                               DLCIds.Add(dlc.GetUInt32());
                           }
                       }
                   }
                }
                
                if (DLCIds.Count == 0)
                {
                    _log.Debug("No DLCs. Skipping...");
                    return;
                };

                await SteamAppList.WaitForReady().ConfigureAwait(false);
                List<SteamApp> DLCInfos = new List<SteamApp>();
                foreach (var DLCId in DLCIds)
                {
                    DLCInfos.Add(await SteamAppList.GetAppById(DLCId).ConfigureAwait(false));
                }

                var dlcsection = new Section("app::dlcs") { new Property("unlock_all", "0", " should the emu report all DLCs as unlocked, default=1") };


                foreach (var DLC in DLCInfos)
                {
                    string name;
                    string id;
                    name = DLC.Name;
                    if (DLC.AppId.HasValue)
                    {
                        id = DLC.AppId.Value.ToString();
                    }
                    else
                    {
                        id = "";
                    }
                    dlcsection.Add(new Property(id, name));
                    
                }

                dlcsection.Items.Add(new BlankLine());
                config_app.Add(dlcsection);
            }
            catch (Exception ex)
            {
                _log.Information(ex, "Failed to generate DLCs. Skipping...");
            }
            _log.Debug("Generated DLCs.");
        }

        private async Task GenerateInventory()
        {
            try
            {
                if (UseXan105API)
                {
                    _log.Debug("Using xan105 API, skipping generate inventory...");
                }
                _log.Debug("Generating inventory info...");
                string digest = null;
                using (var client = new HttpClient())
                {
                    _log.Debug("Getting inventory digest...");
                    JsonDocument digestJson;
                    client.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                    var apiUrl = $"https://api.steampowered.com/IInventoryService/GetItemDefMeta/v1?key={SteamWebAPIKey}&appid={AppID}";

                    client.Timeout = TimeSpan.FromSeconds(30);
                    var response = await LimitSteamWebApiGET(client,
                    new HttpRequestMessage(HttpMethod.Get, apiUrl));
                    var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var responseCode = response.StatusCode;
                    if (responseCode == HttpStatusCode.OK)
                    {
                        _log.Debug("Got inventory digest.");
                        digestJson = JsonDocument.Parse(responseBody);
                    }
                    else if (responseCode == HttpStatusCode.Forbidden && !UseXan105API)
                    {
                        _log.Error("Error 403 in getting game inventory digest, please check your Steam Web API key. Skipping...");
                        throw new Exception("Error 403 in getting game inventory digest.");
                    }
                    else
                    {
                        _log.Error("Error {Code} in getting game inventory digest. Skipping...", responseCode);
                        throw new Exception($"Error {responseCode} in getting game inventory digest. Skipping...");
                    }

                    if (response.Content != null)
                    {
                        var responsejson = JsonDocument.Parse(await response.Content.ReadAsStringAsync().ConfigureAwait(false));
                        if (responsejson.RootElement.TryGetProperty("response", out var responsedata))
                        {
                            digest = responsedata.GetProperty("digest").ToString();
                        }
                    }
                    if (digest == null)
                    {
                        _log.Debug("No inventory digest, skipping...");
                        return;
                    }
                }
                using (var client = new HttpClient())
                {
                    _log.Debug("Getting inventory items...");
                    client.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                    client.Timeout = TimeSpan.FromSeconds(30);
                    var response = await LimitSteamWebApiGET(client, new HttpRequestMessage(HttpMethod.Get, $"https://api.steampowered.com/IGameInventory/GetItemDefArchive/v0001?appid={AppID}&digest={digest.Trim(new char[] { '"' })}")).ConfigureAwait(false);

                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        if (response.Content != null)
                        {
                            var content = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                            JsonArray items = JsonNode.Parse(content.Trim(new char[] { '\0' })).Root.AsArray();
                            if (items.Count > 0)
                            {
                                _log.Debug("Found items, generating...");
                                var inventory = new JsonObject();
                                var inventorydefault = new JsonObject();
                                foreach (var item in items)
                                {
                                    var x = new JsonObject();
                                    var index = item["itemdefid"].ToString();

                                    foreach (var t in item.AsObject())
                                    {
                                        x.Add(t.Key, t.Value.ToString());
                                    }
                                    inventory.Add(index, x);
                                    inventorydefault.Add(index, 1);
                                }
                                File.WriteAllText(Path.Combine(ConfigPath, "items.json"), inventory.ToString());
                                File.WriteAllText(Path.Combine(ConfigPath, "default_items.json"), inventorydefault.ToString());
                                return;
                            }
                        }
                        else
                        {
                            _log.Information("No inventory items. Skipping...");
                            return;
                        }
                    }
                    else
                    {
                        throw new Exception($"Error {response.StatusCode} in getting game inventory.");
                    }
                }
                
                _log.Debug("Generated inventory info.");
            }
            catch (KeyNotFoundException)
            {
                _log.Information("No inventory, skipping...");
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to generate inventory info. Skipping...");
            }
        }

        public override async Task InfoGenerator()
        {
            try
            {
                await GenerateBasic().ConfigureAwait(false);
                if (GetGameSchema().GetAwaiter().GetResult())
                {
                    var Tasks2 = new List<Task> { GenerateAchievements(), GenerateStats() , GenerateDLCs(), GenerateInventory() };
                    while (Tasks2.Count > 0)
                    {
                        Task finishedTask2 = await Task.WhenAny(Tasks2);
                        Tasks2.Remove(finishedTask2);
                    }
                }

                WriteIni();
            }
            catch (Exception e)
            {
                throw new Exception(e.ToString());
            }

        }

    }
    internal class GeneratorOffline : Generator
    {
        public GeneratorOffline(EMUGameInfoConfig GameInfoConfig) : base(GameInfoConfig)
        {
        }
        public override async Task InfoGenerator()
        {
            _log.Debug("Generator Offline, skip generating other files...");
            await GenerateBasic().ConfigureAwait(false);
        }
    }
}



    
