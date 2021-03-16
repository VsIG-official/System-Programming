; Processors
.386
.model flat, stdcall
option  CaseMap:None

; Libraries And Macroses
include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
 
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib

; Data Segment
.data	
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 4 спроби:  ", 0
	FailureText DB "Пароль невiрний. Спробуйте ще раз. К-сть спроб, яка залишилася =  ",  0
	
	; Name Of Message Box
	MsgBoxName  DB "3-9-IP93-Dominskyi", 0
	
	;StringFromUser DB 128 dup(128)
	
	; We can write password in two ways:
	Password  DB "Dominskyi"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	
	; Text To Show
	InformationText DB "ПIБ = Домiнський Валентин Олексiйович", 13, 
		 "Дата Народження = 22.02.2002", 13,
		 "Номер Залiковки книжки = 9311", 0
	
; Code Segment
.code
start: ; Generates program start-up code
	InvitePoint:	; Starting Code
		
		invoke MessageBox, 0, offset StartingText, offset MsgBoxName, MB_OK
		
		;jmp InputOfTheUser ; Unconditional jump

	; ; Responsible For Input
	; InputOfTheUser:	
		; mov ah, 0Ah
		; mov dx, offset StringFromUser
		; int 21h

		; mov ax, PasswordCount
		; cmp al, StringFromUser+1 ; Compare
        ; jne WrongPasswordByUser ; Jump Not Equal

		; mov si, offset Password
		; mov di, offset StringFromUser+2 ; low-order 16 bits of 32-bit registers
		; mov cl,PasswordCount ; counter register
		
	; ; Responsible For Checking, if password and input string are the same
	; IsPasswordCorrect:
		; lodsb ; loads 1 byte into the AL register
		
		; mov bh, byte ptr [di]
		
		; cmp al, bh ; Compare 
		; ; ptr = The first operator forces the expression to be treated as having
		; ; the specified type. The second operator specifies a pointer to type
		; je LoopItself ; Jump Equal
 
		; jmp WrongPasswordByUser ; Unconditional jump
        
	; LoopItself:
		; inc di ; incrementing
		; loop IsPasswordCorrect
 
	; ; Responsible For Correct Input
	; CorrectPasswordByUser:
		; ; Clear the screen
		; mov ax, 0600h ; register si 32-bit general-purpose register, used for temporary data storage and memory access
		; mov bh, 7h ; register represent the high-order 8 bits of the corresponding register
		; mov cx, 0000h
		; mov dx, 184fh
		; int 10h

		; ; Set the position of cursor
		; mov ah, 02h
		; mov bh, 00h
		; mov dl, 00h
		; mov dh, 00h
		; int 10h
	
		; mov ah, 09h
		; mov dx, offset InformationText
		; int 21h
	
		; jmp ExitCode ; Unconditional jump
	
	; ; Responsible For Wrong Input
	; WrongPasswordByUser:
		; ; Clear the screen
		; mov ax, 0600h
		; mov bh, 7h
		; mov cx, 0000h
		; mov dx, 184fh
		; int 10h

		; ; Set the position of cursor
		; mov ah, 02h
		; mov bh, 00h
		; mov dl, 00h
		; mov dh, 00h
		; int 10h
	
		; ; display text
		; mov ah, 09h
		; mov dx, offset FailureText
		; int 21h
		
		; mov  ah, 02h ; Display Counter
		; mov  dl, bl
		; add  dl, "0"   ; Integer to single-digit ASCII character
		; int  21h
		
		; mov dl, 0ah ; New Line
		; int 21h
		
		; ; counting tries
		; add bx, -01h ; decrementing
		; cmp bx, -01h ; negative possible tries
		; je ExitCode ; Jump Equal
		
		; jmp InputOfTheUser ; Unconditional jump
		
	; Responsible For Exit
	ExitCode:
		invoke ExitProcess, 0
end start
