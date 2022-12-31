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
            Log.Error("CLI version not implemented yet.");
            /*SteamAppList.Initialize(false);
           
            */
        }


    }
}

