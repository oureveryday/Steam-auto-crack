using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System;
using System.Linq;
using System.Collections.Generic;
using SteamAutoCrack.Views;
using System.Windows.Input;

namespace SteamAutoCrack.ViewModels
{
    class MainWindowViewModel : INotifyPropertyChanged
    {
        #region INPC
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged([CallerMemberName] string propertyName = "")
        {
            if (Config.SaveCrackConfig)
            {
                Config.SaveConfig();
            }
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        public void ReloadValue()
        {
            NotifyPropertyChanged("InputPath");
            NotifyPropertyChanged("GenerateEMUGameInfo");
            NotifyPropertyChanged("GenerateEMUConfig");
            NotifyPropertyChanged("Unpack");
            NotifyPropertyChanged("ApplyEMU");
            NotifyPropertyChanged("GenerateCrackOnly");
            NotifyPropertyChanged("Restore");
            NotifyPropertyChanged("AppID");
            NotifyPropertyChanged("SteamWebAPIKey");
            NotifyPropertyChanged("UseXan105API");
            NotifyPropertyChanged("UseSteamWebAppList");
            NotifyPropertyChanged("GenerateImages");
            NotifyPropertyChanged("GameInfoAPI");
            NotifyPropertyChanged("Language");
            NotifyPropertyChanged("SteamID");
            NotifyPropertyChanged("AccountName");
            NotifyPropertyChanged("ListenPort");
            NotifyPropertyChanged("CustomIP");
            NotifyPropertyChanged("UseCustomIP");
            NotifyPropertyChanged("LanguageForce");
            NotifyPropertyChanged("SteamIDForce");
            NotifyPropertyChanged("AccountNameForce");
            NotifyPropertyChanged("ListenPortForce");
            NotifyPropertyChanged("DisableNetworking");
            NotifyPropertyChanged("Offline");
            NotifyPropertyChanged("DisableOverlay");
            NotifyPropertyChanged("KeepBind");
            NotifyPropertyChanged("KeepStub");
            NotifyPropertyChanged("Realign");
            NotifyPropertyChanged("ReCalcChecksum");
            NotifyPropertyChanged("UseExperimentalFeatures");
            NotifyPropertyChanged("LocalSave");
            NotifyPropertyChanged("UseLocalSave");
            NotifyPropertyChanged("UseGoldbergExperimental");
            NotifyPropertyChanged("GenerateInterfacesFile");
            NotifyPropertyChanged("ForceGenerateInterfacesFiles");
            NotifyPropertyChanged("OutputPath");
            NotifyPropertyChanged("CreateReadme"); 
            NotifyPropertyChanged("GenerateApplier");
            NotifyPropertyChanged("Pack");
        }
        #endregion
        #region BasicConfigs
        public string InputPath
        {
            get
            {
                return Config.InputPath;
            }

            set
            {
                if (value != Config.InputPath)
                {
                    Config.InputPath = value;
                    NotifyPropertyChanged("InputPath");
                }
            }
        }
        public string Ver
        {
            get
            {
                return "SteamAutoCrack " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
            }
        }
        #endregion
        #region ProcessConfigs
        public bool GenerateEMUGameInfo
        {
            get
            {
                return Config.ProcessConfigs.GenerateEMUGameInfo;
            }

            set
            {
                if (value != Config.ProcessConfigs.GenerateEMUGameInfo)
                {
                    Config.ProcessConfigs.GenerateEMUGameInfo = value;
                    NotifyPropertyChanged("GenerateEMUGameInfo");
                }
            }
        }
        public bool GenerateEMUConfig
        {
            get
            {
                return Config.ProcessConfigs.GenerateEMUConfig;
            }

            set
            {
                if (value != Config.ProcessConfigs.GenerateEMUConfig)
                {
                    Config.ProcessConfigs.GenerateEMUConfig = value;
                    NotifyPropertyChanged("GenerateEMUConfig");
                }
            }
        }
        public bool Unpack
        {
            get
            {
                return Config.ProcessConfigs.Unpack;
            }

            set
            {
                if (value != Config.ProcessConfigs.Unpack)
                {
                    Config.ProcessConfigs.Unpack = value;
                    NotifyPropertyChanged("Unpack");
                }
            }
        }
        public bool ApplyEMU
        {
            get
            {
                return Config.ProcessConfigs.ApplyEMU;
            }

            set
            {
                if (value != Config.ProcessConfigs.ApplyEMU)
                {
                    Config.ProcessConfigs.ApplyEMU = value;
                    NotifyPropertyChanged("ApplyEMU");
                }
            }
        }
        public bool GenerateCrackOnly
        {
            get
            {
                return Config.ProcessConfigs.GenerateCrackOnly;
            }

            set
            {
                if (value != Config.ProcessConfigs.GenerateCrackOnly)
                {
                    Config.ProcessConfigs.GenerateCrackOnly = value;
                    NotifyPropertyChanged("GenerateCrackOnly");
                }
            }
        }
        public bool Restore
        {
            get
            {
                return Config.ProcessConfigs.Restore;
            }

            set
            {
                if (value != Config.ProcessConfigs.Restore)
                {
                    Config.ProcessConfigs.Restore = value;
                    NotifyPropertyChanged("Restore");
                }
            }
        }
        #endregion
        #region EMUGameInfoConfigs
        public string AppID
        {
            get
            {
                return Config.EMUGameInfoConfigs.AppID;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.AppID)
                {
                    Config.EMUGameInfoConfigs.AppID = value;
                    NotifyPropertyChanged("AppID");
                }
            }
        }
        public string SteamWebAPIKey
        {
            get
            {
                return Config.EMUGameInfoConfigs.SteamWebAPIKey;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.SteamWebAPIKey)
                {
                    Config.EMUGameInfoConfigs.SteamWebAPIKey = value;
                    NotifyPropertyChanged("SteamWebAPIKey");
                }
            }
        }
        public bool UseXan105API
        {
            get
            {
                return Config.EMUGameInfoConfigs.UseXan105API;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.UseXan105API)
                {
                    Config.EMUGameInfoConfigs.UseXan105API = value;
                    NotifyPropertyChanged("UseXan105API");
                }
            }
        }
        public bool UseSteamWebAppList
        {
            get
            {
                return Config.EMUGameInfoConfigs.UseSteamWebAppList;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.UseSteamWebAppList)
                {
                    Config.EMUGameInfoConfigs.UseSteamWebAppList = value;
                    NotifyPropertyChanged("UseSteamWebAppList");
                }
            }
        }
        public bool GenerateImages
        {
            get
            {
                return Config.EMUGameInfoConfigs.GenerateImages;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.GenerateImages)
                {
                    Config.EMUGameInfoConfigs.GenerateImages = value;
                    NotifyPropertyChanged("GenerateImages");
                }
            }
        }
        public EMUGameInfoConfig.GeneratorGameInfoAPI GameInfoAPI
        {
            get
            {
                return Config.EMUGameInfoConfigs.GameInfoAPI;
            }

            set
            {
                if (value != Config.EMUGameInfoConfigs.GameInfoAPI)
                {
                    Config.EMUGameInfoConfigs.GameInfoAPI = value;
                    NotifyPropertyChanged("GameInfoAPI");
                }
            }
        }
        public List<EMUGameInfoConfig.GeneratorGameInfoAPI> GameInfoAPIs {get;set;}

        #endregion
        #region EMUConfigs
        public EMUConfig.Languages Language
        {
            get
            {
                return Config.EMUConfigs.Language;
            }

            set
            {
                if (value != Config.EMUConfigs.Language)
                {
                    Config.EMUConfigs.Language = value;
                    NotifyPropertyChanged("Language");
                }
            }
        }
        public List<EMUConfig.Languages> Languages { get; set; }
        public string SteamID
        {
            get
            {
                return Config.EMUConfigs.SteamID;
            }

            set
            {
                if (value != Config.EMUConfigs.SteamID)
                {
                    Config.EMUConfigs.SteamID = value;
                    NotifyPropertyChanged("SteamID");
                }
            }
        }
        public string AccountName
        {
            get
            {
                return Config.EMUConfigs.AccountName;
            }

            set
            {
                if (value != Config.EMUConfigs.AccountName)
                {
                    Config.EMUConfigs.AccountName = value;
                    NotifyPropertyChanged("AccountName");
                }
            }
        }
        public string ListenPort
        {
            get
            {
                return Config.EMUConfigs.ListenPort;
            }

            set
            {
                if (value != Config.EMUConfigs.ListenPort)
                {
                    Config.EMUConfigs.ListenPort = value;
                    NotifyPropertyChanged("ListenPort");
                }
            }
        }
        public string CustomIP
        {
            get
            {
                return Config.EMUConfigs.CustomIP;
            }

            set
            {
                if (value != Config.EMUConfigs.CustomIP)
                {
                    Config.EMUConfigs.CustomIP = value;
                    NotifyPropertyChanged("CustomIP");
                }
            }
        }
        public bool UseCustomIP
        {
            get
            {
                return Config.EMUConfigs.UseCustomIP;
            }

            set
            {
                if (value != Config.EMUConfigs.UseCustomIP)
                {
                    Config.EMUConfigs.UseCustomIP = value;
                    NotifyPropertyChanged("UseCustomIP");
                }
            }
        }
        public bool LanguageForce
        {
            get
            {
                return Config.EMUConfigs.LanguageForce;
            }

            set
            {
                if (value != Config.EMUConfigs.LanguageForce)
                {
                    Config.EMUConfigs.LanguageForce = value;
                    NotifyPropertyChanged("LanguageForce");
                }
            }
        }
        public bool SteamIDForce
        {
            get
            {
                return Config.EMUConfigs.SteamIDForce;
            }

            set
            {
                if (value != Config.EMUConfigs.SteamIDForce)
                {
                    Config.EMUConfigs.SteamIDForce = value;
                    NotifyPropertyChanged("SteamIDForce");
                }
            }
        }
        public bool AccountNameForce
        {
            get
            {
                return Config.EMUConfigs.AccountNameForce;
            }

            set
            {
                if (value != Config.EMUConfigs.AccountNameForce)
                {
                    Config.EMUConfigs.AccountNameForce = value;
                    NotifyPropertyChanged("AccountNameForce");
                }
            }
        }
        public bool ListenPortForce
        {
            get
            {
                return Config.EMUConfigs.ListenPortForce;
            }

            set
            {
                if (value != Config.EMUConfigs.ListenPortForce)
                {
                    Config.EMUConfigs.ListenPortForce = value;
                    NotifyPropertyChanged("ListenPortForce");
                }
            }
        }
        public bool DisableNetworking
        {
            get
            {
                return Config.EMUConfigs.DisableNetworking;
            }

            set
            {
                if (value != Config.EMUConfigs.DisableNetworking)
                {
                    Config.EMUConfigs.DisableNetworking = value;
                    NotifyPropertyChanged("DisableNetworking");
                }
            }
        }
        public bool Offline
        {
            get
            {
                return Config.EMUConfigs.Offline;
            }

            set
            {
                if (value != Config.EMUConfigs.Offline)
                {
                    Config.EMUConfigs.Offline = value;
                    NotifyPropertyChanged("Offline");
                }
            }
        }
        public bool DisableOverlay
        {
            get
            {
                return Config.EMUConfigs.DisableOverlay;
            }

            set
            {
                if (value != Config.EMUConfigs.DisableOverlay)
                {
                    Config.EMUConfigs.DisableOverlay = value;
                    NotifyPropertyChanged("DisableOverlay");
                }
            }
        }
        #endregion
        #region SteamStubUnpackerConfigs
        public bool KeepBind
        {
            get
            {
                return Config.SteamStubUnpackerConfigs.KeepBind;
            }

            set
            {
                if (value != Config.SteamStubUnpackerConfigs.KeepBind)
                {
                    Config.SteamStubUnpackerConfigs.KeepBind = value;
                    NotifyPropertyChanged("KeepBind");
                }
            }
        }
        public bool KeepStub
        {
            get
            {
                return Config.SteamStubUnpackerConfigs.KeepStub;
            }

            set
            {
                if (value != Config.SteamStubUnpackerConfigs.KeepStub)
                {
                    Config.SteamStubUnpackerConfigs.KeepStub = value;
                    NotifyPropertyChanged("KeepStub");
                }
            }
        }
        public bool Realign
        {
            get
            {
                return Config.SteamStubUnpackerConfigs.Realign;
            }

            set
            {
                if (value != Config.SteamStubUnpackerConfigs.Realign)
                {
                    Config.SteamStubUnpackerConfigs.Realign = value;
                    NotifyPropertyChanged("Realign");
                }
            }
        }
        public bool ReCalcChecksum
        {
            get
            {
                return Config.SteamStubUnpackerConfigs.ReCalcChecksum;
            }

            set
            {
                if (value != Config.SteamStubUnpackerConfigs.ReCalcChecksum)
                {
                    Config.SteamStubUnpackerConfigs.ReCalcChecksum = value;
                    NotifyPropertyChanged("ReCalcChecksum");
                }
            }
        }
        public bool UseExperimentalFeatures
        {
            get
            {
                return Config.SteamStubUnpackerConfigs.UseExperimentalFeatures;
            }

            set
            {
                if (value != Config.SteamStubUnpackerConfigs.UseExperimentalFeatures)
                {
                    Config.SteamStubUnpackerConfigs.UseExperimentalFeatures = value;
                    NotifyPropertyChanged("UseExperimentalFeatures");
                }
            }
        }

        #endregion
        #region EMUApplyConfigs
        public string LocalSave
        {
            get
            {
                return Config.EMUApplyConfigs.LocalSave;
            }

            set
            {
                if (value != Config.EMUApplyConfigs.LocalSave)
                {
                    Config.EMUApplyConfigs.LocalSave = value;
                    NotifyPropertyChanged("LocalSave");
                }
            }
        }
        public bool UseLocalSave
        {
            get
            {
                return Config.EMUApplyConfigs.UseLocalSave;
            }

            set
            {
                if (value != Config.EMUApplyConfigs.UseLocalSave)
                {
                    Config.EMUApplyConfigs.UseLocalSave = value;
                    NotifyPropertyChanged("UseLocalSave");
                }
            }
        }
        public bool UseGoldbergExperimental
        {
            get
            {
                return Config.EMUApplyConfigs.UseGoldbergExperimental;
            }

            set
            {
                if (value != Config.EMUApplyConfigs.UseGoldbergExperimental)
                {
                    Config.EMUApplyConfigs.UseGoldbergExperimental = value;
                    NotifyPropertyChanged("UseGoldbergExperimental");
                }
            }
        }
        public bool GenerateInterfacesFile
        {
            get
            {
                return Config.EMUApplyConfigs.GenerateInterfacesFile;
            }

            set
            {
                if (value != Config.EMUApplyConfigs.GenerateInterfacesFile)
                {
                    Config.EMUApplyConfigs.GenerateInterfacesFile = value;
                    NotifyPropertyChanged("GenerateInterfacesFile");
                }
            }
        }
        public bool ForceGenerateInterfacesFiles
        {
            get
            {
                return Config.EMUApplyConfigs.ForceGenerateInterfacesFiles;
            }

            set
            {
                if (value != Config.EMUApplyConfigs.ForceGenerateInterfacesFiles)
                {
                    Config.EMUApplyConfigs.ForceGenerateInterfacesFiles = value;
                    NotifyPropertyChanged("ForceGenerateInterfacesFiles");
                }
            }
        }
        #endregion
        #region GenCrackOnlyConfigs
        public string OutputPath
        {
            get
            {
                return Config.GenCrackOnlyConfigs.OutputPath;
            }

            set
            {
                if (value != Config.GenCrackOnlyConfigs.OutputPath)
                {
                    Config.GenCrackOnlyConfigs.OutputPath = value;
                    NotifyPropertyChanged("OutputPath");
                }
            }
        }
        public bool CreateReadme
        {
            get
            {
                return Config.GenCrackOnlyConfigs.CreateReadme;
            }

            set
            {
                if (value != Config.GenCrackOnlyConfigs.CreateReadme)
                {
                    Config.GenCrackOnlyConfigs.CreateReadme = value;
                    NotifyPropertyChanged("CreateReadme");
                }
            }
        }
        public bool Pack
        {
            get
            {
                return Config.GenCrackOnlyConfigs.Pack;
            }

            set
            {
                if (value != Config.GenCrackOnlyConfigs.Pack)
                {
                    Config.GenCrackOnlyConfigs.Pack = value;
                    NotifyPropertyChanged("Pack");
                }
            }
        }
        public bool GenerateApplier
        {
            get
            {
                return Config.GenCrackOnlyConfigs.GenerateApplier;
            }

            set
            {
                if (value != Config.GenCrackOnlyConfigs.GenerateApplier)
                {
                    Config.GenCrackOnlyConfigs.GenerateApplier = value;
                    NotifyPropertyChanged("GenerateApplier");
                }
            }
        }
        #endregion
        public MainWindowViewModel()
        {
            GameInfoAPIs = Enum.GetValues(typeof(EMUGameInfoConfig.GeneratorGameInfoAPI)).Cast<EMUGameInfoConfig.GeneratorGameInfoAPI>().ToList();
            Languages = Enum.GetValues(typeof(EMUConfig.Languages)).Cast<EMUConfig.Languages>().ToList();
        }
    }
}
