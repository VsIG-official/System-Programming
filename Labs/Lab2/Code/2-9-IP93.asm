; Processors
.model TINY

.data?

; Data Segment
.data	
	StartingText DB "����i�� ��஫�. �� ���� 3 �஡�: $", 0
	Success DB "��஫� �i୨�. ������� ���i: $", 0
	Failure DB "��஫� ���i୨�. $", 0
	Password  DB "123", 0 
	
	LengthOfThePassword DB 3, 0
	
	; Text To Show
	TextToShow DB "�I� - ���i��쪨� �����⨭ �����i�����", 13, 
		"��� ��த����� = 22.02.2002", 10,
		"����� ���i����� ������ = 9311", 0
	
	
	
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
	