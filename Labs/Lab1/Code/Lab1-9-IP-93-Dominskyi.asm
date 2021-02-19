; Processors
.386
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
	MsgBoxText1 db "Symbols - '%s'", 13, 
		"A plus (Byte) = %X", 13,  "A minus (Byte) = %X", 13,
		"A plus (Word) = %x", 13,  "A minus (Word) = %X", 13,
		"A plus (Shortlnt) = %X", 13,  "A minus (Shortlnt) = %X", 13,
        "B plus (Word) = %X", 13, "B minus (Word) = %X", 13,

	MsgBoxText2 db "B plus (Shortlnt) = %X", 13, "B minus (Shortlnt) = %X", 13,
        "C plus (Shortlnt) = %X", 13, "C minus (Shortlnt) = %X", 13, 
        "D plus (Single (Float)) = %X", 13,  "D minus (Single (Float)) = %X", 13,
        "E plus (Double) = %X%X", 13, "E minus (Double) = %X%X", 13,
        "F plus (Extended (Long Double)) = %X%X", 13,
		"F minus (Extended (Long Double)) = %X%X", 0
	
	BufferForText db 128 dup(?)
	
	; Symbols
	Symbols db "22022002"
	
	; A Byte Numbers
	APlusByte db +22
	AMinusByte db -22
	
	; A Word Numbers
	APlusWord dw +22
	AMinusWord dw -22
	
	; A Shortlnt Numbers
	APlusShortlnt dd +22
	AMinusShortlnt dd -22
	
	; B Word Numbers
	BPlusWord dw +2202
	BMinusWord dw -2202
	
	; B Shortlnt Numbers
	BPlusShortlnt dd +2202
	BMinusShortlnt dd -2202
	
	; C Shortlnt Numbers
	CPlusShortlnt dd +22022002
	CMinusShortlnt dd -22022002
	
	; D Single (Float) Numbers
	DPlusSingle dd +0.002
	DMinusSingle dd -0.002
	
	; E Double Numbers
	EPlusDouble dq +0.236
	EMinusDouble dq -0.236
	
	; F Extended (Long Double) Numbers
	FPlusExtended dt +2365.16
	FMinusExtended dt -2365.16
	
; Code Segment
.code
	; Enter point
	Main:
		    invoke wsprintf, addr BufferForText, addr MsgBoxText1, 
			addr Symbols,
            APlusByte, AMinusByte,
			APlusWord, AMinusWord,
			APlusShortlnt, AMinusShortlnt,
            BPlusWord, BMinusWord
			
			invoke MessageBoxA, NULL, addr BufferForText, addr MsgBoxName, MB_OK
			
			invoke wsprintf, addr BufferForText, addr MsgBoxText2, 
			addr BPlusShortlnt, BMinusShortlnt,
			CPlusShortlnt, CMinusShortlnt,
			DPlusSingle, DMinusSingle,
			EPlusDouble, EMinusDouble,
			FPlusExtended, FMinusExtended
	
		invoke MessageBoxA, NULL, addr BufferForText, addr MsgBoxName, MB_OK
		invoke ExitProcess, 0
		; End of a program
	end Main
