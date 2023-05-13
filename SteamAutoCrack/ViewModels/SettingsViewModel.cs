using SteamAutoCrack.Core.Config;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;

namespace SteamAutoCrack.ViewModels
{
    class SettingsViewModel : INotifyPropertyChanged
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
            NotifyPropertyChanged("LogToFile");
            NotifyPropertyChanged("EnableDebugLog");
            NotifyPropertyChanged("SaveCrackConfig");
            NotifyPropertyChanged("GoldbergVer");
            NotifyPropertyChanged("UpdateBtnString");
            NotifyPropertyChanged("ForceUpdate");
        }
        #endregion

        public bool SaveCrackConfig
        {
            get
            {
                return Config.SaveCrackConfig;
            }

            set
            {
                if (value != Config.SaveCrackConfig)
                {
                    Config.SaveCrackConfig = value;
                    NotifyPropertyChanged();
                }
            }
        }
        public bool EnableDebugLog
        {
            get
            {
                return Config.EnableDebugLog;
            }

            set
            {
                if (value != Config.EnableDebugLog)
                {
                    Config.EnableDebugLog = value;
                    NotifyPropertyChanged();
                }
            }
        }
        public bool LogToFile
        {
            get
            {
                return Config.LogToFile;
            }

            set
            {
                if (value != Config.LogToFile)
                {
                    Config.LogToFile = value;
                    NotifyPropertyChanged();
                }
            }
        }
        public string GoldbergVer
        {
            get
            {
                return "Current Goldberg Steam Emulator jobid: " + Config.GetGoldbergVersion();
            }
        }
        public string UpdateBtnString
        {
            get
            {
                return _UpdateBtnString;
            }
            set
            {
                _UpdateBtnString = value;
                NotifyPropertyChanged();
            }
        }
        private string _UpdateBtnString = "Update/Download";
        public bool ForceUpdate
        {
            get
            {
                return _ForceUpdate;
            }

            set
            {
                if (value != _ForceUpdate)
                {
                    _ForceUpdate = value;
                    NotifyPropertyChanged();
                }
            }
        }
        public Config.Languages Language
        {
            get
            {
                return Config.Language;
            }

            set
            {
                if (value != Config.Language)
                {
                    Config.Language = value;
                    NotifyPropertyChanged();
                }
            }
        }
        public List<Config.Languages> Languages { get; set; }
        private bool _ForceUpdate = false;
        public SettingsViewModel()
        {
            Languages = Enum.GetValues(typeof(Config.Languages)).Cast<Config.Languages>().ToList();
        }
    }
    
}
