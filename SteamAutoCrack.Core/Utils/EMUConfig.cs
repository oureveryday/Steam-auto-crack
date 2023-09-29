using Serilog;
using SteamKit2;
using System.Globalization;

namespace SteamAutoCrack.Core.Utils
{
    public class EMUConfig
    {
        private readonly ILogger _log;
        public EMUConfig()
        {
            _log = Log.ForContext<EMUConfig>();
        }
        public enum Languages { arabic, bulgarian, schinese, tchinese, czech, danish, dutch, english, finnish, french, german, greek, hungarian, italian, japanese, koreana, norwegian, polish, portuguese, brazilian, romanian, russian, spanish, latam, swedish, thai, turkish, ukrainian, vietnamese };
        /// <summary>
        /// Set game language.
        /// </summary>
        public Languages Language { get; set; } = EMUConfigDefault.GetDefaultLanguage();
        /// <summary>
        /// Set Steam ID.
        /// </summary>
        public SteamID SteamID { get; set; } = 76561197960287930;
        /// <summary>
        /// Set Steam account name.
        /// </summary>
        public string AccountName { get; set; } = "Goldberg";
        /// <summary>
        /// Set custom emulator listen port.
        /// </summary>
        public ushort ListenPort { get; set; } = 47584;
        /// <summary>
        /// Set Custom broadcast IP.
        /// </summary>
        public string CustomIP { get; set; } = "127.0.0.1";
        /// <summary>
        /// Generate custom_broadcasts.txt
        /// </summary>
        public bool UseCustomIP { get; set; } = false;
        /// <summary>
        /// Generate force_language.txt
        /// </summary>
        public bool LanguageForce { get; set; } = true;
        /// <summary>
        /// Generate force_steamid.txt
        /// </summary>
        public bool SteamIDForce { get; set; } = true;
        /// <summary>
        /// Generate force_account_name.txt
        /// </summary>
        public bool AccountNameForce { get; set; } = true;
        /// <summary>
        /// Generate force_listen_port.txt
        /// </summary>
        public bool ListenPortForce { get; set; } = true;
        /// <summary>
        /// Disable all the networking functionality of the Steam emulator.
        /// </summary>
        public bool DisableNetworking { get; set; } = false;
        /// <summary>
        /// Emable Steam emulator offline mode.
        /// </summary>
        public bool Offline { get; set; } = false;
        /// <summary>
        /// Disable Steam emulator overlay.
        /// </summary>
        public bool DisableOverlay { get; set; } = false;

        public string? ConfigPath { get; set; } = Path.Combine(Config.Config.TempPath, "steam_settings");

        public void SetLaugnageFromString(string str)
        {
            if (!Enum.TryParse<Languages>(str, false, out var language))
            {
                _log.Error("Invaild language.");
                throw new Exception("Invaild language.");
            }
            Language = language;
        }

        public void SetSteamIDFromString(string str)
        {
            if (!UInt64.TryParse(str, out var steamIDUInt64))
            {
                _log.Error("Invaild SteamID.");
                throw new Exception("Invaild SteamID.");
            }
            SteamID.SetFromUInt64(steamIDUInt64);
        }

        public void SetListenPortFromString(string str)
        {
            if (!ushort.TryParse(str, out var listenport))
            {
                _log.Error("Invaild listen port.");
                throw new Exception("Invaild listen port.");
            }
            ListenPort = listenport;
        }

        public void SetCustomIPFromString(string str)
        {
            var a = Uri.CheckHostName(str);
            if (Uri.CheckHostName(str) != UriHostNameType.IPv4 && Uri.CheckHostName(str) != UriHostNameType.IPv6)
            {
                _log.Error("Invaild Custom Broadcast IP.");
                throw new Exception("Invaild Custom Broadcast IP.");
            }
            CustomIP = str;
        }
    }

