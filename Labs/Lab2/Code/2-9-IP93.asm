; Processors
.model tiny

.data?
USR_INPUT DB 32 DUP (?)

; Data Segment
.data	
	StartingText DB "����i�� ��஫�. �� ���� 3 �஡�: $", 0
	SuccessText DB "��஫� �i୨�. ������� ���i: $", 0
	FailureText DB "��஫� ���i୨�. $", 0
	
	; We can write password in two ways:
	Password  DB "123", 0 
	
	; And another one is:
	; Password  DB 31h 32h 33h, 0
	
	PasswordCount DB 3, 0
	
	; Text To Show
	InformationText DB "�I� - ���i��쪨� �����⨭ �����i�����", 10, 
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
	InvitePoint:	
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

	InputOfTheUser:
		    mov ah, 03Fh ; Function to read the file
			;mov bx, 0
			mov cx, 32
			lea 	dx, offset USR_INPUT
			int 	21h
	
	ExitCode:
		; For exiting program We can use this code or...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... this one
		
		.exit
end