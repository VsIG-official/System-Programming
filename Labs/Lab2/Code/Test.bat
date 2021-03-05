:: Creating variable
set NameOfTheFileAsParametr=%1

for /r \ %%a in (%NameOfTheFileAsParametr%) do set "location=%%~dpa"

:: Creating COM File
start D:\masm32\bin\ml /Bl D:\masm32\bin\link16.exe %NameOfTheFileAsParametr%

:: I'm using DOSBox for emulating DOS. That's why I launch this program there
:: Launching COM File
:: mount c %cd% - connect physical folders and drives to virtual drives inside DOSBox
:: "keyb none 866" - to connect the appropriate language
:: %NameOfTheFileAsParametr:~0,-4%.com - launch %1.com file
start D:\masm32\DosBox\DOSBox-0.74-3\DOSBox.exe -c "mount c %cd% " -c c: -c "keyb none 866" -c "%NameOfTheFileAsParametr:~0,-4%.com"
