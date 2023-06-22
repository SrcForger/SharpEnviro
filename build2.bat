@echo off

set OutputPath="..\SharpE"
set Version="0.8.0.0"

echo "Resources - Common"

echo SharpE Skin Components (Application)
echo Common\Packages\SharpE Skin Components\SharpESkinComponents.dproj

echo SharpE Components (Application)
echo Common\Packages\SharpE Components\SharpEComponents.dproj

echo SharpNotify (Resource)
echo Common\Units\SharpNotify\res\buildressource.bat

echo "Resources - Plugins"

echo Weather (Resource)
echo Plugins\Objects\Weather\res\buildressource.bat

echo "Configurations - Components"
  
echo Toolbar List (DLL)
echo Plugins\Configurations\Components\Barlist\BarList.dproj

echo Desktop (DLL)
echo Plugins\Configurations\Components\DesktopSettings\DesktopSettings.dproj

echo Filter List (DLL)
echo Plugins\Configurations\Components\FilterList\FilterList.dproj

echo Home (DLL)
echo Plugins\Configurations\Components\Home\Home.dproj

echo Menu Editor (DLL)
echo Plugins\Configurations\Components\MenuEdit\MenuEdit.dproj

echo Menu List (DLL)
echo Plugins\Configurations\Components\MenuList\MenuList.dproj

echo Menu (DLL)
echo Plugins\Configurations\Components\MenuSettings\MenuSettings.dproj

echo Module List (DLL)
echo Plugins\Configurations\Components\ModuleList\ModuleList.dproj

echo Object List (DLL)
echo Plugins\Configurations\Components\ObjectList\ObjectList.dproj

echo Proxy (DLL)
echo Plugins\Configurations\Components\Proxy\Proxy.dproj

echo Service List (DLL)
echo Plugins\Configurations\Components\ServiceList\ServiceList.dproj

echo Theme List (DLL)
echo Plugins\Configurations\Components\ThemeList\ThemeList.dproj

echo "Configurations - Modules"

echo AlarmClock (DLL)
echo Plugins\Configurations\Modules\AlarmClock\AlarmClock.dproj

echo AppBar List (DLL)
echo Plugins\Configurations\Modules\AppBarList\AppBarList.dproj
 
echo AppBar Options (DLL)
echo Plugins\Configurations\Modules\AppBarOptions\AppBarOptions.dproj

echo Battery Monitor (DLL)
echo Plugins\Configurations\Modules\BatteryMonitor\BatteryMonitor.dproj

echo Button (DLL)
echo Plugins\Configurations\Modules\ButtonModule\ButtonModule.dproj

echo Button Bar List (DLL)
echo Plugins\Configurations\Modules\ButtonBarList\ButtonBarList.dproj

echo Button Bar Options (DLL)
echo Plugins\Configurations\Modules\ButtonBarOptions\ButtonBarOptions.dproj

echo Clock (DLL)
echo Plugins\Configurations\Modules\Clock\Clock.dproj

echo CPU Monitor (DLL)
echo Plugins\Configurations\Modules\CPUMonitor\CPUMonitor.dproj

echo Keyboard Layout (DLL)
echo Plugins\Configurations\Modules\KeyboardLayout\KeyboardLayout.dproj

echo Media Controller (DLL)
echo Plugins\Configurations\Modules\MediaController\MediaController.dproj

echo Memory Monitor (DLL)
echo Plugins\Configurations\Modules\MemoryMonitor\MemoryMonitor.dproj

echo Menu (DLL)
echo Plugins\Configurations\Modules\MenuModule\MenuModule.dproj

echo Mini Scmd (DLL)
echo Plugins\Configurations\Modules\MiniScmd\MiniScmd.dproj

echo Notes (DLL)
echo Plugins\Configurations\Modules\Notes\Notes.dproj

echo RSS Reader (DLL)
echo Plugins\Configurations\Modules\RSS Reader\RSSReader.dproj

echo Show Desktop (DLL)
echo Plugins\Configurations\Modules\ShowDesktop\ShowDesktop.dproj

echo Spacer (DLL)
echo Plugins\Configurations\Modules\Spacer\Spacer.dproj

echo System Tray (DLL)
echo Plugins\Configurations\Modules\SystemTray\SystemTray.dproj

echo Task (DLL)
echo Plugins\Configurations\Modules\TaskModule\TaskModule.dproj

echo Volume Control (DLL)
echo Plugins\Configurations\Modules\VolumeControl\VolumeControl.dproj

