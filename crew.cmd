@echo off

setlocal

set GEM_HOME=
set GEM_PATH=

set CREWFILEDIR=%~dp0
set CREWHOSTOS=windows

set CREWHOSTCPU=-x86_64
if not exist %CREWFILEDIR%..\..\prebuilt\windows%CREWHOSTCPU% (
   set CREWHOSTCPU=
)

if not defined SSL_CERT_FILE (
    set SSL_CERT_FILE=%CREWFILEDIR%\etc\ca-certificates.crt
)

if not defined CREW_TOOLS_DIR (
   set CREW_TOOLS_DIR=%CREWFILEDIR%..\..\prebuilt\windows%CREWHOSTCPU%
)

rem set CREW
rem set GIT

set CREWRUBYVER=
pushd %CREW_TOOLS_DIR%\crew\ruby
for /f "delims=" %%a in ('type active_version.txt') do @set CREWRUBYVER=%%a
popd
set CREWRUBYDIR=%CREW_TOOLS_DIR%\crew\ruby\%CREWRUBYVER%\bin

%CREWRUBYDIR%\ruby.exe -W0 %CREWFILEDIR%crew.rb %*

endlocal

exit /b %errorlevel%
