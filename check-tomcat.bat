@echo off
echo ====================================
echo Checking Apache Tomcat Installation
echo ====================================
echo.

:: Check CATALINA_HOME environment variable
if "%CATALINA_HOME%"=="" (
    echo [WARNING] CATALINA_HOME is NOT set!
    echo.
) else (
    echo [OK] CATALINA_HOME is set to:
    echo %CATALINA_HOME%
    echo.

    if exist "%CATALINA_HOME%\bin\catalina.bat" (
        echo [OK] Tomcat installation found!
        echo.

        :: Check Tomcat version
        if exist "%CATALINA_HOME%\bin\version.bat" (
            echo Tomcat Version:
            call "%CATALINA_HOME%\bin\version.bat" | findstr "Server version"
            echo.
        )
    ) else (
        echo [ERROR] Tomcat binaries not found at CATALINA_HOME location!
        echo.
    )
)

:: Search for Tomcat installations in common locations
echo Searching for Tomcat in common locations...
echo.

for %%D in (C:\ D:\ E:\) do (
    if exist "%%Dapache-tomcat*" (
        echo [FOUND] %%Dapache-tomcat*
        dir /b /ad "%%Dapache-tomcat*" 2>nul
    )
)

:: Check Program Files
if exist "C:\Program Files\Apache Software Foundation\Tomcat*" (
    echo [FOUND] C:\Program Files\Apache Software Foundation\Tomcat*
    dir /b /ad "C:\Program Files\Apache Software Foundation\Tomcat*" 2>nul
)

if exist "C:\Program Files (x86)\Apache Software Foundation\Tomcat*" (
    echo [FOUND] C:\Program Files (x86)\Apache Software Foundation\Tomcat*
    dir /b /ad "C:\Program Files (x86)\Apache Software Foundation\Tomcat*" 2>nul
)

echo.
echo ====================================
echo Checking Tomcat Process
echo ====================================
echo.

tasklist /FI "IMAGENAME eq java.exe" 2>nul | find /I "java.exe" >nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Java processes running (Tomcat may be running):
    tasklist /FI "IMAGENAME eq java.exe" /V
) else (
    echo [INFO] No Java processes found. Tomcat is not running.
)

echo.
echo ====================================
echo Summary
echo ====================================
echo.
if not "%CATALINA_HOME%"=="" (
    echo Set CATALINA_HOME in this project by running:
    echo set CATALINA_HOME=YOUR_TOMCAT_PATH
    echo.
    echo Or set it permanently in System Environment Variables.
)

pause

