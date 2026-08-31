@echo off
setlocal
cd /d "%~dp0"

set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"

if not exist "%CSC%" (
    echo ERROR: .NET Framework C# compiler was not found.
    echo Try build.ps1 instead, or compile GuiTestApp.cs with Visual Studio.
    pause
    exit /b 1
)

echo Building GUI Test Playground...
"%CSC%" /nologo /target:winexe /out:"%~dp0GuiTestApp.exe" /reference:System.dll /reference:System.Core.dll /reference:System.Drawing.dll /reference:System.Windows.Forms.dll "%~dp0GuiTestApp.cs"

if errorlevel 1 (
    echo.
    echo Build failed.
    pause
    exit /b 1
)

echo Built: %~dp0GuiTestApp.exe
exit /b 0
