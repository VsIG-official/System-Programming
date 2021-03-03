; Processors
.model TINY

.data?

; Data Segment
.data	
	StartingText DB "Введiть пароль. Ви маєте 3 спроби: $", 0
	Success DB "Пароль вiрний. Виводжу данi: $", 0
	Failure DB "Пароль невiрний. $", 0
	Password  DB "123", 0 
	
	LengthOfThePassword DB 3, 0
	
	; Text To Show
	TextToShow DB "ПIБ - Домiнський Валентин Олексiйович", 13, 
		"Дата Народження = 22.02.2002", 10,
		"Номер Залiковки книжки = 9311", 0
	
	
	
; Code Segment
.code
	; Enter point
	Main:	
		mov dx, offset TextToShow
		mov ah, 9h
		int 21h
		
		mov ah, 8h
		int 21h
	
		; For exiting program We can use this code or...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... this code
		.exit
		; End of a program
	end Main
	