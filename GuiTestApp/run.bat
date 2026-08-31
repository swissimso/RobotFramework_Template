@echo off
setlocal
cd /d "%~dp0"

if not exist "GuiTestApp.exe" (
    call "%~dp0build.bat"
    if errorlevel 1 exit /b 1
)

start "" "%~dp0GuiTestApp.exe"
