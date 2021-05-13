; Processors
.386
.model flat, stdcall
option CaseMap:None

; Libraries And Macroses
includelib /masm32/lib/Fpu.lib
include /masm32/include/Fpu.inc
include /masm32/include/masm32rt.inc

.data
.code
extern FloatsB: qword, FloatsA: qword, BufferLowerPart: byte, thirdConstant: qword, BufferAdivFour: byte, BufferBsubPartOfLn: byte, zero: qword, BufferSecondPart: byte, TempPlaceForText: byte, NegativeOrZeroLnText: byte
public SecondPartProc
SecondPartProc proc

	; move ln(2) into st(0) and 2*c-d/23 into st(1)
	fldln2
	
	; move b into st(0), ln(2) into st(1) and 2*c-d/23 into st(2)
	fld FloatsB[edi]
	
	; move a into st(0), b into st(1), ln(2) into st(2) 2*c-d/23 into st(3)
	fld FloatsA[edi]
	; move 4 into st(0), a into st(1), b into st(2), ln(2) into st(3) and 2*c-d/23 into st(4)
	fld thirdConstant
	
	; divide a by 4 and move it into st(0), b into st(1), ln(2) into st(2) and 2*c-d/23 into st(3)
	fdiv
	
	; convert float to text with 18 digits after "," into buffer
	invoke FpuFLtoA, 0, 18, addr BufferAdivFour, SRC1_FPU or SRC2_DIMM

	; subtract a/4 from b, move result into st(0), ln(2) into st(1) and 2*c-d/23 into st(2)
	fsub
	
	; convert float to text with 18 digits after "," into buffer
	invoke FpuFLtoA, 0, 18, addr BufferBsubPartOfLn, SRC1_FPU or SRC2_DIMM
	
	; compare, if number is zero or less for ln
	
	; compares the contents of st (0) to the source
	fcom zero
	; saves the current value of the SR register to the receiver
	fstsw ax
	; loads flags
	sahf
	; jump, if equal to zero
	je NumberIsLessOrZero
	; jump, if less than zero
	jb NumberIsLessOrZero
	
	; find ln(b - a/4) and move it into st(0), 2*c-d/23 into st(1)
	fyl2x
	
	; convert float to text with 18 digits after "," into buffer
	invoke FpuFLtoA, 0, 18, addr BufferSecondPart, SRC1_FPU or SRC2_DIMM
	
	jmp EndThisMacrosThirdProc

	NumberIsLessOrZero:
		;; parsing variables into TempPlaceForText
		invoke wsprintf, addr TempPlaceForText, addr NegativeOrZeroLnText
		jmp EndThisMacrosThirdProc

	EndThisMacrosThirdProc:

    ret
SecondPartProc endp
end
