using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Navigation;

namespace SteamAutoCrack.ViewModels
{
    class AppIDFinderViewModel : INotifyPropertyChanged
    {
        #region INPC
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged([CallerMemberName] string propertyName = "")
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        public void ReloadValue()
        {
        }
        public string AppName
        {
            get
            {
                return _AppName;
            }

            set
            {
                if (value != _AppName)
                {
                    _AppName = value;
                    NotifyPropertyChanged("AppName");
                }
            }
        }
        public bool Fuzzy
        {
            get
            {
                return _Fuzzy;
            }

            set
            {
                if (value != _Fuzzy)
                {
                    _Fuzzy = value;
                    NotifyPropertyChanged("AppName");
                }
            }
        }
        private bool _Fuzzy = false;
        public string SearchBtnString
        {
            get
            {
                return _SearchBtnString;
            }
            set
            {
                _SearchBtnString = value;
                NotifyPropertyChanged("SearchBtnString");
            }
        }
        public IEnumerable<SteamApp> Apps
        {
            get => _apps;
            set
            {
                _apps = value;
                NotifyPropertyChanged("Apps");
            }
        }
        private IEnumerable<SteamApp> _apps;
        public SteamApp Selected
        {
            get;
            set;
        }

        private string _SearchBtnString = "Search";
        private string _AppName = string.Empty;
        #endregion


    }
}
