@echo off
    set filename="8-9-IP93-Dominskyi-Dynamic-Entry"
    if exist "%filename%.obj" del "%filename%.obj"
    if exist "%filename%.exe" del "%filename%.exe"

    set libname="8-9-IP93-Dominskyi-Dynamic-Entry-Library"
    if exist "%libname%.dll"  del "%libname%.dll"
    if exist "%libname%.exp"  del "%libname%.exp"
    if exist "%libname%.obj"  del "%libname%.obj"
    if exist "%libname%.lib"  del "%libname%.lib"

    \masm32\bin\ml /c /coff "%libname%.asm"
    \masm32\bin\Link.exe /OUT:"%libname%.dll" /EXPORT:DoArithmeticOperations /DLL "%libname%.obj"

    \masm32\bin\ml /c /coff "%filename%.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:console "%filename%.obj"
    if errorlevel 1 goto errlink
    dir "%filename%.*"
    goto TheEnd

  :errlink
    echo _
    echo Link error
    goto TheEnd

  :errasm
    echo _
    echo Assembly Error
    goto TheEnd
    
  :TheEnd

%filename%.exe
pause
