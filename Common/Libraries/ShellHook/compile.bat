echo off
copy ..\..\..\dcc32.cf~ dcc32.cfg
Dcc32 shellhook.dpr -E..\..\..\..\SharpE -$J+ %1
del dcc32.cfg
echo.