:: Our variables (two .asm files, two .obj files, .dll, .def and name of the .exe)
set NameOfTheFileAsASMParametr="8-9-IP93-Dominskyi-Static-Entry.asm"
set NameOfTheFileAsOBJParametr="8-9-IP93-Dominskyi-Static-Entry.obj"
set NameOfTheFileAsEXEParametr="8-9-IP93-Dominskyi-Static-Entry.exe"
set NameOfTheFileAsDEFParametr="8-9-IP93-Dominskyi-Static-Entry.def"

set NameOfTheLibraryAsASMParametr="8-9-IP93-Dominskyi-Static-Entry-Library.asm"
set NameOfTheLibraryAsDLLParametr="8-9-IP93-Dominskyi-Static-Entry-Library.dll"
set NameOfTheLibraryAsOBJParametr="8-9-IP93-Dominskyi-Static-Entry-Library.obj"

:: There We are combining main file with dll one .exe
:: We can write there, for example, %OurDisk%\masm32\bin\ml, but We have masm commands in environment variables, so need to write only relative path
\masm32\bin\ml /c /coff "%NameOfTheLibraryAsASMParametr%"
\masm32\bin\Link.exe /OUT:"%NameOfTheLibraryAsDLLParametr%" /DLL /DEF:%NameOfTheFileAsDEFParametr%  "%NameOfTheLibraryAsOBJParametr%"

\masm32\bin\ml /c /coff "%NameOfTheFileAsASMParametr%"

\masm32\bin\Link.exe /subsystem:console "%NameOfTheFileAsOBJParametr%"

:: if You want window to pause after procedure, then uncomment next row (but You need it, only if You have some problem with code)
:: pause

:: if You don't want program to run after procedure, then comment next row
%NameOfTheFileAsEXEParametr%