:: Creating variables
:: Name of the file to search
set NameOfTheFileAsParametr=%1
:: Name of the Disk
set NameOfDisk=%2

:: Search for file
for /f "tokens=*" %%a in ('dir %NameOfTheFileAsParametr% /b /s') do set PathToTheFile=%%a

cd "%PathToTheFile%\..\"

:: Creating COM File
start D:\masm32\bin\ml /Bl D:\masm32\bin\link16.exe %NameOfTheFileAsParametr%

:: I'm using DOSBox for emulating DOS. That's why I launch this program there
:: Launching COM File
:: mount c %cd% - connect physical folders and drives to virtual drives inside DOSBox
:: "keyb none 866" - to connect the appropriate language
:: %NameOfTheFileAsParametr:~0,-4%.com - launch %1.com file
start D:\masm32\DosBox\DOSBox-0.74-3\DOSBox.exe -c "mount c %PathToTheFile:~0,-11% " -c c: -c "keyb none 866" -c "%NameOfTheFileAsParametr:~0,-4%.com"
