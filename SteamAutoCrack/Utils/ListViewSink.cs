using Serilog.Configuration;
using Serilog.Core;
using Serilog.Events;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;

namespace SteamAutoCrack.Utils
{
    public class ListViewSink : ILogEventSink
    {
        private readonly ListView _ListView;

        public ListViewSink(ListView ListView)
        {
            _ListView = ListView;
        }

        public void Emit(LogEvent logEvent)
        {
            string level = "";
            string SourceContextStr = "";
            LogEventPropertyValue SourceContext = null;
            var logColor = Brushes.White;
            switch (logEvent.Level)
            { 
                case LogEventLevel.Debug:
                    level = "Debug"; logColor = Brushes.Gray; break;
                case LogEventLevel.Warning:
                    level = "Warn"; logColor = Brushes.Yellow; break;
                case LogEventLevel.Information:
                    level = "Info"; break;
                case LogEventLevel.Error:
                    level = "Error"; logColor = Brushes.Red; break;
                default: break;
            }

            logEvent.Properties.TryGetValue("SourceContext", out SourceContext);
            SourceContextStr = SourceContext.ToString();
            SourceContextStr = SourceContextStr.Substring(SourceContextStr.LastIndexOf('.') + 1).Replace("\"", "").Replace("\\", "");
            App.Current.Dispatcher.Invoke((Action)(() =>
            {
                if (logEvent.RenderMessage() != String.Empty)
                {
                    var item = new { Level = level, Source = SourceContextStr, Message = logEvent.RenderMessage() };
                    var listviewitem = new ListViewItem { Content = item, Background = logColor };
                    _ListView.Items.Add(listviewitem);
                    _ListView.ScrollIntoView(item);
                }
                if (logEvent.Exception != null)
                {
                    var itemex = new { Level = level , Source = SourceContextStr, Message = logEvent.Exception.Message };
                    var listviewitemex = new ListViewItem { Content = itemex, Background = logColor };
                    _ListView.Items.Add(listviewitemex);
                    _ListView.ScrollIntoView(itemex);
                }
                
            }));
            
        }
    }
    public static class ListViewSinkExtensions
    {
        public static LoggerConfiguration ListViewSink(
                  this LoggerSinkConfiguration loggerConfiguration,
                  ListView listview)
        {
            return loggerConfiguration.Sink(new ListViewSink(listview));
        }
    }
}
