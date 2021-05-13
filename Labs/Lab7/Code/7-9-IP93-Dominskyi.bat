@echo off
    set filename="7-9-IP93-Dominskyi"
    set exec_filename="7-9-IP93-Dominskyi.exe"

    \masm32\bin\ml /c /coff "%filename%.asm"
    \masm32\bin\ml /c /coff "%filename%-1.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%exec_filename% "%filename%.obj" "%filename%-1.obj"
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
