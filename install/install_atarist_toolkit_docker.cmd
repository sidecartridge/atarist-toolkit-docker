@echo off
setlocal

REM Windows stcmd installer for atarist-toolkit-docker

where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker not installed. Please install Docker Desktop first and then run this script again.
    exit /b 1
)
echo Docker is installed...

if "%DOCKER_ACCOUNT%"=="" set "DOCKER_ACCOUNT=logronoide"

set "VERSION=%~1"
if "%~1"=="" (
    echo No version supplied. Using latest version.
    set "VERSION=latest"
)

set "ARCH=%PROCESSOR_ARCHITECTURE%"
if defined PROCESSOR_ARCHITEW6432 set "ARCH=%PROCESSOR_ARCHITEW6432%"
if /I "%ARCH%"=="x86" set "ARCH=x86_64"
if /I "%ARCH%"=="AMD64" set "ARCH=x86_64"
if /I "%ARCH%"=="ARM64" set "ARCH=arm64"

set "THEDOCKER=%DOCKER_ACCOUNT%/atarist-toolkit-docker-%ARCH%:%VERSION%"
echo Pulling image %THEDOCKER%...
docker pull %THEDOCKER%

set "INSTALL_DIR=%USERPROFILE%\AppData\Local\atarist-toolkit-docker"
echo Installing to %INSTALL_DIR%...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

set "TARGET=%INSTALL_DIR%\stcmd.cmd"
echo Installing the command stcmd in %TARGET%...

> "%TARGET%" (
    echo @echo off
    echo setlocal
    echo if "%%DOCKER_ACCOUNT%%"=="" set "DOCKER_ACCOUNT=logronoide"
    echo if "%%VERSION%%"=="" set "VERSION=latest"
    echo if "%%ST_WORKING_FOLDER%%"=="" ^(
    echo     set "ST_WORKING_FOLDER=%%cd%%"
    echo     if not "%%STCMD_QUIET%%"=="1" echo ST_WORKING_FOLDER is empty: using %%cd%% as absolute path to source code working folder.
    echo ^) else ^(
    echo     if not "%%STCMD_QUIET%%"=="1" echo ST_WORKING_FOLDER is set: using %%ST_WORKING_FOLDER%% as absolute path to source code working folder.
    echo ^)
    echo set "THEDOCKER=%%DOCKER_ACCOUNT%%/atarist-toolkit-docker-%ARCH%:%%VERSION%%"
    echo docker run --platform linux/%ARCH% -it --rm -v "%%ST_WORKING_FOLDER%%:/tmp" %%THEDOCKER%% %%*
)

REM Add INSTALL_DIR to user PATH using reg.exe
for /f "usebackq tokens=2,*" %%A in (`reg query "HKCU\Environment" /v Path 2^>nul`) do set "UserPath=%%B"
if "%UserPath%"=="" (
    set "NewPath=%INSTALL_DIR%"
) else (
    echo %UserPath% | findstr /I /C:"%INSTALL_DIR%" >nul
    if errorlevel 1 (
        set "NewPath=%UserPath%;%INSTALL_DIR%"
    ) else (
        set "NewPath=%UserPath%"
    )
)
reg add "HKCU\Environment" /v Path /d "%NewPath%" /f >nul
echo Installed stcmd and added %INSTALL_DIR% to your user PATH.
echo.
echo To uninstall, simply delete this folder and remove it from your PATH.
echo.
echo You may need to restart your command prompt or log out and back in for changes to take effect.

endlocal
