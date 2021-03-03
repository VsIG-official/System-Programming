; Processors
.model TINY

.data?

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
	
	; Enter point
	Main:	
		mov ah, 00h
		mov al, 2
		int 10h
	
		mov dx, offset StartingText
		mov ah, 9h
		int 21h
		
		mov ah, 8h
		int 21h
	
		; For exiting program We can use this code or...
		;mov ah, 4Ch
		;mov al, 00h
		;int 21h
		
		; ... this one
		.exit
		; End of a program
	end Main
	