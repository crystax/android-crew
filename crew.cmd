@echo off

setlocal

set GEM_HOME=
set GEM_PATH=

set CREWFILEDIR=%~dp0
set CREWHOSTOS=windows

if not defined CREW_BASE_DIR (
   set CREW_BASE_DIR=%CREWFILEDIR%
)

if not defined CREW_DOWNLOAD_BASE (
   set CREW_DOWNLOAD_BASE=https://crew.crystax.net:9876
)

if not defined CREW_NDK_DIR (
   set CREW_NDK_DIR=%CREWFILEDIR%..\..\
)


set CREWHOSTCPU=-x86_64
if not exist %CREW_NDK_DIR%prebuilt\windows%CREWHOSTCPU% (
   set CREW_CPU=
)

if not defined CREW_TOOLS_DIR (
   set CREW_TOOLS_DIR=%CREW_NDK_DIR%prebuilt\windows%CREWHOSTCPU%\
)

if not defined CREW_RUBY_DIR (
   set CREW_RUBY_DIR=%CREW_TOOLS_DIR%bin\
)

set GIT_EXEC_PATH=%CREW_TOOLS_DIR%\libexec\git-core

rem set CREW
rem set GIT

%CREW_RUBY_DIR%ruby.exe -W0 %CREWFILEDIR%crew.rb %*

endlocal

exit /b %errorlevel%
