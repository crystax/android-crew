@echo off

set retcode=0

set GEM_HOME=
set GEM_PATH=

set CREW_FILE_DIR=%~dp0
set CREW_RUBY_VERSION=2.2.0

set CREW_HOST_OS=windows
set CREW_HOST_CPU=x86_64
rem CREW_32BIT_HOST_CPU=${CREW_HOST_CPU%_64}

if not defined CREW_BASE_DIR (
   set CREW_BASE_DIR=%CREW_FILE_DIR%
)

if not defined CREW_DOWNLOAD_BASE (
   set CREW_DOWNLOAD_BASE=https://crew.crystax.net:9876
)

if not defined CREW_NDK_DIR (
   set CREW_NDK_DIR=%CREW_FILE_DIR%..\..\
)

if not defined CREW_TOOLS_DIR (
   set CREW_TOOLS_DIR=%CREW_NDK_DIR%prebuilt\%CREW_HOST_OS%-%CREW_HOST_CPU%\
)

if not defined CREW_RUBY_DIR (
   set CREW_RUBY_DIR=%CREW_TOOLS_DIR%bin\
)

set GIT_EXEC_PATH=%CREW_TOOLS_DIR%\libexec\git-core

rem set CREW
rem set GIT

%CREW_RUBY_DIR%ruby -W0 %CREW_FILE_DIR%crew.rb %*

endlocal

exit /b %errorlevel%
