; Processors
.386
.model flat, stdcall
option  CaseMap:None

; Libraries And Macroses
include /masm32/include/masm32rt.inc

.data?
	BufferForText DB 64 DUP(?)
	BufferDPlus DB 32 DUP(?)
	BufferDMinus DB 32 DUP(?)
	BufferEPlus DB 32 DUP(?)
	BufferEMinus DB 32 DUP(?)
	BufferFPlus DB 32 DUP(?)
	BufferFMinus DB 32 DUP(?)
	
; Data Segment
.data
	; Name Of Message Box
	MsgBoxName  DB "1-9-IP93-Dominskyi", 0 
	
		; Symbols
	Symbols DB "22022002", 0
	
	; Text Of Message Box
	Form DB "Symbols - '%s'", 10, 
		"A plus = %d", 10,  "A minus = %d", 10,
        "B plus = %d", 10, "B minus = %d", 10,
		"C plus = %d", 10, "C minus = %d", 10,
		"D plus = %s", 10, "D minus = %s", 10, 
		"E plus = %s", 10, "E minus = %s", 10, 
		"F plus = %s", 10, "F minus = %s", 0
	
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
			invoke FloatToString2, DPlusSingle, offset BufferDPlus
			invoke FloatToString2, DMinusSingle, offset BufferDMinus
			invoke FloatToString2, EPlusDouble, offset BufferEPlus
			invoke FloatToString2, EMinusDouble, offset BufferEMinus
			invoke FloatToString2, FPlusExtended, offset BufferFPlus
			invoke FloatToString2, FMinusExtended, offset BufferFMinus
			
			invoke wsprintf, offset BufferForText, offset Form, 
			offset Symbols,
            APlusShortlnt, AMinusShortlnt,
            BPlusShortlnt, BMinusShortlnt,
			CPlusShortlnt, CMinusShortlnt,
			BufferDPlus, BufferDMinus,
			BufferEPlus, BufferEMinus,
			BufferFPlus, BufferFMinus
	
		invoke MessageBox, 0, offset BufferForText, offset MsgBoxName, MB_OK
		invoke ExitProcess, 0
		; End of a program
	end Main
