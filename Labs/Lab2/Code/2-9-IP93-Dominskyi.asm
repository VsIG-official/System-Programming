; Processors
.386
.model TINY

.data?
	BufferForText DB 256 DUP(?)
	
; Data Segment
.data
	; Name Of Message Box
	MsgBoxName  DB "2-9-IP93-Dominskyi", 0 
	
	PIB  DB "Домінський Валентин Олексійович", 0 
	DateOfBirth  DB "22.02.2002", 0 
	Zalikovka  DB "9311", 0 
	
	PassWord  DB "Lab2", 0 
	
	; Text Of Message Box
	Form DB "ПІБ - %s", 10, 
		"Дата народження = %d", 10,  "Номер залікової книжки = %d", 0
	

	
; Code Segment
.code
	; Enter point
	Main:
			invoke wsprintf, addr BufferForText, addr Form, 
			addr PIB,
            DateOfBirth, Zalikovka
	
		mov dx, offset BufferForText
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