    public class EMUConfigDefault
    {
        public static EMUConfig.Languages GetDefaultLanguage()
        {
            var language = EMUConfig.Languages.english;
            string culture = CultureInfo.InstalledUICulture.Name;
            switch (culture.Substring(0,2))
            {
                case "ar": language = EMUConfig.Languages.arabic; break;
                case "bg": language = EMUConfig.Languages.bulgarian; break;
                case "zh":
                   switch(culture)
                    {
                        case "zh-Hans":
                        case "zh":
                        case "zh-CN":
                        case "zh-SG":
                            language = EMUConfig.Languages.schinese; break;
                        case "zh-Hant":
                        case "zh-HK":
                        case "zh-MO":
                        case "zh-TW":
                            language = EMUConfig.Languages.tchinese; break; 
                        default: language = EMUConfig.Languages.schinese; break;
                    }break;
                case "cz": language = EMUConfig.Languages.czech; break;
                case "da": language = EMUConfig.Languages.danish; break;
                case "nl": language = EMUConfig.Languages.dutch; break;
                case "en": language = EMUConfig.Languages.english; break;
                case "fi": language = EMUConfig.Languages.finnish; break;
                case "fr": language = EMUConfig.Languages.french; break;
                case "de": language = EMUConfig.Languages.dutch; break;
                case "el": language = EMUConfig.Languages.greek; break;
                case "hu": language = EMUConfig.Languages.hungarian; break;
                case "it": language = EMUConfig.Languages.italian; break;
                case "ja": language = EMUConfig.Languages.japanese; break;
                case "ko": language = EMUConfig.Languages.koreana; break;
                case "no": language = EMUConfig.Languages.norwegian; break;
                case "nb": language = EMUConfig.Languages.norwegian; break;
                case "nn": language = EMUConfig.Languages.norwegian; break;
                case "pl": language = EMUConfig.Languages.polish; break;
                case "pt": language = EMUConfig.Languages.portuguese; break;
                case "ro": language = EMUConfig.Languages.romanian; break;
                case "ru": language = EMUConfig.Languages.russian; break;
                case "es": language = EMUConfig.Languages.spanish; break;
                case "sv": language = EMUConfig.Languages.swedish; break;
                case "th": language = EMUConfig.Languages.thai; break;
                case "tr": language = EMUConfig.Languages.turkish; break;
                case "uk": language = EMUConfig.Languages.ukrainian; break;
                case "vi": language = EMUConfig.Languages.vietnamese; break;
                default: language = EMUConfig.Languages.english; break;
            }
            return language;
        }
        /// <summary>
        /// Set game language.
        /// </summary>
        public static readonly EMUConfig.Languages Language = GetDefaultLanguage();
        /// <summary>
        /// Set Steam ID.
        /// </summary>
        public static readonly SteamID SteamID = 76561197960287930;
        /// <summary>
        /// Set Steam account name.
        /// </summary>
        public static readonly string AccountName = "Goldberg";
        /// <summary>
        /// Set custom emulator listen port.
        /// </summary>
        public static readonly ushort ListenPort = 47584;
        /// <summary>
        /// Set Custom broadcast IP.
        /// </summary>
        public static readonly string CustomIP = "127.0.0.1";
        /// <summary>
        /// Generate custom_broadcasts.txt
        /// </summary>
        public static readonly bool UseCustomIP = false;
        /// <summary>
        /// Generate force_language.txt
        /// </summary>
        public static readonly bool LanguageForce = true;
        /// <summary>
        /// Generate force_steamid.txt
        /// </summary>
        public static readonly bool SteamIDForce = true;
        /// <summary>
        /// Generate force_account_name.txt
        /// </summary>
        public static readonly bool AccountNameForce = true;
        /// <summary>
        /// Generate force_listen_port.txt
        /// </summary>
        public static readonly bool ListenPortForce = true;
        /// <summary>
        /// Disable all the networking functionality of the Steam emulator.
        /// </summary>
        public static readonly bool DisableNetworking = false;
        /// <summary>
        /// Emable Steam emulator offline mode.
        /// </summary>
        public static readonly bool Offline = false;
        /// <summary>
        /// Disable Steam emulator overlay.
        /// </summary>
        public static readonly bool DisableOverlay = false;
        public static readonly string? ConfigPath = Path.Combine(Config.Config.TempPath, "steam_settings");
    }

