.486
.model flat, stdcall
option  CaseMap:None

include/masm32/include/windows.inc
include/masm32/include/kernel32.inc
include/masm32/include/user32.inc
includelib/masm32/lib/kernel32.lib
includelib/masm32/lib/user32.lib

.data
	MsgBoxName  db "Some window with numbers", 0 
	MsgBoxText db 
	MsgBoxTextPosA    db "A Positive = %s", 0
	MsgBoxTextNegA    db "A Negative = %s", 0
	
	APositiveByte db +22, 0
	ANegativeByte db -22, 0
	
	APositiveByteBuffer db 64 DUP(?)
	ANegativeByteBuffer db 64 DUP(?)
.code

	Main:
		invoke wsprintf, addr APositiveByteBuffer, addr MsgBoxTextPosA, addr APositiveByte

		invoke wsprintf, addr ANegativeByteBuffer, addr MsgBoxTextNegA, addr ANegativeByte
	
		invoke MessageBoxA, NULL, addr MsgBoxTextPosA, addr MsgBoxName, MB_OK
		invoke ExitProcess, 0
	end Main
