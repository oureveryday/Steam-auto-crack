using Serilog;
using SharpSevenZip;
using System.Text.Json;

namespace SteamAutoCrack.Core.Utils
{
    public class EMUUpdater
    {
        public static bool Downloading = false;
        private readonly ILogger _log;
        private const string GoldbergReleaseUrl = "https://api.github.com/repos/otavepto/gbe_fork/releases";
        private const string GoldbergVersionUrl = "https://api.github.com/repos/otavepto/gbe_fork/commits";
        private string currentcommit;
        private string latestcommit;
        private bool bGotlatestcommit = false;
        private bool bInited = false;
        
        private List<string> goldberguselessFolders = new List<string>
        {
            "steamclient_experimental",
            "tools",
            "release",
            "regular"
        };

        public EMUUpdater()
        {
            _log = Log.ForContext<EMUUpdater>();
            
        }
        private CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();

        public async Task Init()
        {
            currentcommit = GetCurrentGoldbergVersion();
            latestcommit = await GetLatestGoldbergVersion().ConfigureAwait(false);
            bInited = true;
        }
        public async Task<bool> Download(bool force = false)
        {
            if (Downloading)
            {
                _log.Information("Already Downloading Goldberg Emulator...");
                return false;
            }
            Downloading = true;
            try
            {
                if (!bInited)
                {
                    throw new Exception("Not initialized EMUUpdater.");
                }
                _log.Information("Initializing download...");
                if (!Directory.Exists(Config.Config.GoldbergPath)) Directory.CreateDirectory(Config.Config.GoldbergPath);

                var delayTask = Task.Delay(30000, cancellationTokenSource.Token);
                var waitTask = Task.Run(async () =>
                {
                    while (!bGotlatestcommit && !cancellationTokenSource.IsCancellationRequested)
                    {
                        await Task.Delay(100);
                    }
                    cancellationTokenSource.Cancel();
                }, cancellationTokenSource.Token);

                await Task.WhenAny(delayTask, waitTask);

                if (!bGotlatestcommit)
                {
                    throw new Exception("Failed to get latest commit.");
                }

                _log.Information($"Goldberg commit: Current: {currentcommit}; Latest: {latestcommit}");
                if (force)
                {
                    await StartDownload().ConfigureAwait(false);
                    await Extract(Path.Combine(Config.Config.TempPath, "Goldberg.7z")).ConfigureAwait(false);
                    await Clean(Config.Config.GoldbergPath);
                    File.WriteAllText(Path.Combine(Config.Config.GoldbergPath, "commit_id"), latestcommit);
                }
                else
                {
                    if (currentcommit.Equals(latestcommit))
                    {
                        _log.Information("Goldberg emulator already updated to latest version.");
                    }
                    else
                    {
                        await StartDownload().ConfigureAwait(false);
                        await Extract(Path.Combine(Config.Config.TempPath, "Goldberg.7z")).ConfigureAwait(false);
                        await Clean(Config.Config.GoldbergPath);
                        File.WriteAllText(Path.Combine(Config.Config.GoldbergPath, "commit_id"),latestcommit);
                    }
                }
                _log.Information("Update Success.");
                Downloading = false;
                return true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Error in download latest version goldberg emulator.");
                Downloading = false;
                return false;
            }
        }

        private async Task StartDownload()
        {
            _log.Information("Downloading...");
            string downloadUrl = String.Empty;
            if (!Directory.Exists(Config.Config.TempPath)) Directory.CreateDirectory(Config.Config.TempPath);
            _log.Debug("Getting Download Url...");
            var client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(30);
            client.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36");
            var response = await client.GetAsync(GoldbergReleaseUrl).ConfigureAwait(false);
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                using (JsonDocument document = JsonDocument.Parse(content))
                {
                    JsonElement roots = document.RootElement;
                    foreach (JsonElement root in roots.EnumerateArray())
                    {
                        JsonElement assets = root.GetProperty("assets");
                        foreach (JsonElement asset in assets.EnumerateArray())
                        {
                            if (asset.GetProperty("name").GetString() == "emu-win-release.7z")
                            {
                                downloadUrl = asset.GetProperty("browser_download_url").GetString();
                                break;
                            }
                        }

                        if (downloadUrl != String.Empty) break;
                    }
                    
                }
            }
            else
            {
                _log.Error("Failed to get latest Goldberg Steam emulator version, error: " + response.StatusCode);
            }

            if (downloadUrl == String.Empty)
            {
                throw new Exception("Failed to get download url.");
            }

