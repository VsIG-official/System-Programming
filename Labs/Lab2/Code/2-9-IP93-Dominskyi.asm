; Processors
.386
.model TINY

.data?
	;BufferForText DB 256 DUP(?)
	
; Data Segment
.data	
	StartingText DB "Введіть пароль:", 0
	Success DB "Пароль вірний. Показую дані", 0
	Failure DB "Пароль невірний. Спробуйте ще раз", 0
	Password  DB "ЛР2", 0 
	
	; Text To Show
	TextToShow DB "ПІБ - Домінський Валентин Олексійович", 13, 
		"Дата народження = 22.02.2002", 10,
		"Номер залікової книжки = 9311", 0
	

	
; Code Segment
.code
	; Enter point
	Main:	
		mov dx, offset TextToShow
		mov ah, 9h
		int 21h
		
		mov ah, 8h
		int 21h
	
		;invoke MessageBox, 0, offset BufferForText, offset MsgBoxName, MB_OK
		mov ah, 4Ch
		mov al, 00h
		int 21h
		; End of a program
	end Main
