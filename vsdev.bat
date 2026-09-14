@echo off
setlocal

for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath`) do (set "VSINSTALL=%%i")

if not defined VSINSTALL (
    echo Visual Studio not found.
    exit /b 1
)

set "VSCMD_START_DIR=%CD%"
"%VSINSTALL%\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x64 -no_logo
