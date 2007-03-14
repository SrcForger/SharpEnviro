echo off
copy ..\..\dcc32.cf~ dcc32.cfg
Dcc32 SharpCore.dpr -E..\..\..\SharpE %1
del dcc32.cfg
echo.