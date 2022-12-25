using Serilog;
using Serilog.Core;
using Serilog.Events;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.Core.Utils.SteamAutoCrack.Core.Utils;
using System.DirectoryServices.ActiveDirectory;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace SteamAutoCrack.Core.Config
{
    public class Config
    {
        [JsonIgnore]
        private static readonly ILogger _log = Log.ForContext<Config>();
        /// <summary>
        /// Temp file path.
        /// </summary>
        public static string? TempPath { get; set; } = Path.Combine(Directory.GetCurrentDirectory(), "TEMP");
        /// <summary>
        /// Config file path.
        /// </summary>
        public static string? ConfigPath { get; set; } = Path.Combine(Directory.GetCurrentDirectory(), "config.json");
        /// <summary>
        /// Steam emulator config path.
        /// </summary>
        public static string? EMUConfigPath { get; set; } = Path.Combine(TempPath, "steam_settings");
        /// <summary>
        /// Path of steam emulator files.
        /// </summary>
        public static string? GoldbergPath { get; set; } = Path.Combine(Directory.GetCurrentDirectory(), "Goldberg");
        /// <summary>
        /// Path to process.
        /// </summary>
        public static string? InputPath { get; set; } = String.Empty;
        /// <summary>
        /// Goldberg emulator job ID.
        /// </summary>
        public static string? GoldbergVersion { get; set; } = GetGoldbergVersion();
        /// <summary>
        /// Enable Crack Applier Mode.
        /// </summary>
        public static bool CrackApplierMode { get; set; } = CheckCrackApplierMode();
        /// <summary>
        /// Save Crack Process Config.
        /// </summary>
        public static bool SaveCrackConfig 
        {
            get
            { 
                return _SaveCrackConfig;
            }
            set
            {
                if (value)
                {
                    SaveConfig();
                }
                else
                {
                    File.Delete(ConfigPath);
                }
                _SaveCrackConfig = value;
            }
        
        } 
        private static bool _SaveCrackConfig = CheckConfigFile();
        /// <summary>
        /// Enable debug log.
        /// </summary>
        public static bool EnableDebugLog 
        {
            get
            {
                return _EnableDebugLog;
            }
            set
            {
                _EnableDebugLog = value;
                if (value) 
                { 
                    loggingLevelSwitch.MinimumLevel = LogEventLevel.Debug; 
                }
                else
                {
                    loggingLevelSwitch.MinimumLevel = LogEventLevel.Information;
                }
            }
        }
        private static bool _EnableDebugLog = false;
        public static readonly LoggingLevelSwitch loggingLevelSwitch = new LoggingLevelSwitch();
        /// <summary>
        /// Output log to file.
        /// </summary>
        public static bool LogToFile { get; set; } = false;

        private static bool CheckConfigFile()
        {
            if (File.Exists(ConfigPath))
            {
                return true;
            }
            return false;
        }

        public static EMUApplyConfigs EMUApplyConfigs { get; set; } = new EMUApplyConfigs();
        public static EMUConfigs EMUConfigs { get; set; } = new EMUConfigs();
        public static SteamAppListConfigs SteamAppListConfigs { get; set; } = new SteamAppListConfigs();
        public static SteamStubUnpackerConfigs SteamStubUnpackerConfigs { get; set; } = new SteamStubUnpackerConfigs();
        public static EMUGameInfoConfigs EMUGameInfoConfigs { get; set; } = new EMUGameInfoConfigs();
        public static GenCrackOnlyConfigs GenCrackOnlyConfigs { get; set; } = new GenCrackOnlyConfigs();
        public static ProcessConfigs ProcessConfigs { get; set; } = new ProcessConfigs();

        public static void CheckInputPath()
        {
            if (!Directory.Exists(EMUConfigPath) && !File.Exists(EMUConfigPath)) 
            {
                throw new Exception("Invaild input path.");
            }
        }
        public static string GetGoldbergVersion()
        {
            try
            {
                var ver = File.ReadLines(Path.Combine(GoldbergPath, "job_id")).First();
                if (!UInt64.TryParse(ver, out _))
                {
                    throw new Exception();
                }
                return ver;
            }
            catch
            {
                _log.Error("Failed to get Goldberg Steam emulator version.");
                return "N/A";
            }
        }
        public static void ResettoDefaultAll()
        {
            EMUConfigPath = Path.Combine(TempPath, "steam_settings");
            GoldbergPath = Path.Combine(Directory.GetCurrentDirectory(), "Goldberg");
            TempPath = Path.Combine(Directory.GetCurrentDirectory(), "TEMP");
            EnableDebugLog = false;
            LogToFile = false;
            ResettoDefaultConfigs();
        }
        public static void ResettoDefaultConfigs()
        {
            EMUApplyConfigs.ResettoDefault();
            EMUConfigs.ResettoDefault();
            SteamAppListConfigs.ResettoDefault();
            SteamStubUnpackerConfigs.ResettoDefault();
            EMUGameInfoConfigs.ResettoDefault();
            GenCrackOnlyConfigs.ResettoDefault();
            ProcessConfigs.ResettoDefault();
        }
        public static bool CheckCrackApplierMode()
        {
            if (File.Exists(Path.Combine(Directory.GetCurrentDirectory(), "Apply_Crack")))
            {
                return true;
            }
            return false;
        }
        public static void SaveConfig()
        {
            try
            {
                var options = new JsonSerializerOptions { WriteIndented = true };
                string jsonString = JsonSerializer.Serialize(new Configs()
                {
                    EMUApplyConfigs = EMUApplyConfigs,
                    EMUConfigs = EMUConfigs,
                    SteamAppListConfigs = SteamAppListConfigs,
                    SteamStubUnpackerConfigs = SteamStubUnpackerConfigs,
                    EMUGameInfoConfigs = EMUGameInfoConfigs,
                    GenCrackOnlyConfigs = GenCrackOnlyConfigs,
                    ProcessConfigs = ProcessConfigs,
                    EnableDebugLog = EnableDebugLog,
                    LogToFile = LogToFile,
                }, options);
                File.WriteAllText(ConfigPath, jsonString);
                return;
            }
            catch(Exception e)
            {
                _log.Error(e,"Error in saving config file.");
                return;
            }
        }
        public static void LoadConfig()
        {
            try
            {
                var jsonString = File.ReadAllText(ConfigPath);
                var configs = JsonSerializer.Deserialize<Configs>(jsonString);
                if (configs != null)
                {
                    EMUApplyConfigs = configs.EMUApplyConfigs ?? EMUApplyConfigs;
                    EMUConfigs = configs.EMUConfigs ?? EMUConfigs;
                    SteamAppListConfigs = configs.SteamAppListConfigs ?? SteamAppListConfigs;
                    SteamStubUnpackerConfigs = configs.SteamStubUnpackerConfigs ?? SteamStubUnpackerConfigs;
                    EMUGameInfoConfigs = configs.EMUGameInfoConfigs ?? EMUGameInfoConfigs;
                    GenCrackOnlyConfigs = configs.GenCrackOnlyConfigs ?? GenCrackOnlyConfigs;
                    ProcessConfigs = configs.ProcessConfigs ?? ProcessConfigs;
                    EnableDebugLog = EnableDebugLog;
                    LogToFile = LogToFile;
                }
                _log.Information("Config loaded.");
                return;
            }
            catch (Exception e)
            {
                _log.Error(e, "Error in reading config file. Restoring to default value...");
                ResettoDefaultConfigs();
                return;
            }
        }
    }
    
    public class Configs
    {
        public EMUApplyConfigs? EMUApplyConfigs { get; set; }
        public EMUConfigs? EMUConfigs { get; set; }
        public SteamAppListConfigs? SteamAppListConfigs { get; set; }
        public SteamStubUnpackerConfigs? SteamStubUnpackerConfigs { get; set; }
        public EMUGameInfoConfigs? EMUGameInfoConfigs { get; set; } 
        public GenCrackOnlyConfigs? GenCrackOnlyConfigs { get; set; } 
        public ProcessConfigs? ProcessConfigs { get; set; }
        public bool EnableDebugLog { get; set; }
        public bool LogToFile { get; set; }
    }
    public class EMUApplyConfigs
    {
        public EMUApplyConfigs() { }
        /// <summary>
        /// Emulator save location.
        /// </summary>
        public string? LocalSave { get; set; } = EMUApplyConfigDefault.LocalSave;
        /// <summary>
        /// Enable change default emulator save location.
        /// </summary>
        public bool UseLocalSave { get; set; } = EMUApplyConfigDefault.UseLocalSave;
        /// <summary>
        /// Use Experimental version of goldberg emulator.
        /// </summary>
        public bool UseGoldbergExperimental { get; set; } = EMUApplyConfigDefault.UseGoldbergExperimental;
        /// <summary>
        /// Detect file sign date and generate steam_interfaces.txt
        /// </summary>
        public bool GenerateInterfacesFile { get; set; } = EMUApplyConfigDefault.GenerateInterfacesFile;
        /// <summary>
        /// Force generate file steam_interfaces.txt (Ignore file sign date)
        /// </summary>
        public bool ForceGenerateInterfacesFiles { get; set; } = EMUApplyConfigDefault.ForceGenerateInterfacesFiles;
        public void ResettoDefault()
        {
            LocalSave = EMUApplyConfigDefault.LocalSave;
            UseLocalSave = EMUApplyConfigDefault.UseLocalSave;
            UseGoldbergExperimental = EMUApplyConfigDefault.UseGoldbergExperimental;
            GenerateInterfacesFile = EMUApplyConfigDefault.GenerateInterfacesFile;
            ForceGenerateInterfacesFiles = EMUApplyConfigDefault.ForceGenerateInterfacesFiles;
        }
        public EMUApplyConfig GetEMUApplyConfig()
        {
            return new EMUApplyConfig
            {
                ApplyPath = Config.InputPath,
                ConfigPath = Config.EMUConfigPath,
                GoldbergPath = Config.GoldbergPath,
                LocalSave = LocalSave,
                UseLocalSave = UseLocalSave,
                UseGoldbergExperimental = UseGoldbergExperimental,
                GenerateInterfacesFile = GenerateInterfacesFile,
                ForceGenerateInterfacesFiles = ForceGenerateInterfacesFiles,
            };
        }
    }

    public class EMUConfigs
    {
        /// <summary>
        /// Set game language.
        /// </summary>
        public EMUConfig.Languages Language { get; set; } = EMUConfigDefault.Language;
        /// <summary>
        /// Set Steam ID.
        /// </summary>
        public string SteamID { get; set; } = EMUConfigDefault.SteamID.ConvertToUInt64().ToString();
        /// <summary>
        /// Set Steam account name.
        /// </summary>
        public string AccountName { get; set; } = EMUConfigDefault.AccountName;
        /// <summary>
        /// Set custom emulator listen port.
        /// </summary>
        public string ListenPort { get; set; } = EMUConfigDefault.ListenPort.ToString();
        /// <summary>
        /// Set Custom broadcast IP.
        /// </summary>
        public string CustomIP { get; set; } = EMUConfigDefault.CustomIP;
        /// <summary>
        /// Generate custom_broadcasts.txt
        /// </summary>
        public bool UseCustomIP { get; set; } = EMUConfigDefault.UseCustomIP;
        /// <summary>
        /// Generate force_language.txt
        /// </summary>
        public bool LanguageForce { get; set; } = EMUConfigDefault.LanguageForce;
        /// <summary>
        /// Generate force_steamid.txt
        /// </summary>
        public bool SteamIDForce { get; set; } = EMUConfigDefault.SteamIDForce;
        /// <summary>
        /// Generate force_account_name.txt
        /// </summary>
        public bool AccountNameForce { get; set; } = EMUConfigDefault.AccountNameForce;
        /// <summary>
        /// Generate force_listen_port.txt
        /// </summary>
        public bool ListenPortForce { get; set; } = EMUConfigDefault.ListenPortForce;
        /// <summary>
        /// Disable all the networking functionality of the Steam emulator.
        /// </summary>
        public bool DisableNetworking { get; set; } = EMUConfigDefault.DisableNetworking;
        /// <summary>
        /// Emable Steam emulator offline mode.
        /// </summary>
        public bool Offline { get; set; } = EMUConfigDefault.Offline;
        /// <summary>
        /// Disable Steam emulator overlay.
        /// </summary>
        public bool DisableOverlay { get; set; } = EMUConfigDefault.DisableOverlay;

        public void ResettoDefault()
        {
            Language = EMUConfigDefault.Language;
            SteamID = EMUConfigDefault.SteamID.ConvertToUInt64().ToString();
            AccountName = EMUConfigDefault.AccountName;
            ListenPort = EMUConfigDefault.ListenPort.ToString();
            CustomIP = EMUConfigDefault.CustomIP;
            UseCustomIP = EMUConfigDefault.UseCustomIP;
            LanguageForce = EMUConfigDefault.LanguageForce;
            SteamIDForce = EMUConfigDefault.SteamIDForce;
            AccountNameForce = EMUConfigDefault.AccountNameForce;
            ListenPortForce = EMUConfigDefault.ListenPortForce;
            DisableNetworking = EMUConfigDefault.DisableNetworking;
            Offline = EMUConfigDefault.Offline;
            DisableOverlay = EMUConfigDefault.DisableOverlay;
        }
        public EMUConfig GetEMUConfig()
        {
            var emuConfig = new EMUConfig
            {
                AccountName = AccountName,
                UseCustomIP = UseCustomIP,
                LanguageForce = LanguageForce,
                SteamIDForce = SteamIDForce,
                AccountNameForce = AccountNameForce,
                ListenPortForce = ListenPortForce,
                DisableNetworking = DisableNetworking,
                Offline = Offline,
                DisableOverlay = DisableOverlay,
                ConfigPath = Config.EMUConfigPath,
                Language = Language
            };
            emuConfig.SetSteamIDFromString(SteamID);
            emuConfig.SetListenPortFromString(ListenPort);
            emuConfig.SetCustomIPFromString(CustomIP);
            return emuConfig;
        }
    }

    public class SteamAppListConfigs
    {
        public bool ForceUpdate { get; set; } = false;
        public void ResettoDefault()
        {
            ForceUpdate = false;
        }
    }

    public class SteamStubUnpackerConfigs
    {
        /// <summary>
        /// Keeps the .bind section in the unpacked file.
        /// </summary>
        public bool KeepBind { get; set; } = SteamStubUnpackerConfigDefault.KeepBind;
        /// <summary>
        /// Keeps the DOS stub in the unpacked file.
        /// </summary>
        public bool KeepStub { get; set; } = SteamStubUnpackerConfigDefault.KeepStub;
        /// <summary>
        /// Realigns the unpacked file sections.
        /// </summary>
        public bool Realign { get; set; } = SteamStubUnpackerConfigDefault.Realign;
        /// <summary>
        /// Recalculates the unpacked file checksum.
        /// </summary>
        public bool ReCalcChecksum { get; set; } = SteamStubUnpackerConfigDefault.ReCalcChecksum;
        /// <summary>
        /// Use Experimental Features.
        /// </summary>
        public bool UseExperimentalFeatures { get; set; } = SteamStubUnpackerConfigDefault.UseExperimentalFeatures;

        public void ResettoDefault()
        {
            KeepBind = SteamStubUnpackerConfigDefault.KeepBind;
            KeepStub = SteamStubUnpackerConfigDefault.KeepStub;
            Realign = SteamStubUnpackerConfigDefault.Realign;
            ReCalcChecksum = SteamStubUnpackerConfigDefault.ReCalcChecksum;
            UseExperimentalFeatures = SteamStubUnpackerConfigDefault.UseExperimentalFeatures;
        }
        public SteamStubUnpackerConfig GetSteamStubUnpackerConfig()
        {
            return new SteamStubUnpackerConfig
            {
                KeepBind = KeepBind,
                KeepStub = KeepStub,
                Realign = Realign,
                ReCalcChecksum = ReCalcChecksum,
                UseExperimentalFeatures = UseExperimentalFeatures
            };
        }
    }

    public class EMUGameInfoConfigs
    {
        public EMUGameInfoConfig.GeneratorGameInfoAPI GameInfoAPI { get; set; } = EMUGameInfoConfigDefault.GameInfoAPI;
        /// <summary>
        /// Required when using Steam official Web API.
        /// </summary>
        public string? SteamWebAPIKey { get; set; } = EMUGameInfoConfigDefault.SteamWebAPIKey;
        /// <summary>
        /// Enable generate game achievement images.
        /// </summary>
        public bool GenerateImages { get; set; } = EMUGameInfoConfigDefault.GenerateImages;
        [JsonIgnore]
        public string AppID { get; set; } = String.Empty;
        /// <summary>
        /// Use Xan105 API for generating game schema.
        /// </summary>
        public bool UseXan105API { get; set; } = EMUGameInfoConfigDefault.UseXan105API;
        /// <summary>
        /// Use Steam Web App List when generating DLCs.
        /// </summary>
        public bool UseSteamWebAppList { get; set; } = EMUGameInfoConfigDefault.UseSteamWebAppList;
        public void ResettoDefault()
        {
            SteamWebAPIKey = EMUGameInfoConfigDefault.SteamWebAPIKey;
            GameInfoAPI = EMUGameInfoConfigDefault.GameInfoAPI;
            GenerateImages = EMUGameInfoConfigDefault.GenerateImages;
            UseXan105API = EMUGameInfoConfigDefault.UseXan105API;
            UseSteamWebAppList = EMUGameInfoConfigDefault.UseSteamWebAppList;
        }
        public EMUGameInfoConfig GetEMUGameInfoConfig()
        {
            var emuGameInfoConfig = new EMUGameInfoConfig
            {
                SteamWebAPIKey = SteamWebAPIKey,
                GenerateImages = GenerateImages,
                UseXan105API = UseXan105API,
                UseSteamWebAppList = UseSteamWebAppList,
                ConfigPath = Config.EMUConfigPath,
            };
            emuGameInfoConfig.SetAppIDFromString(AppID);
            return emuGameInfoConfig;
        }
    }

    public class GenCrackOnlyConfigs
    {
        /// <summary>
        /// Crack only file output path.
        /// </summary>
        public string? OutputPath { get; set; } = GenCrackOnlyConfigDefault.OutputPath;
        /// <summary>
        /// Create crack only readme file.
        /// </summary>
        public bool CreateReadme { get; set; } = GenCrackOnlyConfigDefault.CreateReadme;
        /// <summary>
        /// Pack Crack only file with .zip archive.
        /// </summary>
        public bool Pack { get; set; } = GenCrackOnlyConfigDefault.Pack;
        /// <summary>
        /// Generate crack applier (Steamstub unpacker) if found packed .exe .
        /// </summary>
        public bool GenerateApplier { get; set; } = GenCrackOnlyConfigDefault.GenerateApplier;
        public void ResettoDefault()
        {
            OutputPath = GenCrackOnlyConfigDefault.OutputPath;
            CreateReadme = GenCrackOnlyConfigDefault.CreateReadme;
            Pack = GenCrackOnlyConfigDefault.Pack;
            GenerateApplier = GenCrackOnlyConfigDefault.GenerateApplier;
        }
        public GenCrackOnlyConfig GetGenCrackOnlyConfig()
        {
            return new GenCrackOnlyConfig
            {
                SourcePath = Config.InputPath,
                OutputPath = OutputPath,
                CreateReadme = CreateReadme,
                Pack = Pack,
                GenerateApplier = GenerateApplier,
            };
        }
    }

    public class ProcessConfigs
    {
        /// <summary>
        /// Generate Steam emulator Game Info.
        /// </summary>
        public bool GenerateEMUGameInfo { get; set; } = true;
        /// <summary>
        /// Generate Steam emulator config.
        /// </summary>
        public bool GenerateEMUConfig { get; set; } = true;
        /// <summary>
        /// Unpack Steamstub.
        /// </summary>
        public bool Unpack { get; set; } = true;
        /// <summary>
        /// Apply Steam emulator.
        /// </summary>
        public bool ApplyEMU { get; set; } = true;
        /// <summary>
        /// Generate Crack Only Files.
        /// </summary>
        public bool GenerateCrackOnly { get; set; } = false;
        /// <summary>
        /// Restore Crack.
        /// </summary>
        public bool Restore { get; set; } = false;
        public void ResettoDefault()
        {
            GenerateEMUGameInfo = true;
            GenerateEMUConfig = true;
            Unpack = true;
            ApplyEMU = true;
            GenerateCrackOnly = false;
            Restore = false;
        }
    }
}
