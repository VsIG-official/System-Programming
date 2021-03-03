set startFolder=%cd%
set masm_path=D:\masm32\bin
set dos_box="D:\masm32\DosBox\DOSBox-0.74-3\DOSBox.exe"
set filename=%1

:: line beneath should be deleted
cd C:\
for /f "tokens=* USEBACKQ" %%i in (`dir %filename% /s /b`) do (
	set asmfile=%%i
	goto next1
)
:	next1

cd "%asmfile%\..\"
:: line beneath should be deleted
set folder=%cd%

%masm_path%\ml /Bl %masm_path%\link16.exe %asmfile%
:: line beneath should be deleted
%dos_box% -c "mount c %folder% " -c c:  -c %filename:.asm=COM%

cd %startFolder%
