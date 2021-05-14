:: Our variables
set NameOfTheFirstFileAsASMParametr="7-9-IP93-Dominskyi.asm"
set NameOfTheSecondFileAsASMParametr="7-9-IP93-Dominskyi-1.asm"
set NameOfTheFirstFileAsOBJParametr="7-9-IP93-Dominskyi.obj"
set NameOfTheSecondFileAsOBJParametr="7-9-IP93-Dominskyi-1.obj"
set NameOfTheFileAsEXEParametr="7-9-IP93-Dominskyi.exe"

\masm32\bin\ml /c /coff "%NameOfTheFirstFileAsASMParametr%"
\masm32\bin\ml /c /coff "%NameOfTheSecondFileAsASMParametr%"
	
\masm32\bin\Link.exe /subsystem:windows /out:%NameOfTheFileAsEXEParametr% "%NameOfTheFirstFileAsOBJParametr%" "%NameOfTheSecondFileAsOBJParametr%"

:: if You want window to pause after procedure, then uncomment next row (but You need it, only if You have some problem with code)
:: pause

:: if You want program to run after procedure, then uncomment next row
:: %NameOfTheFileAsEXEParametr%
