; Processors
.model tiny
.386

; Data Segment
.data	
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 4 спроби: $", 10
	FailureText DB "Пароль невiрний. Спробуйте ще раз. К-сть спроб, яка залишилася =  $",  10
	
	StringFromUser DB 128 dup(128)
	
	; We can write password in two ways:
	Password  DB "fMOKLQI[K"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	XORKey DB 22h
	
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
		mov cx, 0000h
		mov dx, 184fh
		int 10h

		; Set the position of cursor
		mov ah, 02h
		mov bh, 00h
		mov dl, 00h
		mov dh, 00h
		int 10h

		; Display The Text
		mov ah, 9h
		mov dx, offset StartingText
		int 21h
		
		mov  bx, 03h ; counter for tries
		
		jmp InputOfTheUser ; Unconditional jump

	; Responsible For Input
	InputOfTheUser:	
		mov ah, 0Ah
		mov dx, offset StringFromUser
		int 21h
		
		mov ax, PasswordCount

		cmp al, StringFromUser+1 ; Compare
		
        jne WrongPasswordByUser ; Jump Not Equal

		mov si, offset Password

		mov di, offset StringFromUser+2 ; low-order 16 bits of 32-bit registers

		mov cl,PasswordCount ; counter register
		
	; Responsible For Checking, if password and input string are the same
	IsPasswordCorrect:
		lodsb ; loads 1 byte into the AL register

		mov bh, byte ptr [di]
		xor bh, XORKey
		
		cmp al, bh; Compare 

		; ptr = The first operator forces the expression to be treated as having
		; the specified type. The second operator specifies a pointer to type
		je LoopItself ; Jump Equal
 
		jmp WrongPasswordByUser ; Unconditional jump
        
	LoopItself:

		inc di ; incrementing
		loop IsPasswordCorrect
 
	; Responsible For Correct Input
	CorrectPasswordByUser:
		; Clear the screen
		mov ax, 0600h ; register si 32-bit general-purpose register, used for temporary data storage and memory access
		mov bh, 7h ; register represent the high-order 8 bits of the corresponding register
		mov cx, 0000h
		mov dx, 184fh
		int 10h

		; Set the position of cursor
		mov ah, 02h
		mov bh, 00h
		mov dl, 00h
		mov dh, 00h
		int 10h
	
		mov ah, 09h
		mov dx, offset InformationText
		int 21h
	
		jmp ExitCode ; Unconditional jump
	
	; Responsible For Wrong Input
	WrongPasswordByUser:
		; Clear the screen
		mov ax, 0600h
		mov bh, 7h
		mov cx, 0000h
		mov dx, 184fh
		int 10h

		; Set the position of cursor
		mov ah, 02h
		mov bh, 00h
		mov dl, 00h
		mov dh, 00h
		int 10h
	
		; display text
		mov ah, 09h
		mov dx, offset FailureText
		int 21h
		
		mov  ah, 02h ; Display Counter
		mov  dl, bl
		add  dl, "0"   ; Integer to single-digit ASCII character
		int  21h
		
		mov dl, 0ah ; New Line
		int 21h
		
		; counting tries
		add bx, -01h ; decrementing
		cmp bx, -01h ; negative possible tries
		je ExitCode ; Jump Equal
		
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