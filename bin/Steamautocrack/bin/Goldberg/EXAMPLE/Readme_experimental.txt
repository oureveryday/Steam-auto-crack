This is a build of my emulator that blocks all outgoing connections from the game to non LAN ips and lets you use CPY cracks that use the 
steam_api dll to patch the exe in memory when the SteamAPI_Init() method is called.

To use a CPY style crack just rename the steam_api(64).dll crack to cracksteam_api.dll or cracksteam_api64.dll depending on the original name and replace the steamclient(64) dll with the one from this folder. 
Then use my emu like you normally would. (Don't forget to put a steam_appid.txt) (If the original steam_api dll is old you must also put a steam_interfaces.txt)


For the LAN only connections feature:
If for some reason you want to disable this feature create a file named: disable_lan_only.txt beside the steam_api dll.

I noticed a lot of games seem to connect to analytics services and other crap that I hate. 

Blocking the game from communicating with online ips without affecting the LAN functionality of my emu is a pain if you try to use a firewall so I made this special build.

In this folder is an experimental build of my emulator with code that hooks a few windows socket functions. It should block all connections from the game to non LAN ips. This means the game should work without any problems for LAN play (even with VPN LAN as long as you use standard LAN ips (10.x.x.x, 192.168.x.x, etc...)

It likely doesn't work for some games but it should work for most of them.

Since this blocks all non LAN connections doing things like hosting a cracked server for people on the internet will not work or connecting to a cracked server that's hosted on an internet ip will not work.

I will likely add this as a config option to the normal build in the future but I want to know if there are any problems first.

Let me know if there are any issues.

All ips except these ranges are blocked:
10.0.0.0 - 10.255.255.255
127.0.0.0 - 127.255.255.255
169.254.0.0 - 169.254.255.255
172.16.0.0 - 172.31.255.255
192.168.0.0 - 192.168.255.255
224.0.0.0 - 255.255.255.255


Support for loading any dlls:
Any files put in the steam_settings\load_dlls\ folder will be loaded automatically using the LoadLibraryA function.
