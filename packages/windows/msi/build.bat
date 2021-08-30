@echo off

Rem This tool generates a mcserv MSI installer file

if defined WIX goto build

:fail
echo "Please set WIX to point to a Wix Toolset installation"
exit \b 1

:build
cd McServInstaller
mkdir build
call dart2native ..\..\..\..\bin\mcserv.dart -o .\build\mcserv.exe
call "%WIX%\bin\candle.exe" Product.wxs -o build\
call "%WIX%\bin\light.exe" build\*.wixobj -o ..\mcserv.msi
del build
