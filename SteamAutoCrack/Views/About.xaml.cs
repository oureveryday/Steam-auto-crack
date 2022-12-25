using Serilog;
using SteamAutoCrack.ViewModels;
using System;
using System.Diagnostics;
using System.Windows;

namespace SteamAutoCrack.Views
{
    /// <summary>
    /// About.xaml 的交互逻辑
    /// </summary>
    public delegate void AboutClosingHandler();
    public partial class About : Window
    {
        private readonly ILogger _log = Log.ForContext<About>();
        private readonly AboutViewModel viewModel = new AboutViewModel();
        public event AboutClosingHandler ClosingEvent;
        public About()
        {
            InitializeComponent();
            DataContext = viewModel;
            _log.Information("Steam Auto Crack {Ver}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());
            _log.Information("Github: https://gitlab.com/oureveryday/Steam-auto-crack");
            _log.Information("Gitlab: https://github.com/oureveryday/Steam-auto-crack");
        }
        
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            StrikeEvent();
        }
        private void StrikeEvent()
        {
            ClosingEvent?.Invoke();
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            ClosingEvent?.Invoke();
            Close();
        }
        private void Hyperlink_RequestNavigate(object sender, System.Windows.Navigation.RequestNavigateEventArgs e)
        {
            try
            {
                Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri) { UseShellExecute = true });
                e.Handled = true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "");
            }
        }
    }
}
