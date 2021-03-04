@echo off

set masm_path=D:\masm32\bin
set dos_box="D:\masm32\DosBox\DOSBox-0.74-3\DOSBox.exe"
set filename=%1
set AsmFile=.asm
set ComFile=.com

:: line beneath should be deleted

cd "%asmfile%\..\"
:: line beneath should be deleted
set folder=%cd%

%masm_path%\ml /Bl %masm_path%\link16.exe %filename%.asm
:: line beneath should be deleted
%dos_box% -c "mount c %folder% " -c c: -c "keyb none 866" -c %filename%%ComFile%
