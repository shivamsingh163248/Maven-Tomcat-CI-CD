@echo off
SETLOCAL

:: Build the WAR
echo Building WAR file...
call mvn clean package

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    pause
    exit /b 1
)

set WAR=target\webapp-demo.war

if not exist "%WAR%" (
  echo WAR not found: %WAR%
  exit /b 1
)

if "%CATALINA_HOME%"=="" (
    echo ERROR: CATALINA_HOME is not set!
    pause
    exit /b 1
)

echo Copying WAR to Tomcat webapps...
copy /Y "%WAR%" "%CATALINA_HOME%\webapps\" >nul
if %ERRORLEVEL% NEQ 0 (
  echo Failed to copy WAR. Check permissions.
  exit /b 1
)

echo.
echo Deployment complete!
echo Access the application at: http://localhost:8080/webapp-demo/
pause

ENDLOCAL
