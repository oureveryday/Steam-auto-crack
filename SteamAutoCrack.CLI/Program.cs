using Serilog;
using Serilog.Core;
using Serilog.Events;
using Serilog.Templates;
using Serilog.Templates.Themes;
using SQLitePCL;
using SteamAutoCrack.Core.Config;
using SteamAutoCrack.Core.Utils;
using SteamAutoCrack.Core.Utils.SteamAutoCrack.Core.Utils;

namespace SteamAutoCrack.CLI
{
    class Program
    {
        static async Task Main()
        {
            var levelSwitch = new LoggingLevelSwitch();
            Log.Logger = new LoggerConfiguration()
               .Enrich.WithProperty("SourceContext", null)
               .MinimumLevel.ControlledBy(levelSwitch)
               .WriteTo.Console(new ExpressionTemplate(
                "[{@l:u3}] [{Substring(SourceContext, LastIndexOf(SourceContext, '.') + 1)}] {@m}\r\n{@x}", theme: TemplateTheme.Literate))
               .CreateLogger();
            levelSwitch.MinimumLevel = LogEventLevel.Debug;
            /* SteamAppList.Initialize(false);
             var config = new EMUGameInfoConfig()
             {
                 GameInfoAPI = EMUGameInfoConfig.GeneratorGameInfoAPI.GeneratorSteamClient,
                 GenerateImages = true,
                 SteamWebAPIKey = "1DD0450A99F573693CD031EBB160907D",
                 AppID = 992300,
                 UseXan105API = false,
                 UseSteamWebAppList = false,
             };
             await new EMUGameInfo().Generate(config).ConfigureAwait(false);*/

            /*var emu = new EMUConfig()
            {
                UseCustomIP = true,
                CustomIP = "127.0.0.0",
            };
            new EMUConfigGenerator().Generate(emu);*/

            /*SteamAppList.Initialize();
            await SteamAppList.WaitForReady().ConfigureAwait(false);
            var a = await SteamAppList.GetListOfAppsByNameFuzzy("The Scroll Of Taiwu");
            foreach (var app in a)
            {
                Console.WriteLine(app);
            }
*/
            var a = new EMUUpdater();
            await a.Init().ConfigureAwait(false);
            await a.Download(true).ConfigureAwait(false);

        }


    }
}