echo VWM (DLL)
echo Plugins\Configurations\Modules\VWM\VWM.dproj

echo Weather (DLL)
echo Plugins\Configurations\Modules\WeatherModule\WeatherModule.dproj

echo "Configurations - Services"

echo Alias List (DLL)
echo Plugins\Configurations\Services\AliasList\AliasList.dproj

echo DeskArea (DLL)
echo Plugins\Configurations\Services\DeskArea\DeskArea.dproj

echo Hotkey List (DLL)
echo Plugins\Configurations\Services\HotkeyList\HotkeyList.dproj

echo Multimedia Input (DLL)
echo Plugins\Configurations\Services\MultimediaInput\MultimediaInput.dproj

echo Multimedia Input List (DLL)
echo Plugins\Configurations\Services\MultimediaInputList\MultimediaInputList.dproj

echo VWM (DLL)
echo Plugins\Configurations\Services\VWM\VWM.dproj

echo Weather (DLL)
echo Plugins\Configurations\Services\Weather\Weather.dproj

echo "Configurations - Themes"

echo Cursor List (DLL)
echo Plugins\Configurations\Themes\CursorList\CursorList.dproj

echo Desktop Theme (DLL)
echo Plugins\Configurations\Themes\DesktopTheme\DesktopTheme.dproj

echo Glass (DLL)
echo Plugins\Configurations\Themes\Glass\Glass.dproj

echo Icon List (DLL)
echo Plugins\Configurations\Themes\IconList\IconList.dproj

echo Scheme Editor (DLL)
echo Plugins\Configurations\Themes\SchemeEdit\SchemeEdit.dproj

echo Scheme List (DLL)
echo Plugins\Configurations\Themes\SchemeList\SchemeList.dproj

echo Skin List (DLL)
echo Plugins\Configurations\Themes\SkinList\SkinList.dproj

echo Skin Font (DLL)
echo Plugins\Configurations\Themes\Font\Font.dproj

echo Wallpaper (DLL)
echo Plugins\Configurations\Themes\Wallpaper\Wallpaper.dproj

echo Weather Icons (DLL)
echo Plugins\Configurations\Themes\WeatherIcons\WeatherIcons.dproj

echo "Configurations - Objects"

echo Clock (DLL)
echo Plugins\Configurations\Objects\Clock\Clock.dproj

echo Drive (DLL)
echo Plugins\Configurations\Objects\Drive\Drive.dproj

echo Image (DLL)
echo Plugins\Configurations\Objects\Image\Image.dproj

echo Link (DLL)
echo Plugins\Configurations\Objects\Link\Link.dproj

echo Recycle Bin (DLL)
echo Plugins\Configurations\Objects\RecycleBin\RecycleBin.dproj

echo Weather (DLL)
echo Plugins\Configurations\Objects\Weather\Weather.dproj

echo "Components"

echo ExplorerNET 32-Bit (x86)
echo Components\ExplorerNET\Explorer.sln

echo ExplorerNET 64-Bit (x64)
echo Components\ExplorerNET\Explorer.sln

echo SetShell (Application)
echo Components\SetShell\SetShell.dproj

echo SharpAdmin (Application)
echo Components\SharpAdmin\SharpAdmin.dproj

echo SharpBar (Application)
echo Components\SharpBar\SharpBar.dproj

echo SharpCenter (Application)
echo Components\SharpCenter\SharpCenter.dproj

echo SharpConsole (Application)
echo Components\SharpConsole\SharpConsole.dproj

echo SharpCore (Application)
echo Components\SharpCore\SharpCore.dproj

echo SharpDesk (Application)
echo Components\SharpDesk\SharpDesk.dproj

echo SharpLinkLauncherNET (Solution)
echo Components\SharpLinkLauncherNET\SharpLinkLauncherNET.sln

echo SharpMenu (Application)
echo Components\SharpMenu\SharpMenu.dproj

echo SharpSplash (Application)
echo Components\SharpSplash\SharpSplash.dproj

echo SharpSkin (Application)
echo Components\SharpSkin\SharpSkin.dproj

echo "Libraries"

echo SharpApi (DLL)
echo Common\Libraries\SharpAPI\SharpApi.dproj

echo SharpApiEx (DLL)
echo Common\Libraries\SharpApiEx\SharpApiEx.dproj

echo SharpCenterApi (DLL)
echo Common\Libraries\SharpCenterApi\SharpCenterApi.dproj

echo SharpDeskApi (DLL)
echo Common\Libraries\SharpDeskApi\SharpDeskApi.dproj

