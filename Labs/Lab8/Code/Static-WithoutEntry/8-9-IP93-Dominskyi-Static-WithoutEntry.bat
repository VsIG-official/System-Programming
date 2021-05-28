:: Our variables (two .asm files, two .obj files, .dll, .def and name of the .exe)
set NameOfTheFileAsASMParametr="8-9-IP93-Dominskyi-Static-WithoutEntry.asm"
set NameOfTheFileAsOBJParametr="8-9-IP93-Dominskyi-Static-WithoutEntry.obj"
set NameOfTheFileAsEXEParametr="8-9-IP93-Dominskyi-Static-WithoutEntry.exe"
set NameOfTheFileAsDEFParametr="8-9-IP93-Dominskyi-Static-WithoutEntry.def"

set NameOfTheLibraryAsASMParametr="8-9-IP93-Dominskyi-Static-WithoutEntry-Library.asm"
set NameOfTheLibraryAsDLLParametr="8-9-IP93-Dominskyi-Static-WithoutEntry-Library.dll"
set NameOfTheLibraryAsOBJParametr="8-9-IP93-Dominskyi-Static-WithoutEntry-Library.obj"

:: There We are combining main file with dll one .exe
:: We can write there, for example, %OurDisk%\masm32\bin\ml, but We have masm commands in environment variables, so need to write only relative path
\masm32\bin\ml /c /coff "%NameOfTheLibraryAsASMParametr%"
\masm32\bin\Link.exe /OUT:"%NameOfTheLibraryAsDLLParametr%" /DEF:%NameOfTheFileAsDEFParametr% /NOENTRY /DLL "%NameOfTheLibraryAsOBJParametr%"

\masm32\bin\ml /c /coff "%NameOfTheFileAsASMParametr%"

\masm32\bin\Link.exe /SUBSYSTEM:console "%NameOfTheFileAsOBJParametr%"

:: if You want window to pause after procedure, then uncomment next row (but You need it, only if You have some problem with code)
:: pause

:: if You don't want program to run after procedure, then comment next row
%NameOfTheFileAsEXEParametr%
