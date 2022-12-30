using Ookii.Dialogs.Wpf;
using Serilog;
using Serilog.Events;
using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.Utils;
using SteamAutoCrack.ViewModels;
using SteamAutoCrack.Views;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using WPFCustomMessageBox;

namespace SteamAutoCrack
{
    public partial class MainWindow : Window
    {
        private readonly ILogger _log;
        
        private readonly MainWindowViewModel viewModel = new MainWindowViewModel();

        private bool bSettingsOpened = false;
        private bool bAppIDFinderOpened = false;
        private bool bAboutOpened = false;
        
        public MainWindow()
        {
            InitializeComponent();
            if (Config.SaveCrackConfig) 
            {
                Config.LoadConfig();
            }
            if (Config.LogToFile)
            {
                Log.Logger = new LoggerConfiguration()
                .Enrich.WithProperty("SourceContext", null)
                .MinimumLevel.ControlledBy(Config.loggingLevelSwitch)
                .WriteTo.ListViewSink(LogBox)
                .WriteTo.File("error.log", restrictedToMinimumLevel: LogEventLevel.Error, outputTemplate: "[{Level:u3}] [{SourceContext}] {Message:lj}{NewLine}{Exception}", shared: true)
                .WriteTo.File("log.log", outputTemplate: "[{Level:u3}] [{SourceContext}] {Message:lj}{NewLine}{Exception}", shared: true)
                .CreateLogger();
            }
            else
            {
                Log.Logger = new LoggerConfiguration()
                .Enrich.WithProperty("SourceContext", null)
                .MinimumLevel.ControlledBy(Config.loggingLevelSwitch)
                .WriteTo.ListViewSink(LogBox)
                .WriteTo.File("error.log", restrictedToMinimumLevel: LogEventLevel.Error, outputTemplate: "[{Level:u3}] [{SourceContext}] {Message:lj}{NewLine}{Exception}", shared: true)
                .CreateLogger();
            }
            _log = Log.ForContext<MainWindow>();
            DataContext = viewModel;
            Task.Run(async () =>
            {
                await SteamAppList.Initialize().ConfigureAwait(false);
            });

            if (!CheckGoldberg())
            {
                var result = CustomMessageBox.ShowYesNo("Goldberg emulator file is missing.\nDownload Goldberg emulator?", "Download Goldberg emulator?", "Download", "Cancel");
                if (result == MessageBoxResult.Yes)
                {
                    Task.Run(async () =>
                    {
                        var updater = new EMUUpdater();
                        await updater.Init();
                        await updater.Download(true);
                    });

                }
            }
        }
        #region Basic
        private void Start_Click(object sender, RoutedEventArgs e)
        {
            Settings.IsEnabled = false;
            Start.IsEnabled = false;
            AppIDFinder.IsEnabled = false;
            
            Task.Run(async () =>
            {
                if (viewModel.GenerateEMUGameInfo && viewModel.AppID == String.Empty)
                {
                    _log.Information("Empty AppID. Please select one using AppID Finder.");
                    Dispatcher.Invoke(new Action(() => {
                        AppIDFinder_Click(sender, e);
                    }));
                    while (bAppIDFinderOpened) ;
                }
                await new Processor().ProcessFileGUI().ConfigureAwait(false);
                Dispatcher.Invoke(new Action(() => {
                    Settings.IsEnabled = true;
                    Start.IsEnabled = true;
                    AppIDFinder.IsEnabled = true;
                }));
            });
        }


        private void Clear_Log_Click(object sender, RoutedEventArgs e)
        {
            LogBox.Items.Clear();
        }

        private void InputPath_PreviewDragOver(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
        }

        private void InputPath_PreviewDrop(object sender, DragEventArgs e)
        {
            try
            {
                string[] file = (string[])e.Data.GetData(DataFormats.FileDrop);
                if (file.Length == 1 && (File.Exists(file[0]) || Directory.Exists(file[0])))
                {
                    viewModel.InputPath = file[0];
                }
                e.Handled = true;
            }
            catch (Exception ex) 
            {
                _log.Error(ex,""); 
            }

        }

