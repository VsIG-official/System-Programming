; Processors
.386
.model TINY

.data?
	;BufferForText DB 256 DUP(?)
	
; Data Segment
.data	
	StartingText DB "������ ������:", 0
	Success DB "������ �����. ������� ���", 0
	Failure DB "������ �������. ��������� �� ���", 0
	Password  DB "��2", 0 
	
	; Text To Show
	TextToShow DB "ϲ� - ��������� �������� ����������", 13, 
		"���� ���������� = 22.02.2002", 10,
		"����� ������� ������ = 9311", 0
	

	
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
