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
	MsgBoxText db "Symbols - '%s'", 13,
           "A plus = %x", 13, 
           "A minus, = %x", 13,
           "B plus = %x", 13,
           "B minus = %x", 13,
           "C plus = %x", 13,
           "C minus = %x", 13, 
           "D plus = %x", 13, 
           "D minus = %x", 13,
           "E plus = %x%x", 13,
           "E minus = %x%x", 13,
           "F plus = %x%x%x", 13,
           "F minus = %x%x%x", 0
	
	APlusByte db +22, 0
	AMinusByte db -22, 0
	
.code

	Main:
		invoke wsprintf, addr APositiveByteBuffer, addr MsgBoxTextPosA, addr APositiveByte

		invoke wsprintf, addr ANegativeByteBuffer, addr MsgBoxTextNegA, addr ANegativeByte
	
		invoke MessageBoxA, NULL, addr MsgBoxTextPosA, addr MsgBoxName, MB_OK
		invoke ExitProcess, 0
	end Main
