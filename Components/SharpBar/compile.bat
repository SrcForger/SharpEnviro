echo off
copy ..\..\dcc32.cf~ dcc32.cfg
Dcc32 SharpBar.dpr -E..\..\..\SharpE %1 -LU"rtl;vcl"
del dcc32.cfg
echo.