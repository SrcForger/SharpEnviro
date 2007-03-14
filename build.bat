echo off
SET CP=

echo #########################################################
echo ################       Cleaning SVN       ###############
echo #########################################################

timeout 2
echo.
call clean.bat

echo #########################################################
echo ################   Compiling Libraries    ###############
echo #########################################################

timeout 2
echo.

echo ### SharpApi ###
cd Common\Libraries\SharpApi\
call Compile.bat %CP%
cd ..\..\..\

echo ### SharpThemeApi ###
cd Common\Libraries\SharpThemeApi\
call Compile.bat %CP%
cd ..\..\..\

echo ### SharpDeskApi ###
cd Common\Libraries\SharpDeskApi\
call Compile.bat %CP%
cd ..\..\..\

echo ### ShellHook ###
cd Common\Libraries\ShellHook\
call Compile.bat %CP%
cd ..\..\..\

echo ### SharpDialogs ###
cd Common\Libraries\SharpDialogs\
call Compile.bat %CP%
cd ..\..\..\

echo.
echo.
echo #########################################################
echo ################   Compiling Components   ###############
echo #########################################################

timeout 2
echo.

echo ### SharpBar ###
cd Components\SharpBar\
call Compile.bat %CP%
cd ..\..\

echo ### SharpCenter ###
cd Components\SharpCenter\
call Compile.bat %CP%
cd ..\..\

echo ### SharpCore ###
cd Components\SharpCore\
call Compile.bat %CP%
cd ..\..\

echo ### SharpMenu ###
cd Components\SharpMenu\
call Compile.bat %CP%
cd ..\..\

echo ### SharpShellServices ###
cd Components\SharpShellServices\
call Compile.bat %CP%
cd ..\..\

echo ### SharpSkin ###
cd Components\SharpSkin\
call Compile.bat %CP%
cd ..\..\

echo ### SharpSplash ###
cd Components\SharpSplash\
call Compile.bat %CP%
cd ..\..\


echo.
echo.
echo #########################################################
echo ################    Compiling Modules    ################
echo #########################################################

timeout 2
echo.

echo ### Battery Monitor ###
cd "Plugins\Modules\Battery Monitor"
call Compile.bat %CP%
cd ..\..\..\

echo ### Button ###
cd Plugins\Modules\Button
call Compile.bat %CP%
cd ..\..\..\

echo ### ButtonBar ###
cd Plugins\Modules\ButtonBar
call Compile.bat %CP%
cd ..\..\..\

echo ### Clock ###
cd Plugins\Modules\Clock
call Compile.bat %CP%
cd ..\..\..\

echo ### CPU Monitor ###
cd "Plugins\Modules\CPU Monitor"
call Compile.bat %CP%
cd ..\..\..\

echo ### iDrop ###
cd Plugins\Modules\iDrop
call Compile.bat %CP%
cd ..\..\..\

echo ### MediaController ###
cd Plugins\Modules\MediaController
call Compile.bat %CP%
cd ..\..\..\


echo ### Memory Monitor ###
cd "Plugins\Modules\Memory Monitor"
call Compile.bat %CP%
cd ..\..\..\


echo ### Menu ###
cd Plugins\Modules\Menu
call Compile.bat %CP%
cd ..\..\..\


echo ### MiniScmd ###
cd Plugins\Modules\MiniScmd
call Compile.bat %CP%
cd ..\..\..\


echo ### Notes ###
cd Plugins\Modules\Notes
call Compile.bat %CP%
cd ..\..\..\


echo ### QuickScript ###
cd Plugins\Modules\QuickScript
call Compile.bat %CP%
cd ..\..\..\

echo ### SystemTray ###
cd Plugins\Modules\SystemTray
call Compile.bat %CP%
cd ..\..\..\

echo ### Taskbar ###
cd Plugins\Modules\Taskbar
call Compile.bat %CP%
cd ..\..\..\

echo ### VolumeControl ###
cd Plugins\Modules\VolumeControl
call Compile.bat %CP%
cd ..\..\..\

echo ### Weather ###
cd Plugins\Modules\Weather
call Compile.bat %CP%
cd ..\..\..\