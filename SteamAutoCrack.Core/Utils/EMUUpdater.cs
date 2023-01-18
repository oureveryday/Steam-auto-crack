using Serilog;
using SteamAutoCrack.Core.Config;
using SteamKit2.GC.Artifact.Internal;
using System.IO.Compression;
using System.Linq.Expressions;
using System.Runtime.ConstrainedExecution;
using System.Text.RegularExpressions;

namespace SteamAutoCrack.Core.Utils
{
    public class EMUUpdater
    {
        private readonly ILogger _log;
        private const string GoldbergUrl = "https://mr_goldberg.gitlab.io/goldberg_emulator/";
        private UInt64 currentjobid = 0;
        private UInt64 latestjobid = 0;
        private bool bGotlatestjobid = false;
        private bool bInited = false;
        private List<string> goldberguselessFolders = new List<string>
        {
            "debug_experimental",
            "debug_experimental_steamclient",
            "experimental_steamclient",
            "linux",
            "source_code",
            "tools",
            "lobby_connect"
        };

        public EMUUpdater()
        {
            _log = Log.ForContext<EMUUpdater>();
            
        }
        public async Task Init()
        {
            currentjobid = GetCurrentGoldbergVersion();
            latestjobid = await GetLatestGoldbergVersion().ConfigureAwait(false);
            bInited = true;
            return;
        }
        public async Task<bool> Download(bool force = false)
        {
            try
            {
                if (!bInited)
                {
                    throw new Exception("Not initialized EMUUpdater.");
                }
                _log.Information("Initializing download...");
                if (!Directory.Exists(Config.Config.GoldbergPath)) Directory.CreateDirectory(Config.Config.GoldbergPath);
                while (!bGotlatestjobid) { }
                _log.Information($"Goldberg job_id: Current {currentjobid}; Latest {latestjobid}");
                if (latestjobid == 0)
                {
                    throw new Exception("Failed in getting latest jobid. Skipping...");
                }
                if (force)
                {
                    await StartDownload(latestjobid).ConfigureAwait(false);
                    await Extract(Path.Combine(Config.Config.TempPath, "Goldberg.zip")).ConfigureAwait(false);
                    await Clean(Config.Config.GoldbergPath);
                }
                else
                {
                    if (currentjobid.Equals(latestjobid))
                    {
                        _log.Information("Goldberg emulator already updated to latest version.");
                    }
                    else
                    {
                        await StartDownload(latestjobid).ConfigureAwait(false);
                        await Extract(Path.Combine(Config.Config.TempPath, "Goldberg.zip")).ConfigureAwait(false);
                        await Clean(Config.Config.GoldbergPath);
                    }
                }
                _log.Information("Update Success.");
                return true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Error in download latest version goldberg emulator.");
                return false;
            }
        }

        private async Task StartDownload(UInt64 jobid)
        {
            _log.Information("Downloading...");
            if (!Directory.Exists(Config.Config.TempPath)) Directory.CreateDirectory(Config.Config.TempPath);
            var client = new HttpClient();
            var downloadUrl = "https://gitlab.com/Mr_Goldberg/goldberg_emulator/-/jobs/" + jobid.ToString() + "/artifacts/download";
            _log.Debug("Downloading URL: {downloadUrl}", downloadUrl);
            await using var fileStream = File.OpenWrite(Path.Combine(Config.Config.TempPath, "Goldberg.zip"));
            //client.GetAsync(downloadUrl, HttpCompletionOption.ResponseHeadersRead)
            var httpRequestMessage = new HttpRequestMessage(HttpMethod.Head, downloadUrl);
            var headResponse = await client.SendAsync(httpRequestMessage).ConfigureAwait(false);
            var contentLength = headResponse.Content.Headers.ContentLength;
            await client.GetFileAsync(downloadUrl, fileStream).ContinueWith(async t =>
            {
                await fileStream.DisposeAsync().ConfigureAwait(false);
                var fileLength = new FileInfo(Path.Combine(Config.Config.TempPath, "Goldberg.zip")).Length;
                if (contentLength == fileLength)
                {
                    _log.Information("Download finished.");
                }
                else
                {
                    throw new Exception("File size does not match. Skipping...");
                }
            }).ConfigureAwait(false);
        }
        private async Task Extract(string archivePath)
        {
            var errorOccured = false;
            _log.Debug("Start extraction...");
            Directory.Delete(Config.Config.GoldbergPath, true);
            Directory.CreateDirectory(Config.Config.GoldbergPath);
            using (var archive = await Task.Run(() => ZipFile.OpenRead(archivePath)).ConfigureAwait(false))
            {
                foreach (var entry in archive.Entries)
                {
                    await Task.Run(() =>
                    {
                        try
                        {
                            var fullPath = Path.Combine(Config.Config.GoldbergPath, entry.FullName);
                            if (string.IsNullOrEmpty(entry.Name))
                            {
                                Directory.CreateDirectory(fullPath);
                            }
                            else
                            {
                                entry.ExtractToFile(fullPath, true);
                            }
                        }
                        catch (Exception e)
                        {
                            errorOccured = true;
                            _log.Error(e,$"Error while trying to extract {entry.FullName}");
                            return;
                        }
                    }).ConfigureAwait(false);
                }
            }
            _log.Information("Extraction was successful!");
        }
        private async Task Clean(string goldbergPath)
        {
            try
            {
                _log.Debug("Start Clean Goldberg emulator Files...");
                foreach (var path in goldberguselessFolders)
                {
                    Directory.Delete(Path.Combine(goldbergPath, path), true);
                }
                _log.Information("Clean was successful!");
            }
            catch (Exception e)
            {
                _log.Error(e,"Failed in clean Goldberg emulator files.");
            }
        }
        private UInt64 GetCurrentGoldbergVersion()
        {
            try
            {
                var ver = File.ReadLines(Path.Combine(Config.Config.GoldbergPath, "job_id")).First();
                if (!UInt64.TryParse(ver, out var veruint64))
                {
                    throw new Exception();
                }
                return veruint64;
            }
            catch(Exception ex)
            {
                _log.Error(ex,"Failed to get current Goldberg Steam emulator version.");
                return 0;
            }
        }
        private async Task<UInt64> GetLatestGoldbergVersion()
        {
            try
            {
                _log.Information("Getting latest goldberg emulator jobid...");
                var client = new HttpClient();
                client.Timeout = TimeSpan.FromSeconds(30);
                var response = await client.GetAsync(GoldbergUrl).ConfigureAwait(false);
                var body = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                var regex = new Regex(
                    @"https:\/\/gitlab\.com\/Mr_Goldberg\/goldberg_emulator\/-\/jobs\/(?<jobid>.*)\/artifacts\/download");
                var match = regex.Match(body);
                bGotlatestjobid = true;
                if (!UInt64.TryParse(match.Groups["jobid"].Value, out var veruint64))
                {
                    throw new Exception();
                }
                return veruint64;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to get latest Goldberg Steam emulator version.");
                bGotlatestjobid = true;
                return 0;
            }
        }
    
    

    }
}
    public static class Extensions
    {
        public static async Task GetFileAsync(this HttpClient client, string requestUri, Stream destination,
            CancellationToken cancelToken = default)
        {
            var response = await client.GetAsync(requestUri, HttpCompletionOption.ResponseHeadersRead, cancelToken)
                .ConfigureAwait(false);
            await using var download = await response.Content.ReadAsStreamAsync().ConfigureAwait(false);
            await download.CopyToAsync(destination, cancelToken).ConfigureAwait(false);
            if (destination.CanSeek) destination.Position = 0;
        }
    }


