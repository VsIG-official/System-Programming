 :: Disable Repeatable Text In Console
@echo off

:: Creating variable to use in two places
set NameOfTheFileAsParametr=%1

:: Creating COM File
start D:\masm32\bin\ml /Bl D:\masm32\bin\link16.exe %NameOfTheFileAsParametr%.asm
:: I'm using DOSBox for emulating DOS. That's why I launch this program there
:: Launching COM File
start D:\masm32\DosBox\DOSBox-0.74-3\DOSBox.exe -c "mount c %cd% " -c c: -c "keyb none 866" -c %NameOfTheFileAsParametr%.com
