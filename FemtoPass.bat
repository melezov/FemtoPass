@echo off
setlocal

set GoTools=%~dp0GoTools\

set FP_STEPS=4
set FP_PSE=
set FP_ARCH=/x32
set FP_UNICODE=

:loopy
rem if "%1" == "/x64" goto set_x64
rem if "%1" == "/unicode" goto set_unicode
if "%1" == "/run" goto set_run
if "%1" == "/pause" goto set_pause
if "%1" == "/?" goto show_help
:shifty
shift
if "%1" == "" goto entry
goto loopy

:set_x64
set FP_ARCH=/x64
goto shifty

:set_unicode
set FP_UNICODE=/d UNICODE=1
goto shifty

:set_run
set FP_STEPS=5
goto shifty

:set_pause
set FP_PSE=pause
goto shifty

:show_help
echo.
echo This program will build the FemtoPass program,
echo resulting in the "Binary\FemtoPass.exe" executable.
echo.
echo Switches are as follows:
rem echo (*) /x32     - builds a 32-bit (x86) variant of the program (default)
rem echo     /x64     - builds a 64 bit (AMD64) variant of the program
rem echo (*) /ansi    - builds a ANSI variant of the program (default)
rem echo     /unicode - builds a UNICODE version of the program
echo     /run     - executes the program after building it
echo     /pause   - pauses after the build/run steps
echo.

goto :EOF

:entry

echo.
echo Building FemtoPass (/? for help):
echo.

if exist "Binary" goto out_exists
mkdir Binary

:out_exists
cd Binary
echo Step #(1/%FP_STEPS%) CLEANUP
if exist "FemtoPass.bin" del "FemtoPass.bin"
if exist "FemtoPass.bin" goto errcln
if exist "FemtoPass.res" del "FemtoPass.res"
if exist "FemtoPass.res" goto errcln
if exist "FemtoPass.obj" del "FemtoPass.obj"
if exist "FemtoPass.obj" goto errcln
if exist "FemtoPass.exe" del "FemtoPass.exe"
if exist "FemtoPass.exe" goto errcln

cd ..\Source
echo Step #(2/%FP_STEPS%) RESOURCES
"%GoTools%GoRC.exe" /b /ni /r /fo "..\Binary\FemtoPass.res" "FemtoPass.rc"
if errorlevel 1 goto errres

cd ..\Source
echo Step #(3/%FP_STEPS%) ASSEMBLY
"%GoTools%GoAsm.exe" /b /ni %FP_ARCH% %FP_UNICODE% /fo "..\Binary\FemtoPass.obj" "FemtoPass.asm"
if errorlevel 1 goto errasm

cd ..\Binary
echo Step #(4/%FP_STEPS%) LINKER
"%GoTools%GoLink.exe" /console /ni /fo "FemtoPass.exe" /entry FemtoPass_Entry "FemtoPass.obj" "FemtoPass.res" kernel32.dll
if errorlevel 1 goto errlink

if "%FP_STEPS%" == "4" goto Bye

cd ..\Binary
echo Step #(5/%FP_STEPS%) EXECUTION
start FemtoPass
goto Bye

:errcln
echo.
echo CLEANUP Error!
goto Bye

:errres
echo.
echo RESOURCES Error!
goto Bye

:errasm
echo.
echo ASSEMBLY Error!
goto Bye

:errlink
echo.
echo LINKER Error!
goto Bye

:Bye
cd ..
echo.
%FP_PSE%
