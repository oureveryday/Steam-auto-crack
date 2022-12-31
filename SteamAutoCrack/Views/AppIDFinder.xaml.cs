using Serilog;
using SQLitePCL;
using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.ViewModels;
using SteamKit2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace SteamAutoCrack.Views
{
    /// <summary>
    /// AppIDFinder.xaml 的交互逻辑
    /// </summary>
    
    public delegate void AppIDFinderClosingHandler();
    public delegate void AppIDFinderOKHandler(uint appid);
    public partial class AppIDFinder : Window
    {
        private readonly ILogger _log;
        public AppIDFinder(string appname)
        {
            InitializeComponent();
            DataContext = viewModel;
            viewModel.AppName = appname;
            viewModel.SearchBtnString = "Loading...";
            Search.IsEnabled = false;
            _log = Log.ForContext<AppIDFinder>();
            Task.Run(async () =>
            {
                try
                {
                    await SteamAppList.WaitForReady().ConfigureAwait(false);
                    Dispatcher.Invoke(new Action(() => {
                        Search.IsEnabled = true;
                        viewModel.SearchBtnString = "Search";
                        if (viewModel.AppName != string.Empty)
                        {
                            Search_Click(new Object(), new RoutedEventArgs());
                        }
                    }));
                    
                }
                catch(Exception ex)
                {
                    _log.Error(ex, "Failed to load App List. Please restart SteamAutoCrack to try again.");
                    Dispatcher.Invoke(new Action(() => {
                        viewModel.SearchBtnString = "Failed";
                    }));
                    
                }
                
            });
        }
        private readonly AppIDFinderViewModel viewModel = new AppIDFinderViewModel();
        public event AppIDFinderClosingHandler ClosingEvent;
        public event AppIDFinderOKHandler OKEvent;

        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            StrikeEvent();
        }
        private void StrikeEvent()
        {
            ClosingEvent?.Invoke();
        }

        private async void OK_Click(object sender, RoutedEventArgs e)
        {
            var apps = Apps.SelectedCells.ToList();
            if (apps.Count != 0)
            {
                var app = (SteamApp)apps[0].Item;
                OKEvent?.Invoke((uint)app.AppId);
                Close();
            }
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            ClosingEvent?.Invoke();
            Close();
        }

        private void Apps_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            var apps = Apps.SelectedCells.ToList();
            if (apps.Count != 0)
            {
                var app = (SteamApp)apps[0].Item;
                OKEvent?.Invoke((uint)app.AppId);
                Close();
            }
        }

        private async void Search_Click(object sender, RoutedEventArgs e)
        {
            viewModel.SearchBtnString = "Searching...";
            Search.IsEnabled = false;
            if ((bool)Fuzzy.IsChecked)
            {
                viewModel.Apps = await SteamAppList.GetListOfAppsByNameFuzzy(AppName.Text).ConfigureAwait(false);
            }
            else
            {
                viewModel.Apps = await SteamAppList.GetListOfAppsByName(AppName.Text).ConfigureAwait(false);
            }
            Dispatcher.Invoke(new Action(() => {
                Search.IsEnabled = true;
            }));
            viewModel.SearchBtnString = "Search";
            
            return;
        }
    }
}
