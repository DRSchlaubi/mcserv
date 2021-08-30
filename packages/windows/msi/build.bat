@echo off

Rem This tool generates a mcserv MSI installer file

if defined WIX goto build

:fail
echo "Please set WIX to point to a Wix Toolset installation"
exit \b 1

:build
mkdir McServInstaller\build
call dart2native ..\..\..\bin\mcserv.dart -o .\McServInstaller\build\mcserv.exe
call "%WIX%\bin\candle.exe" McServInstaller\Product.wxs -o .\McServInstaller\build\
call "%WIX%\bin\light.exe" McServInstaller\build\*.wixobj -o mcserv.msi
rmdir /Q /S .\McServInstaller\build
