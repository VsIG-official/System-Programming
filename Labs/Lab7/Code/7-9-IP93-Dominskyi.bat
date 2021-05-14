set filename="7-9-IP93-Dominskyi"
set exec_filename="7-9-IP93-Dominskyi.exe"

\masm32\bin\ml /c /coff "%filename%.asm"
\masm32\bin\ml /c /coff "%filename%-1.asm"
	
\masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%exec_filename% "%filename%.obj" "%filename%-1.obj"

pause