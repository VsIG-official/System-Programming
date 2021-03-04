; Processors
.model tiny
.386

; Data Segment
.data	
	StartingText DB "����i�� ��஫�. ����।���, � � ��� � ��� 3 �஡�: $", 10
	FailureText DB "��஫� ���i୨�. ��஡�� � ࠧ. �-��� �஡, 猪 ����訫��� =  $", 10
	
	StringFromUser2 DB 128 dup(128)
	
	; We can write password in two ways:
	Password  DB '123'
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	PossibleTries DB " ", 10
	
	; Text To Show
	InformationText DB "�I� = ���i��쪨� �����⨭ �����i�����", 10, 
		"��� ��த����� = 22.02.2002", 10,
		"����� ���i����� ������ = 9311 $", 0
	
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
		mov ah, 9h
		mov dx, offset StartingText
		int 21h
		
		mov  bx, 02 ; counter for tries
		
		jmp InputOfTheUser ; Unconditional jump

	; Responsible For Input
	InputOfTheUser:

	
		mov ah, 0Ah
		mov dx, offset StringFromUser2
		int 21h

		mov ax, PasswordCount
		cmp al, StringFromUser2+1 ; Compare
        jne WrongPasswordByUser ; Jump Not Equal

		mov si, offset Password
		mov di, offset StringFromUser2+2 ; low-order 16 bits of 32-bit registers
		mov cl,PasswordCount ; counter register
		
	; Responsible For Checking, if password and input string are the same
	IsPasswordCorrect:
		lodsb ; loads 1 byte into the AL register
		cmp al, byte ptr [di] ; Compare 
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
	
		; display text
		mov ah, 09h
		mov dx, offset FailureText
		int 21h
		
		mov  ah, 02h
		mov  dl, bl
		add  dl, "0"   ; Integer to single-digit ASCII character
		int  21h
		
		; counting tries
		add bx, -01 ; decrementing
		cmp bx, -01 ; negative possible tries
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