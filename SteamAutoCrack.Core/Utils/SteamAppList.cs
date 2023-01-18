using NinjaNye.SearchExtensions;
using Serilog;
using SQLite;
using System.Text.Json;
using System.Text.Json.Serialization;
using FuzzySharp;
using System.Security.Cryptography.X509Certificates;
using FuzzySharp.SimilarityRatio.Scorer.StrategySensitive;
using FuzzySharp.SimilarityRatio;
using FuzzySharp.SimilarityRatio.Scorer.Composite;
using System.Collections.Immutable;
using System.Collections.Generic;
using SteamAutoCrack.Core.Config;

namespace SteamAutoCrack.Core.Utils
{
    [Table("steamapp")]
        public class SteamApp
        {
            [JsonPropertyName("appid")]
            [Column("appid")]
            [PrimaryKey]
            public uint? AppId { get; set; }

            [JsonPropertyName("name")]
            [Column("name")]
            public string? Name { get; set; }

            public override string ToString()
            {
                return $"{AppId}={Name}";
            }
        }

        public class AppList
        {
            [JsonPropertyName("apps")] public List<SteamApp>? Apps { get; set; }
        }

        public class SteamAppsV2
        {
            [JsonPropertyName("applist")] public AppList AppList { get; set; }
        }

        public class SteamAppList
        {

        private static readonly string steamapplisturl = "https://api.steampowered.com/ISteamApps/GetAppList/v2/";

        private static ILogger _log;

        private static bool bInited = false;

        private static bool bDisposed = false;

        private const int FuzzySearchScore = 80;

        private static readonly string Database = Path.Combine(Config.Config.TempPath, "SteamAppList.db");

        public static SQLiteAsyncConnection db;

        public static async Task Initialize(bool forceupdate = false)
        {
            _log = Log.ForContext<SteamAppList>();
            bDisposed= true;
            if (bInited && !forceupdate)
            {
                _log.Debug("Already initialized Steam App list.");
                return;
            }

            _log.Debug("Initializing Steam App list...");
            bInited = false;
            if (!Directory.Exists(Config.Config.TempPath))
            {
                Directory.CreateDirectory(Config.Config.TempPath);
            }
            db = new SQLiteAsyncConnection(Database);
            await db.CreateTableAsync<SteamApp>().ConfigureAwait(false);
            var countAsync = await db.Table<SteamApp>().CountAsync().ConfigureAwait(false);
            if (DateTime.Now.Subtract(File.GetLastWriteTimeUtc(Database)).TotalDays >= 1 || countAsync == 0 || forceupdate == true)
            {
                _log.Information($"Updating Steam Applist...");
                var client = new HttpClient();
                var appList = new HashSet<SteamApp>();
                var response = await client.GetAsync(steamapplisturl).ConfigureAwait(false);
                var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                var steamApps = DeserializeSteamApps(responseBody);
                foreach (var appListApp in steamApps.AppList.Apps) appList.Add(appListApp);
                await db.InsertAllAsync(appList, "OR IGNORE").ConfigureAwait(false);
                _log.Information("Updated Steam App list.");
            }
            else
            {
                _log.Information("Applist already updated to latest version.");
            }
            _log.Debug("App Count: {count}", db.Table<SteamApp>().CountAsync().ConfigureAwait(false).GetAwaiter().GetResult());
            _log.Information("Initialized Steam App list.");
            bInited = true;
            return;
            }

        public static async Task WaitForReady()
        {
            if (bDisposed== false)
            {
                _log.Error("Not initialized Steam App list.");
                throw new Exception("Not initialized Steam App list.");
            }
            _log.Debug("Waiting for Steam App list initialized...");
            while (!bInited) { }
            return;
        }

        private static SteamAppsV2 DeserializeSteamApps(string json)
        {
            SteamAppsV2 data = JsonSerializer.Deserialize<SteamAppsV2>(json);
            return data;
        }
        public static async Task<IEnumerable<SteamApp>> GetListOfAppsByName(string name)
        {
            var query = await db.Table<SteamApp>().ToListAsync().ConfigureAwait(false);
            var listOfAppsByName = query.Search(x => x.Name)
                .SetCulture(StringComparison.OrdinalIgnoreCase)
                .ContainingAll(name.Split(' '));
            return listOfAppsByName;
        }

        public static async Task<IEnumerable<SteamApp>> GetListOfAppsByNameFuzzy(string name)
        {
            var query = await db.Table<SteamApp>().ToListAsync().ConfigureAwait(false);
            var listOfAppsByName = new List<SteamApp>();
            var results = Process.ExtractTop(new SteamApp { Name = name }, query, x => x.Name?.ToLower(), ScorerCache.Get<WeightedRatioScorer>(), FuzzySearchScore);
            foreach (var item in results)
            {
                listOfAppsByName.Add(item.Value);
            }
            return listOfAppsByName;
        }

        public static async Task<SteamApp> GetAppByName(string name)
        {
            _log?.Debug($"Trying to get app name for app: {name}");
            var app = await db.Table<SteamApp>()
                .FirstOrDefaultAsync(x => x.Name.Equals(name))
                .ConfigureAwait(false);
            if (app != null) _log.Debug($"Successfully got app name for app: {app}");
            return app;
        }

        public static async Task<SteamApp> GetAppById(uint appid)
        {
            _log.Debug($"Trying to get app with ID {appid}");
            var app = await db.Table<SteamApp>().FirstOrDefaultAsync(x => x.AppId.Equals(appid)).ConfigureAwait(false);
            if (app != null) _log.Debug($"Successfully got app {app}");
            return app;
        }
    }

        

}
