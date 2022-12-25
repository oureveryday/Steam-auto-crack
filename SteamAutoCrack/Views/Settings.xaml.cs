using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.ViewModels;
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
    /// Settings.xaml 的交互逻辑
    /// </summary>
    public delegate void SettingsClosingHandler();
    public delegate void ReloadValueHandler();
    
    public partial class Settings : Window
    {
        private readonly SettingsViewModel viewModel = new SettingsViewModel();
        public event SettingsClosingHandler ClosingEvent;
        public event ReloadValueHandler ReloadValueEvent;
        public void ReloadValue()
        {
            viewModel.ReloadValue();
        }
        public Settings()
        {
            InitializeComponent();
            DataContext = viewModel;
        }

        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            StrikeEvent();
        }
        private void StrikeEvent()
        {
            ClosingEvent?.Invoke();
        }

        private void RestoreConfig_Click(object sender, RoutedEventArgs e)
        {
            Config.ResettoDefaultAll();
            ReloadValueEvent?.Invoke();
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            ClosingEvent?.Invoke();
            Close();
        }

        private async void Download_Click(object sender, RoutedEventArgs e)
        {
            Download.IsEnabled = false;
            viewModel.UpdateBtnString = "Downloading...";
            var updater = new EMUUpdater();
            await updater.Init();
            await updater.Download(viewModel.ForceUpdate);
            viewModel.ReloadValue();
            viewModel.UpdateBtnString = "Update/Download";
            Download.IsEnabled = true;
        }

        private void UpdateAppList_Click(object sender, RoutedEventArgs e)
        {
            Task.Run(async () =>
            {
                await SteamAppList.Initialize(true).ConfigureAwait(false);
            });
        }
    }
}
