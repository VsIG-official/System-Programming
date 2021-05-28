@echo off
    set filename="8-9-IP93-Dominskyi-Static-WithoutEntry"
    set libname="8-9-IP93-Dominskyi-Static-WithoutEntry-Library"

    \masm32\bin\ml /c /coff "%libname%.asm"
    \masm32\bin\Link.exe /OUT:"%libname%.dll" /DEF:%filename%.def /NOENTRY /DLL "%libname%.obj"

    \masm32\bin\ml /c /coff "%filename%.asm"

    \masm32\bin\Link.exe /SUBSYSTEM:console "%filename%.obj"

%filename%.exe
pause
