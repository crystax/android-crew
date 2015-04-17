@echo off

setlocal

set GEM_HOME=
set GEM_PATH=

set CREW_FILE_DIR=%~dp0
set CREW_RUBY_VERSION=2.2.0

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
   set CREW_TOOLS_DIR=%CREW_NDK_DIR%tools\
)

if not defined CREW_RUBY_DIR (
   set CREW_RUBY_DIR=%CREW_TOOLS_DIR%ruby\bin
)

set GIT_EXEC_PATH=%CREW_TOOLS_DIR%git\libexec\git-core

rem set CREW
rem set GIT

%CREW_RUBY_DIR%ruby -W0 %CREW_FILE_DIR%crew.rb %*

endlocal
