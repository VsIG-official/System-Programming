:: Our variables (two .asm files, two .obj files and name of the .exe)
set NameOfTheFirstFileAsASMParametr="7-9-IP93-Dominskyi.asm"
set NameOfTheSecondFileAsASMParametr="7-9-IP93-Dominskyi-1.asm"
set NameOfTheFirstFileAsOBJParametr="7-9-IP93-Dominskyi.obj"
set NameOfTheSecondFileAsOBJParametr="7-9-IP93-Dominskyi-1.obj"
set NameOfTheFileAsEXEParametr="7-9-IP93-Dominskyi.exe"

:: We cam write there, for example, %OurDisk%\masm32\bin\ml, but We have masm commands in environment variables, so need to write only relative path
\masm32\bin\ml /c /coff "%NameOfTheFirstFileAsASMParametr%"
\masm32\bin\ml /c /coff "%NameOfTheSecondFileAsASMParametr%"

:: There We are combining two .asm files into one .exe
\masm32\bin\Link.exe /subsystem:windows /out:%NameOfTheFileAsEXEParametr% "%NameOfTheFirstFileAsOBJParametr%" "%NameOfTheSecondFileAsOBJParametr%"

:: if You want window to pause after procedure, then uncomment next row (but You need it, only if You have some problem with code)
:: pause

:: if You don't want program to run after procedure, then comment next row
%NameOfTheFileAsEXEParametr%