echo SharpDialogs (DLL)
echo Common\Libraries\SharpDialogs\SharpDialogs.dproj

echo SharpThemeApiEx (DLL)
echo Common\Libraries\SharpThemeApiEx\SharpThemeApiEx.dproj

echo SharpTwitter (Solution)
echo Common\Libraries\SharpTwitter\SharpTwitter.sln

echo "Modules"

echo Alarm Clock (DLL)
echo Plugins\Modules\AlarmClock\AlarmClock.dproj

echo Application Bar (DLL)
echo Plugins\Modules\ApplicationBar\ApplicationBar.dproj

echo Battery Monitor (DLL)
echo Plugins\Modules\Battery Monitor\BatteryMonitor.dproj

echo Button (DLL)
echo Plugins\Modules\Button\Button.dproj

echo Button Bar (DLL)
echo Plugins\Modules\ButtonBar\ButtonBar.dproj

echo Clock (DLL)
echo Plugins\Modules\Clock\Clock.dproj

echo CPU Monitor (DLL)
echo Plugins\Modules\CPU Monitor\CPUMonitor.dproj

echo Keyboard Layout (DLL)
echo Plugins\Modules\Keyboard Layout\KeyboardLayout.dproj

echo Media Controller (DLL)
echo Plugins\Modules\MediaController\MediaController.dproj

echo Memory Monitor (DLL)
echo Plugins\Modules\Memory Monitor\MemoryMonitor.dproj

echo Menu (DLL)
echo Plugins\Modules\Menu\Menu.dproj

echo Mini Scmd (DLL)
echo Plugins\Modules\MiniScmd\MiniScmd.dproj

echo Notes (DLL)
echo Plugins\Modules\Notes\Notes.dproj

echo Recycle Bin (DLL)
echo Plugins\Modules\RecycleBin\RecycleBin.dproj

echo RSS Reader (DLL)
echo Plugins\Modules\RSS Reader\RSSReader.dproj

echo Show Desktop (DLL)
echo Plugins\Modules\ShowDesktop\ShowDesktop.dproj

echo Spacer (DLL)
echo Plugins\Modules\Spacer\Spacer.dproj

echo System Tray (DLL)
echo Plugins\Modules\SystemTray\SystemTray.dproj

echo Taskbar (DLL)
echo Plugins\Modules\Taskbar\Taskbar.dproj

echo Volume Control (DLL)
echo Plugins\Modules\VolumeControl\VolumeControl.dproj

echo VWM (DLL)
echo Plugins\Modules\VWM\VWM.dproj

echo Weather (DLL)
echo Plugins\Modules\Weather\Weather.dproj

echo "Objects"

echo Clock (DLL)
echo Plugins\Objects\Clock\Clock.dproj

echo Drive (DLL)
echo Plugins\Objects\Drive\Drive.dproj

echo Image (DLL)
echo Plugins\Objects\Image\Image.dproj

echo Link (DLL)
echo Plugins\Objects\Link\Link.dproj

echo Recycle Bin (DLL)
echo Plugins\Objects\RecycleBin\RecycleBin.dproj

echo Weather (DLL)
echo Plugins\Objects\Weather\Weather.dproj

echo "Services"

echo Actions (DLL)
echo Plugins\Services\Actions\Actions.dproj

echo Cursors (DLL)
echo Plugins\Services\Cursors\Cursors.dproj

echo Debug (DLL)
echo Plugins\Services\Debug\Debug.dproj

echo DDEServer (DLL)
echo Plugins\Services\DDEServer\DDEServer.dproj

echo Exec (DLL)
echo Plugins\Services\Exec\Exec.dproj

echo Hotkeys (DLL)
echo Plugins\Services\Hotkeys\Hotkeys.dproj

echo Multimedia Input (DLL)
echo Plugins\Services\MultimediaInput\MultimediaInput.dproj

echo Shell (DLL)
echo Plugins\Services\Shell\Shell.dproj

echo Skin (DLL)
echo Plugins\Services\Skin\SkinController.dproj

echo Startup (DLL)
echo Plugins\Services\StartupApps\Startup.dproj

echo SystemActions (DLL)
echo Plugins\Services\SystemActions\SystemActions.dproj

echo VWM (DLL)
echo Plugins\Services\VWM\VWM.dproj

echo Weather (DLL)
echo Plugins\Services\Weather\Weather.dproj

echo "Tools"

echo SkinConverter (Application)
echo Tools\SkinConvert\SkinConvert.dproj

echo "Files"
echo copy .\FDS ..\SharpE

echo "Done."
