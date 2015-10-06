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

if not defined CREW_RUBY_DIR (
   set CREW_RUBY_DIR=%CREWFILEDIR%..\..\prebuilt\windows%CREWHOSTCPU%\bin\
)

rem set CREW
rem set GIT

%CREW_RUBY_DIR%ruby.exe -W0 %CREWFILEDIR%crew.rb %*

endlocal

exit /b %errorlevel%
