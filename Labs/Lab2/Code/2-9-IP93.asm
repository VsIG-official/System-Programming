; Processors
.model tiny
.386

.data?

; Data Segment
.data	
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 3 спроби: $"
	FailureText DB "Пароль невiрний. Спробуйте ще раз: $"
	
	StringFromUser2 db 128 dup(128)
	
	; We can write password in two ways:
	Password  DB '123'
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	;MaxLengthOfUsersString DB 128
	
	; Text To Show
	InformationText DB "ПIБ = Домiнський Валентин Олексiйович", 10, 
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
		
		jmp InputOfTheUser ;Unconditional jump

	; Responsible For Input
	InputOfTheUser:
		mov ah,0Ah
		mov dx, offset StringFromUser2
		int 21h

		mov ax, PasswordCount
		cmp al, StringFromUser2+1
        jne WrongPasswordByUser

		mov si, offset Password
		mov di, offset StringFromUser2+2
		mov cl,PasswordCount
		
	IsPasswordCorrect:
		lodsb
		cmp al, byte ptr [di]
		je LoopItself
 
		jmp WrongPasswordByUser ; Unconditional jump
        
	LoopItself:
		inc di
		loop IsPasswordCorrect
 
	; Responsible For Correct Input
	CorrectPasswordByUser:
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
	
		mov ah,09h
		mov dx, offset InformationText
		int 21h
	
		jmp ExitCode ; Unconditional jump
	
	; Responsible For Wrong Input
	WrongPasswordByUser:
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
	
		mov ah,09h
		mov dx, offset FailureText
		int 21h
		
		jmp InputOfTheUser ; Unconditional jump
		
	; Responsible For Exit
	ExitCode:
		; For exiting program We can use this code...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... or this one
		.exit
end