            _log.Debug("Downloading URL: {downloadUrl}", downloadUrl);
            await using var fileStream = File.OpenWrite(Path.Combine(Config.Config.TempPath, "Goldberg.7z"));
            //client.GetAsync(downloadUrl, HttpCompletionOption.ResponseHeadersRead)
            var httpRequestMessage = new HttpRequestMessage(HttpMethod.Head, downloadUrl);
            var headResponse = await client.SendAsync(httpRequestMessage).ConfigureAwait(false);
            var contentLength = headResponse.Content.Headers.ContentLength;
            await client.GetFileAsync(downloadUrl, fileStream).ContinueWith(async t =>
            {
                await fileStream.DisposeAsync().ConfigureAwait(false);
                var fileLength = new FileInfo(Path.Combine(Config.Config.TempPath, "Goldberg.7z")).Length;
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

            var dllPaths = AppContext.GetData("NATIVE_DLL_SEARCH_DIRECTORIES").ToString();

            var pathsList = new List<string>(dllPaths.Split(';'));
            string dllPath = "";

            foreach (var path in pathsList)
            {
                var fullPath = Path.Combine(path, "x86", "7z.dll");
                if (File.Exists(fullPath))
                {
                    dllPath = fullPath;
                    break;
                }
            }

            if (string.IsNullOrEmpty(dllPath))
            {
                throw new FileNotFoundException("7z.dll not found in .Net temp path.");
            }

            SharpSevenZipBase.SetLibraryPath(dllPath);

            using (var archive = new SharpSevenZipExtractor(File.Open(archivePath, FileMode.Open)))
            {
                try
                {
                    Directory.CreateDirectory(Config.Config.GoldbergPath);
                    archive.ExtractArchive(Config.Config.GoldbergPath);
                    CopyDirectory(new DirectoryInfo(Path.Combine(Config.Config.GoldbergPath, "release")), new DirectoryInfo(Config.Config.GoldbergPath));
                    CopyDirectory(new DirectoryInfo(Path.Combine(Config.Config.GoldbergPath, "regular")), new DirectoryInfo(Config.Config.GoldbergPath));
                }
                catch (Exception ex)
                {
                    errorOccured = true;
                    _log.Error(ex, $"Error while trying to extract.");
                    
                }
            }
            _log.Information("Extraction was successful.");
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
                _log.Information("Clean was successful.");
            }
            catch (Exception ex)
            {
                _log.Error(ex,"Failed in clean Goldberg emulator files.");
            }
        }
        private string GetCurrentGoldbergVersion()
        {
            try
            {
                var ver = File.ReadLines(Path.Combine(Config.Config.GoldbergPath, "commit_id")).First();
                
                return ver;
            }
            catch(Exception ex)
            {
                _log.Error(ex,"Failed to get current Goldberg Steam emulator version.");
                return String.Empty;
            }
        }
        private async Task<string> GetLatestGoldbergVersion()
        {
            try
            {
                _log.Information("Getting latest goldberg emulator version...");
                string ver = String.Empty;
                var client = new HttpClient();
                client.Timeout = TimeSpan.FromSeconds(30);
                client.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36");
                var response = await client.GetAsync(GoldbergVersionUrl).ConfigureAwait(false);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    using (JsonDocument document = JsonDocument.Parse(content))
                    {
                        JsonElement root = document.RootElement;
                        ver = root[0].GetProperty("sha").ToString();
                    }
                }
                else
                {
                    _log.Error("Failed to get latest Goldberg Steam emulator version, error: " + response.StatusCode );
                    cancellationTokenSource.Cancel();
                    return String.Empty;
                }


                if (ver == String.Empty)
                {
                    _log.Error("Failed to get latest Goldberg Steam emulator version.");
                }

                bGotlatestcommit = true;
                return ver;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to get latest Goldberg Steam emulator version.");
                bGotlatestcommit = true;
                return String.Empty;
            }
        }
        private void CopyDirectory(DirectoryInfo source, DirectoryInfo target)
        {
            Directory.CreateDirectory(target.FullName);

            // Copy each file into the new directory.
            foreach (FileInfo fi in source.GetFiles())
            {
                fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
            }

            // Copy each subdirectory using recursion.
            foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
            {
                DirectoryInfo nextTargetSubDir =
                    target.CreateSubdirectory(diSourceSubDir.Name);
                CopyDirectory(diSourceSubDir, nextTargetSubDir);
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


