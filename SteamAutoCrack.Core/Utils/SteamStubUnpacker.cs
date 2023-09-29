namespace SteamAutoCrack.Core.Utils
{
#pragma warning disable CS4014

    using Serilog;
    using Steamless.API;
    using Steamless.API.Events;
    using Steamless.API.Model;
    using Steamless.API.Services;
    using System;
    using System.Diagnostics;
    using System.Reflection;
    using static SteamKit2.GC.Dota.Internal.CMsgDOTAWeekendTourneyParticipationDetails;
    using static System.Net.Mime.MediaTypeNames;

    namespace SteamAutoCrack.Core.Utils
    {
        public class SteamStubUnpackerConfig
        {
            /// <summary>
            /// Keeps the .bind section in the unpacked file.
            /// </summary>
            public bool KeepBind { get; set; } = true;
            /// <summary>
            /// Keeps the DOS stub in the unpacked file.
            /// </summary>
            public bool KeepStub { get; set; } = false;
            /// <summary>
            /// Realigns the unpacked file sections.
            /// </summary>
            public bool Realign { get; set; } = false;
            /// <summary>
            /// Recalculates the unpacked file checksum.
            /// </summary>
            public bool ReCalcChecksum { get; set; } = false;
            /// <summary>
            /// Use Experimental Features.
            /// </summary>
            public bool UseExperimentalFeatures { get; set; } = false;
        }

        public class SteamStubUnpackerConfigDefault
        {
            /// <summary>
            /// Keeps the .bind section in the unpacked file.
            /// </summary>
            public static readonly bool KeepBind = true;
            /// <summary>
            /// Keeps the DOS stub in the unpacked file.
            /// </summary>
            public static readonly bool KeepStub = false;
            /// <summary>
            /// Realigns the unpacked file sections.
            /// </summary>
            public static readonly bool Realign = false;
            /// <summary>
            /// Recalculates the unpacked file checksum.
            /// </summary>
            public static readonly bool ReCalcChecksum = false;
            /// <summary>
            /// Use Experimental Features.
            /// </summary>
            public static readonly bool UseExperimentalFeatures = false;
        }

        public interface ISteamStubUnpacker
        {
            public Task<bool> Unpack(string path);
        }

        public class SteamStubUnpacker : ISteamStubUnpacker
        {
            private readonly ILogger _log;
            private readonly SteamlessOptions steamlessOptions;
            private readonly List<SteamlessPlugin> steamlessPlugins = new List<SteamlessPlugin>();
            private readonly LoggingService steamlessLoggingService = new LoggingService();
            
            public SteamStubUnpacker(SteamStubUnpackerConfig SteamStubUnpackerConfig)
            {
                _log = Log.ForContext<SteamStubUnpacker>();
                steamlessOptions = new SteamlessOptions()
                {
                    KeepBindSection = SteamStubUnpackerConfig.KeepBind,
                    ZeroDosStubData = !SteamStubUnpackerConfig.KeepStub,
                    DontRealignSections = !SteamStubUnpackerConfig.Realign,
                    RecalculateFileChecksum = SteamStubUnpackerConfig.ReCalcChecksum,
                    UseExperimentalFeatures = SteamStubUnpackerConfig.UseExperimentalFeatures,
                };
                steamlessLoggingService.AddLogMessage += (sender, e) =>
                {
                    try
                    {
                        Log.ForContext("SourceContext", sender.GetType().Assembly.GetName().Name.Replace(".","")).Debug(e.Message);
                    }
                    catch
                    {
                    }
                };
                GetSteamlessPlugins();
            }

            private void GetSteamlessPlugins()
            {
                try
                {
                    var existsteamlessPlugins = new List<SteamlessPlugin>()
                    {
                        new Steamless.Unpacker.Variant10.x86.Main(),
                        new Steamless.Unpacker.Variant20.x86.Main(),
                        new Steamless.Unpacker.Variant21.x86.Main(),
                        new Steamless.Unpacker.Variant30.x86.Main(),
                        new Steamless.Unpacker.Variant30.x64.Main(),
                        new Steamless.Unpacker.Variant31.x86.Main(),
                        new Steamless.Unpacker.Variant31.x64.Main()
                    };
                    foreach (var plugin in existsteamlessPlugins)
                    {
                        if (!plugin.Initialize(steamlessLoggingService))
                        {
                            _log.Error($"Failed to load plugin: plugin failed to initialize. ({plugin.Name})");
                            continue;
                        }
                        steamlessPlugins.Add(plugin);
                    }
                }
                catch
                {
                    _log.Error("Failed to load plugin.");
                }
            }
            
            public async Task<bool> Unpack(string path)
            {
                try
                {
                    if (string.IsNullOrEmpty(path) || !( File.Exists(path)||Directory.Exists(path)))
                    {
                        _log.Error("Invaild input path.");
                        return false;
                    }
                    if (File.GetAttributes(path).HasFlag(FileAttributes.Directory))
                    {
                        await UnpackFolder(path); 
                    }
                    else
                    {
                        await UnpackFile(path);
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    _log.Error(ex, "Failed to unpack.");
                    return false;
                }
            }

            private async Task UnpackFolder(string path)
            {
                try
                {
                    _log.Information("Unpacking all file in folder \"{path}\"...", path);
                    foreach(string exepath in Directory.EnumerateFiles(path, "*.exe", SearchOption.AllDirectories))
                    {
                        await UnpackFile(exepath);
                    }
                    _log.Information("All file in folder \"{path}\" processed.", path);
                }
                catch (Exception ex)
                {
                    _log.Error(ex, "Failed to unpack folder \"{path}\".", path);
                }
            }

            private async Task UnpackFile(string path)
            {
                try
                {
                    bool bSuccess = false;
                    bool bError = false;
                    _log.Information("Unpacking file \"{path}\"...", path);
                    foreach (var p in steamlessPlugins)
                    {
                        if (p.CanProcessFile(path))
                        {
                            if (p.ProcessFile(path, steamlessOptions))
                            {
                                bSuccess = true;
                                bError = false;
                                _log.Information("Successfully unpacked file \"{path}\"", path);
                                if (File.Exists(Path.ChangeExtension(path, ".exe.bak")))
                                {
                                    _log.Debug("Backup file already exists, skipping backup process...");
                                    File.Delete(path);
                                }
                                else
                                {
                                    File.Move(path, Path.ChangeExtension(path, ".exe.bak"));
                                }
                                File.Move(Path.ChangeExtension(path, ".exe.unpacked.exe"),path);
                            }
                            else
                            {
                                bError = true;
                                _log.Warning("Failed to unpack file \"{path}\".(File not Packed/Other Protector)", path);
                            }
                        }
                    }
                    if (!bSuccess && !bError)
                    {
                        _log.Warning("Cannot to unpack file \"{path}\".(File not Packed/Other Protector)", path);
                    }
                }
                catch (Exception ex)
                {
                    _log.Error(ex, "Failed to unpack or backup File \"{path}\".", path);
                    throw new Exception($"Failed to unpack or backup File \"{path}\".");
                }
            }
        }

    }





}
