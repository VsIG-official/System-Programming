; Processors
.386
.model flat, stdcall
option  CaseMap:None

; Libraries And Macroses
include /masm32/include/masm32rt.inc

.data?
	BufferForText DB 256 DUP(?)
	
; Data Segment
.data
	; Name Of Message Box
	MsgBoxName  DB "2-9-IP93-Dominskyi", 0 
	
	PIB  DB "��������� �������� ����������", 0 
	DateOfBirth  DB "22.02.2002", 0 
	Zalikovka  DB "9311", 0 
	
	PassWord  DB "Lab2", 0 
	
	; Text Of Message Box
	Form DB "ϲ� - %s", 10, 
		"���� ���������� = %d", 10,  "����� ������� ������ = %d", 0
	

	
; Code Segment
.code
	; Enter point
	Main:
			invoke wsprintf, addr BufferForText, addr Form, 
			addr PIB,
            DateOfBirth, Zalikovka
	
		invoke MessageBox, 0, offset BufferForText, offset MsgBoxName, MB_OK
		invoke ExitProcess, 0
		; End of a program
	end Main
