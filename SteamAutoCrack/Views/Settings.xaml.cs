using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.ViewModels;
using System.Threading.Tasks;
using System.Windows;

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
            Task.Run(async() =>
            {
                var updater = new EMUUpdater();
                await updater.Init();
                await updater.Download(viewModel.ForceUpdate);
            });
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
