using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SteamAutoCrack.Core.Utils
{
    using Serilog;
    using SteamKit2;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using System;
    using static SteamKit2.Internal.CChatUsability_ClientUsabilityMetrics_Notification;
    using System.IO;
    using System.Text.RegularExpressions;
    using AuthenticodeExaminer;
    using static SteamKit2.Internal.CMsgClientUGSGetGlobalStatsResponse;
    using static SteamKit2.DepotManifest;

    namespace SteamAutoCrack.Core.Utils
    {
        public interface IRestore
        {
            public Task<bool> RestoreFile(string path);
        }

        public class Restore : IRestore
        {
            
            private readonly ILogger _log;
            public Restore()
            {
                _log = Log.ForContext<Restore> ();
            }
            public async Task<bool> RestoreFile(string path)
            {
                try
                {
                    if (string.IsNullOrEmpty(path) || !Directory.Exists(path))
                    {
                        _log.Error("Invaild input path.");
                        return false;
                    }
                    _log.Debug("Restoring cracked file...");

                    foreach (string pathtodelete in Directory.EnumerateFiles(path, "steam_interfaces.txt", SearchOption.AllDirectories))
                    {
                        try
                        {
                            _log.Debug("Deleting \"{path}\"...", pathtodelete);
                            File.Delete(pathtodelete);
                        }
                        catch (Exception e)
                        {
                            _log.Debug(e,"Failed to delete \"{pathtodelete}\". Skipping...", pathtodelete);
                        }
                    }
                    foreach (string pathtodelete in Directory.EnumerateFiles(path, "local_save.txt", SearchOption.AllDirectories))
                    {
                        try
                        {
                            _log.Debug("Deleting \"{path}\"...", pathtodelete);
                            File.Delete(pathtodelete);
                        }
                        catch (Exception ex)
                        {
                            _log.Debug(ex,"Failed to delete \"{pathtodelete}\". Skipping...", pathtodelete);
                        }
                    }
                    foreach (string pathtorestore in Directory.EnumerateFiles(path, "*.bak", SearchOption.AllDirectories))
                    {
                        try
                        {
                            _log.Debug("Restoring \"{path}\"...", pathtorestore);
                            File.Delete(Path.Combine(Path.GetDirectoryName(pathtorestore), Path.GetFileNameWithoutExtension(pathtorestore)));
                            File.Move(pathtorestore, Path.Combine(Path.GetDirectoryName(pathtorestore), Path.GetFileNameWithoutExtension(pathtorestore)));
                        }
                        catch (Exception ex)
                        {
                            _log.Debug(ex,"Failed to restore \"{pathtodelete}\". Skipping...", pathtorestore);
                        }
                    }
                    foreach (string pathtodelete in Directory.EnumerateDirectories(path, "steam_settings", SearchOption.AllDirectories))
                    {
                        try
                        {
                            _log.Debug("Deleting \"{path}\"...", pathtodelete);
                            Directory.Delete(pathtodelete,true);
                        }
                        catch (Exception ex)
                        {
                            _log.Debug(ex,"Failed to delete \"{pathtodelete}\". Skipping...", pathtodelete);
                        }
                    }
                    _log.Information("All cracked file restored.");
                    return true;
                }
                catch (Exception ex)
                {
                    _log.Error(ex, "Failed to restore cracked file.");
                    return false;
                }
            }
        }
    }

}