    public interface IEMUConfigGenerator
    {
        public Task<bool> Generate(EMUConfig EMUConfig);
    }

    public class EMUConfigGenerator : IEMUConfigGenerator
    {
        private readonly ILogger _log;
        public EMUConfigGenerator() 
        {
            _log = Log.ForContext<EMUConfigGenerator>();
        }
        public async Task<bool> Generate(EMUConfig EMUConfig)
        {
            try
            {
                _log.Debug("Generating emulator config...");
                if (!File.Exists(Path.Combine(EMUConfig.ConfigPath, "steam_appid.txt")))
                {
                    _log.Error("Emulator Config Not Exist. (Please generate emulator game info first)");
                    return false;
                }
                var deletefilelist = new List<string>()
                {
                    Path.Combine(EMUConfig.ConfigPath, "force_language.txt"),
                    Path.Combine(EMUConfig.ConfigPath,"settings", "language.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "force_steamid.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "settings", "user_steam_id.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "force_account_name.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "settings", "account_name.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "force_listen_port.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "settings", "listen_port.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "offline.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "disable_networking.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "disable_overlay.txt"),
                    Path.Combine(EMUConfig.ConfigPath, "custom_broadcasts.txt"),
                };
                foreach (var file in deletefilelist)
                {
                    if(File.Exists(file))
                    {
                        File.Delete(file);
                    }
                }
                if (Directory.Exists(Path.Combine(EMUConfig.ConfigPath, "settings")) && !Directory.EnumerateFileSystemEntries(Path.Combine(EMUConfig.ConfigPath, "settings")).Any())
                {
                    Directory.Delete(Path.Combine(EMUConfig.ConfigPath, "settings"));
                }
                if (!EMUConfig.LanguageForce || !EMUConfig.SteamIDForce || !EMUConfig.SteamIDForce || !EMUConfig.AccountNameForce)
                {
                    Directory.CreateDirectory(Path.Combine(EMUConfig.ConfigPath,"settings"));
                }
                if (EMUConfig.LanguageForce)
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "force_language.txt"), EMUConfig.Language.ToString());
                }
                else
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath,"settings", "language.txt"), EMUConfig.Language.ToString());
                }
                if (EMUConfig.SteamIDForce)
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "force_steamid.txt"), EMUConfig.SteamID.ConvertToUInt64().ToString());
                }
                else
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "settings", "user_steam_id.txt"), EMUConfig.SteamID.ConvertToUInt64().ToString());
                }
                if (EMUConfig.AccountNameForce)
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "force_account_name.txt"), EMUConfig.AccountName == "" ? EMUConfigDefault.AccountName : EMUConfig.AccountName);
                }
                else
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "settings", "account_name.txt"), EMUConfig.AccountName == "" ? EMUConfigDefault.AccountName : EMUConfig.AccountName);
                }
                if (EMUConfig.ListenPortForce)
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "force_listen_port.txt"), EMUConfig.ListenPort.ToString());
                }
                else
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "settings", "listen_port.txt"), EMUConfig.ListenPort.ToString());
                }
                if (EMUConfig.Offline)
                {
                    File.Create(Path.Combine(EMUConfig.ConfigPath, "offline.txt"));
                }
                if (EMUConfig.DisableNetworking)
                {
                    File.Create(Path.Combine(EMUConfig.ConfigPath, "disable_networking.txt"));
                }
                if (EMUConfig.DisableOverlay)
                {
                    File.Create(Path.Combine(EMUConfig.ConfigPath, "disable_overlay.txt"));
                }
                if (EMUConfig.UseCustomIP)
                {
                    File.WriteAllText(Path.Combine(EMUConfig.ConfigPath, "custom_broadcasts.txt"), EMUConfig.CustomIP);
                }
                _log.Debug("Generated emulator config.");
                return true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "Failed to generate Steam emulator config.");
                return false;
            }
        }
    }
}
