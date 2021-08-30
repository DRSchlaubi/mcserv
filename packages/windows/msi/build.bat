@echo off

Rem This tool generates a mcserv MSI installer file

if defined WIX_HOME goto build

:fail
echo "Please set WIX_HOME to point to a Wix Toolset installation"
exit \b 1

:build
cd McServInstaller
mkdir build
call dart2native ..\..\..\..\bin\mcserv.dart -o .\build\mcserv.exe
call "%WIX_HOME%\bin\candle.exe" Product.wxs -o build\
call "%WIX_HOME%\bin\light.exe" build\*.wixobj -o ..\mcserv.msi
del build