        private void Select_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var result = CustomMessageBox.ShowYesNoCancel("Select Folder or File?", "Select Folder or File?", "Folder", "File", "Cancel");
                if (result == MessageBoxResult.Yes)
                {
                    var selector = new VistaFolderBrowserDialog();
                    selector.Multiselect = false;
                    if ((bool)selector.ShowDialog())
                    {
                        viewModel.InputPath = selector.SelectedPath;
                    }
                }
                if (result == MessageBoxResult.No)
                {
                    var selector = new VistaOpenFileDialog();
                    selector.Multiselect = false;
                    selector.Filter = "Game Files|*.exe;steam_api.dll;steam_api64.dll" +
                    "|All Files|*.*";
                    if ((bool)selector.ShowDialog())
                    {
                        viewModel.InputPath = selector.FileName;
                    }
                }
            }
            catch(Exception ex)
            {
                _log.Error(ex,"Error when selecting file:");
            }
        }
        private void Hyperlink_RequestNavigate(object sender, System.Windows.Navigation.RequestNavigateEventArgs e)
        {
            try
            {
                Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri) { UseShellExecute = true });
                e.Handled = true;
            }
            catch(Exception ex)
            {
                _log.Error(ex,"");
            }
        }
        private void Exit_Click(object sender, RoutedEventArgs e)
        {
            Environment.Exit(0);
        }

        private void Settings_Click(object sender, RoutedEventArgs e)
        {
            if (!bSettingsOpened)
            {
                bSettingsOpened = true;
                Start.IsEnabled = false;
                AppIDFinder.IsEnabled = false;
                Settings.IsEnabled = false;
                var settings = new Settings();
                settings.ClosingEvent += new SettingsClosingHandler(SettingClosed);
                settings.ReloadValueEvent += new ReloadValueHandler(viewModel.ReloadValue);
                settings.ReloadValueEvent += new ReloadValueHandler(settings.ReloadValue);
                settings.Show();
            }
            
        }

        private void AppIDFinder_Click(object sender, RoutedEventArgs e)
        {
            if (!bAppIDFinderOpened)
            {
                bAppIDFinderOpened = true;
                Start.IsEnabled = false;
                Settings.IsEnabled = false;
                AppIDFinder.IsEnabled = false;
                var finder = new AppIDFinder(GetAppName());
                finder.ClosingEvent += new AppIDFinderClosingHandler(AppIDFinderClosed);
                finder.OKEvent += new AppIDFinderOKHandler(AppIDFinderOK);
                finder.Show();
            }
        }

        private void About_Click(object sender, RoutedEventArgs e)
        {
            if (!bAboutOpened)
            {
                bAboutOpened = true;

                var about = new About();
                about.ClosingEvent += new AboutClosingHandler(AboutClosed);
                about.Show();
            }
        }

        private string GetAppName()
        {
            try
            {
                if (viewModel.InputPath != string.Empty)
                {
                    return Path.GetRelativePath(Path.Combine(viewModel.InputPath, ".."),viewModel.InputPath);
                }
                else
                {
                    throw new Exception();
                }
            }
            catch 
            {
                _log.Information("Cannot get app name from input path.");
                return string.Empty;
            }
        }

        private void AppIDFinderClosed()
        {
            bAppIDFinderOpened = false;
            Start.IsEnabled = true;
            Settings.IsEnabled = true;
            AppIDFinder.IsEnabled = true;
        }

        private void AppIDFinderOK(uint appid)
        {
            viewModel.AppID = appid.ToString();
            bAppIDFinderOpened = false;
            Start.IsEnabled = true;
            Settings.IsEnabled = true;
            AppIDFinder.IsEnabled = true;
        }

        private void AboutClosed()
        {
            bAboutOpened = false;
        }

        private void SettingClosed()
        {
            bSettingsOpened = false;
            Start.IsEnabled = true;
            AppIDFinder.IsEnabled = true;
            Settings.IsEnabled = true;
        }

        public bool CheckGoldberg()
        {
            try
            {
                _log.Debug("Checking all goldberg emulator file exists or not...");
                if (!Directory.Exists(Config.GoldbergPath))
                {
                    return false;
                }
                List<string> filelist = new List<string>()
                {
                    Path.Combine(Config.GoldbergPath,"steam_api64.dll"),
                    Path.Combine(Config.GoldbergPath,"steam_api.dll"),
                    Path.Combine(Config.GoldbergPath, "experimental","steam_api64.dll"),
                    Path.Combine(Config.GoldbergPath, "experimental","steam_api.dll"),
                };
                foreach (string file in filelist)
                {
                    if (!File.Exists(file))
                    {
                        return false;
                    }
                }
                return true;
            }
            catch (Exception e)
            {
                _log.Error(e, "Failed to Check goldberg emulator.");
                return false;
            }
        }
        #endregion
        #region GenerateEMUGameInfo
        private void AppID_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            e.Handled = !uint.TryParse(AppID.Text + e.Text, out _);
        }

        private void AppID_Pasting(object sender, DataObjectPastingEventArgs e)
        {
            if (e.DataObject.GetDataPresent(typeof(String)))
            {
                String text = (String)e.DataObject.GetData(typeof(String));
                if (!uint.TryParse(text, out _))
                {
                    e.CancelCommand();
                }
            }
            else
            {
                e.CancelCommand();
            }
        }

        #endregion
        #region GenerateEMUConfig
        private void SteamID_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            e.Handled = !UInt64.TryParse(AppID.Text + e.Text, out _);
        }

        private void SteamID_Pasting(object sender, DataObjectPastingEventArgs e)
        {
            if (e.DataObject.GetDataPresent(typeof(String)))
            {
                String text = (String)e.DataObject.GetData(typeof(String));
                if (!UInt64.TryParse(text, out _))
                {
                    e.CancelCommand();
                }
            }
            else
            {
                e.CancelCommand();
            }
        }

        private void ListenPort_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            e.Handled = !ushort.TryParse(AppID.Text + e.Text, out var i);

        }

        private void ListenPort_Pasting(object sender, DataObjectPastingEventArgs e)
        {
            if (e.DataObject.GetDataPresent(typeof(String)))
            {
                String text = (String)e.DataObject.GetData(typeof(String));
                if (!ushort.TryParse(text, out _))
                {
                    e.CancelCommand();
                }
            }
            else
            {
                e.CancelCommand();
            }
        }
        private void OpenExample_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (Directory.Exists(Path.Combine(Config.GoldbergPath, "steam_settings.EXAMPLE")))
                {
                    Process.Start("explorer.exe",Path.Combine(Config.GoldbergPath, "steam_settings.EXAMPLE"));
                }
                else
                {
                    _log.Error("Goldberg Steam Emulator Config EXAMPLE folder missing.");
                }
                e.Handled = true;
            }
            catch (Exception ex)
            {
                _log.Error(ex, "");
            }
        }

        private void OpenConfigFolder_Click(object sender, RoutedEventArgs e)
        {
            if (Directory.Exists(Config.EMUConfigPath))
            {
                Process.Start("explorer.exe",Config.EMUConfigPath);
            }
            else
            {
                _log.Information("Goldberg Steam Emulator Config EXAMPLE folder not exist.");
            }
            e.Handled = true;
        }

        #endregion
        #region GenCrackOnly
        private void SelectOutpath_Click(object sender, RoutedEventArgs e)
        {
            var selector = new VistaFolderBrowserDialog();
            selector.Multiselect = false;
            if ((bool)selector.ShowDialog())
            {
                viewModel.OutputPath = selector.SelectedPath;
            }
            
        }
        #endregion
        #region Restore
        private void Restore_Checked(object sender, RoutedEventArgs e)
        {
            viewModel.GenerateEMUGameInfo = false;
            viewModel.GenerateEMUConfig = false;
            viewModel.Unpack = false;
            viewModel.ApplyEMU = false;
            viewModel.GenerateCrackOnly= false;

            GenerateEMUGameInfo.IsEnabled = false;
            GenerateEMUConfig.IsEnabled = false;
            Unpack.IsEnabled = false;
            ApplyEMU.IsEnabled = false;
            GenerateCrackOnly.IsEnabled = false;
        }

        private void Restore_Unchecked(object sender, RoutedEventArgs e)
        {
            GenerateEMUGameInfo.IsEnabled = true;
            GenerateEMUConfig.IsEnabled = true;
            Unpack.IsEnabled = true;
            ApplyEMU.IsEnabled = true;
            GenerateCrackOnly.IsEnabled = true;

            viewModel.GenerateEMUGameInfo = true;
            viewModel.GenerateEMUConfig = true;
            viewModel.Unpack = true;
            viewModel.ApplyEMU = true;
        }

        #endregion


    }
}


