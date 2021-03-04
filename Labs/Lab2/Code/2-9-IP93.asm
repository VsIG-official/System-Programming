; Processors
.model tiny

.data?
	StringFromUser DB 128 DUP (?)

; Data Segment
.data	
	StartingText DB "Введiть пароль. Ви маєте 3 спроби: $"
	SuccessText DB "Пароль вiрний. Виводжу данi: $"
	FailureText DB "Пароль невiрний. $"
	
	; We can write password in two ways:
	Password  DB "123"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount DB 3
	MaxLengthOfUsersString DB 128
	
	; Text To Show
	InformationText DB "ПIБ - Домiнський Валентин Олексiйович", 10, 
		"Дата Народження = 22.02.2002", 10,
		"Номер Залiковки книжки = 9311 $", 0
	
; Code Segment
.code
	org	100h ; this is offset for com programs:
	; It defines where the machine code (translated 
	; assembly program) is to place in memory.
	; As for org 100h this deals with 80x86 COM 
	; program format (COMMAND) which consist 
	; of only one segment of max. 64k bytes. 
	; 100h says that the machine code starts from 
	; address (offset) 100h in this segment.
	; For com format the offset is always 100h
	
	.startup ; Generates program start-up code
	InvitePoint:	; Starting Code
		; Clear the screen
		mov ax, 0600h
		mov bh, 7h
		mov cx, 0000
		mov dx, 184fh
		int 10h

		; Set the position of cursor
		mov ah, 02
		mov bh, 00
		mov dl, 00
		mov dh, 00
		int 10h

		; Display The Text
		mov dx, offset StartingText
		mov ah, 9h
		int 21h

	; Responsible For Input
	InputOfTheUser:
		mov ah, 03Fh ; Function to read the file
		;mov bx, 0
		mov cx, 128 ; MaxLengthOfUsersString
		lea 	dx, offset StringFromUser
		int 	21h
	
	; Responsible For Wrong Input
	WrongPasswordByUser:
		mov dx,offset FailureText
		mov ah,09h
		int 21h
		
	; Responsible For Correct Input
	CorrectPasswordByUser:
		mov dx,offset SuccessText
		mov ah,09h
		int 21h
		
	; Responsible For Output
	OutputInfo:
		mov dx,offset InformationText
		mov ah,09h
		int 21h
		
	; Responsible For Exit
	ExitCode:
		; For exiting program We can use this code or...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... this one
		.exit
end