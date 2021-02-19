; Processors
.486
.model flat, stdcall
option  CaseMap:None

; Libraries And Macroses
include/masm32/include/windows.inc
include/masm32/include/kernel32.inc
include/masm32/include/user32.inc
includelib/masm32/lib/kernel32.lib
includelib/masm32/lib/user32.lib

; Data Segment
.data
	; Name Of Message Box
	MsgBoxName  db "Lab1-9-IP-93-Dominskyi", 0 
	
	; Text Of Message Box
	MsgBoxText db "Symbols - '%S'", 13, 
		"A plus = %X", 13,  "A minus, = %X", 13,
        "B plus = %X", 13, "B minus = %X", 13,
        "C plus = %X", 13, "C minus = %X", 13, 
        "D plus = %X", 13,  "D minus = %X", 13,
        "E plus = %X%X", 13, "E minus = %X%X", 13,
        "F plus = %X%X", 13, "F minus = %X%X", 0
		   
	BufferForText db 64 dup(?)
	
	; A Byte Numbers
	APlusByte db +22, 0
	AMinusByte db -22, 0
	
	; A Word Numbers
	APlusWord dw +22, 0
	AMinusWord dw -22, 0
	
	; A Shortlnt Numbers
	APlusWord dd +22, 0
	AMinusWord dd -22, 0
	
	; B Word Numbers
	BPlusWord dw +2202, 0
	BMinusWord dw -2202, 0
	
	; B Shortlnt Numbers
	BPlusWord dd +2202, 0
	BMinusWord dd -2202, 0
	
	; C Shortlnt Numbers
	CPlusWord dd +22022002, 0
	CMinusWord dd -22022002, 0
	
	; D Single (Float) Numbers
	DPlusSingle dd +0.002, 0
	DMinusSingle dd -0.002, 0
	
	; E Double Numbers
	EPlusSingle dd +0.236, 0
	EMinusSingle dd -0.236, 0
	
	; F Extended (Long Double) Numbers
	FPlusSingle dd +2365.16, 0
	FMinusSingle dd -2365.16, 0
	
; Code Segment
.code
	; Enter point
	Main:
		invoke wsprintf, addr APositiveByteBuffer, addr MsgBoxTextPosA, addr APositiveByte

		invoke wsprintf, addr ANegativeByteBuffer, addr MsgBoxTextNegA, addr ANegativeByte
	
		invoke MessageBoxA, NULL, addr MsgBoxText, addr MsgBoxName, MB_OK
		invoke ExitProcess, 0
		; End of a program
	end Main
