@echo off

setlocal

set testdir=%~dp0
set toolsbasedir=%testdir%..\..\..\prebuilt
if exist %toolsbasedir%\windows-x86_64 (
   set cpu=-x86_64
) else (
  set cpu=
)

set bindir=%toolsbasedir%\windows%cpu%\bin

echo %bindir%

%bindir%\make SHELL=cmd

endlocal

exit /b %errorlevel%
