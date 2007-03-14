echo off
copy ..\..\..\dcc32.cf~ dcc32.cfg
Dcc32 Clock.dpr -E..\..\..\..\SharpE\Modules\ %1 -LU"rtl;vcl"
del dcc32.cfg
echo.