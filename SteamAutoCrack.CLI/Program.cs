using Serilog;
using Serilog.Core;
using Serilog.Events;
using Serilog.Templates;
using Serilog.Templates.Themes;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.Core.Config;
using System.CommandLine;
using System.IO;

namespace SteamAutoCrack.CLI
{
    class Program
    {

        static async Task<int> Main(string[] args)
        {
            var levelSwitch = new LoggingLevelSwitch();
            Log.Logger = new LoggerConfiguration()
               .Enrich.WithProperty("SourceContext", null)
               .MinimumLevel.ControlledBy(levelSwitch)
               .WriteTo.Console(new ExpressionTemplate(
                "[{@l:u3}] [{Substring(SourceContext, LastIndexOf(SourceContext, '.') + 1)}] {@m}\r\n{@x}", theme: TemplateTheme.Literate))
               .CreateLogger();
            levelSwitch.MinimumLevel = LogEventLevel.Information;
            var _log = Log.ForContext<Program>();
            var DebugOption = new Option<bool>(
            name: "--debug",
            description: "Enable Debug Log.");

            #region crack
            var ConfigOption = new Option<FileInfo?>(
            name: "--config",
            description: "The process config json file. [Default: config.json in program current running directory]");

            var AppIDOption = new Option<string>(
            name: "--appid",
            description: "The game Steam AppID. (Required when Generate Goldberg Steam emulator game info)");

            var pathArgument = new Argument<string>
            ("Path", "Input Path.");

            var crackCommand = new Command("crack", "Start crack process.")
            {
                pathArgument,
                ConfigOption,
                AppIDOption
            };

            crackCommand.SetHandler(async (InputPath,ConfigPath,AppID,Debug) =>
            {
                 if (Debug) SetDebugLogLevel(levelSwitch);
                 await Process(InputPath,ConfigPath,AppID);
            }, pathArgument,ConfigOption, AppIDOption, DebugOption);

            #endregion

            #region downloademu
            var ForceDownloadOption = new Option<bool>(
            name: "--force",
            description: "Force (re)download."
            );

            var downloademuCommand = new Command("downloademu", "Download/Update Goldberg Steam emulator.")
            {
                ForceDownloadOption
            };

            downloademuCommand.SetHandler(async (Force,Debug) =>
            {
                try
                {
                    if (Debug) SetDebugLogLevel(levelSwitch);
                    var updater = new EMUUpdater();
                    await updater.Init();
                    await updater.Download(Force);
                    _log.Information("Updated Goldberg Steam emulator.");
                }
                catch (Exception ex) { var _log = Log.ForContext<Program>(); _log.Error(ex, "Error to Update Steam App List."); }

            }, ForceDownloadOption, DebugOption);
            #endregion

            #region updateapplist
            var updateapplistCommand = new Command("updateapplist", "Force Update Steam App List.");
            updateapplistCommand.SetHandler(async (Debug) =>
            {
                try
                {
                    if (Debug) SetDebugLogLevel(levelSwitch);
                    await SteamAppList.Initialize(true).ConfigureAwait(false);
                    _log.Information("Steam App List Updated.");
                }
                catch (Exception ex) { var _log = Log.ForContext<Program>(); _log.Error(ex, "Error to Update Steam App List."); }
                
            },DebugOption);
            #endregion

            #region createconfig
            var configpathOption = new Option<FileInfo?>(
            name: "--path",
            description: "Changes default config path.");
            var createconfigCommand = new Command("createconfig", "Create Default Config File.")
            {
                configpathOption,
            };

            createconfigCommand.SetHandler((ConfigPath,Debug) =>
            {
                try
                {
                    if (Debug) SetDebugLogLevel(levelSwitch);
                    Config.ConfigPath = ConfigPath == null ? Config.ConfigPath : ConfigPath.FullName;
                    Config.ResettoDefaultConfigs();
                    Config.SaveConfig();
                    _log.Information("Config Created.");
                }
                catch (Exception ex) { var _log = Log.ForContext<Program>(); _log.Error(ex, "Error to Create Config."); }
            },
            configpathOption, DebugOption);

            #endregion

            #region rootcommand

            var rootCommand = new RootCommand("SteamAutoCrack " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString() + " - Steam Game Automatic Cracker")
            {
                crackCommand,
                updateapplistCommand,
                downloademuCommand,
                createconfigCommand,
            };

            rootCommand.AddGlobalOption(DebugOption);

            #endregion

            return await rootCommand.InvokeAsync(args);
        }
        static async Task Process(string InputPath, FileInfo ConfigPath,string AppID)
        {
            try
            {
                var _log = Log.ForContext<Program>();
                Config.ConfigPath = (ConfigPath != null && ConfigPath.Exists) ? ConfigPath.FullName : Config.ConfigPath;
                if (!Config.LoadConfig())
                {
                    _log.Warning("Cannot load config. Using Default Config.");
                }
                Config.InputPath = InputPath;
                Config.EMUGameInfoConfigs.AppID = AppID;
                await new Processor().ProcessFileCLI();
            }
            catch(Exception ex) { var _log = Log.ForContext<Program>(); _log.Error(ex,"Error to process."); }
        }
        static void SetDebugLogLevel(LoggingLevelSwitch levelSwitch)
        {
            levelSwitch.MinimumLevel = LogEventLevel.Debug;
        }
    }
}

