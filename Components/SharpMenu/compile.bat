echo off
copy ..\..\dcc32.cf~ dcc32.cfg
Dcc32 SharpMenu.dpr -E..\..\..\SharpE %1
del dcc32.cfg
echo.