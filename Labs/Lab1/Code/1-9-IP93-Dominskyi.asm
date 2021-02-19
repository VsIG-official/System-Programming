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
	MsgBoxName  DB "Lab1-9-IP-93-Dominskyi", 0 
	
		; Symbols
	Symbols DB "22022002", 0
	
	; Text Of Message Box
	MsgBoxText DB "Symbols - '%s'", 13, 
		"A plus = %x", 13,  "A minus = %x", 13,
        "B plus = %x", 13, "B minus = %x", 13,
		"C plus = %x", 13, "C minus = %x", 13, 
		"D plus = %x", 13,  "D minus = %x", 13,
		"E plus = %x%x", 13, "E minus = %x%x", 13,
		"F plus = %x%x%x", 13,"F minus = %x%x%x", 0
	
	BufferForText DB 128 DUP(?)
	
	; A Byte Numbers
	APlusByte DB +22
	AMinusByte DB -22
	
	; A Word Numbers
	APlusWord DW +22
	AMinusWord DW -22
	
	; A Shortlnt Numbers
	APlusShortlnt DD +22
	AMinusShortlnt DD -22
	
	; A Longlnt Numbers
	APlusLonglnt DQ +22
	AMinusLonglnt DQ -22
	
	; B Word Numbers
	BPlusWord DW +2202
	BMinusWord DW -2202
	
	; B Shortlnt Numbers
	BPlusShortlnt DD +2202
	BMinusShortlnt DD -2202
	
	; B Longlnt Numbers
	BPlusLonglnt DQ +2202
	BMinusLonglnt DQ -2202
	
	; C Shortlnt Numbers
	CPlusShortlnt DD +22022002
	CMinusShortlnt DD -22022002
	
	; C Longlnt Numbers
	CPlusLonglnt DQ +22022002
	CMinusLonglnt DQ -22022002
	
	; D Single (Float) Numbers
	DPlusSingle DD +0.002
	DMinusSingle DD -0.002
	
	; E Double Numbers
	EPlusDouble DQ +0.236
	EMinusDouble DQ -0.236
	
	; F Extended (Long Double) Numbers
	FPlusExtended DT +2365.16
	FMinusExtended DT -2365.16
	
; Code Segment
.code
	; Enter point
	Main:
		    invoke wsprintf, addr BufferForText, addr MsgBoxText, 
			addr Symbols,
            APlusShortlnt, AMinusShortlnt,
            BPlusShortlnt, BMinusShortlnt,
			CPlusShortlnt, CMinusShortlnt,
			DPlusSingle, DMinusSingle,
			EPlusDouble, EMinusDouble,
			FPlusExtended, FMinusExtended
	
		invoke MessageBox, 0, addr BufferForText, addr MsgBoxName, MB_OK
		invoke ExitProcess, 0
		; End of a program
	end Main
