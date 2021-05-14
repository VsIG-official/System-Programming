; Processors
.386
.model flat, stdcall
option CaseMap:None

; Libraries And Macroses
includelib /masm32/lib/Fpu.lib
include /masm32/include/Fpu.inc
include /masm32/include/masm32rt.inc

.data
	; nums for comparing
	zero DQ 0.0
	negativeZero DQ -0.0
	
	; third const
	thirdConstant DQ 4.0
	
	; value for final res
	floatFinal DQ 0.0
	
.code
extern FloatsB: QWORD, FloatsA: QWORD, BufferAdivFour: BYTE, BufferBsubPartOfLn: BYTE, BufferSecondPart: BYTE, TempPlaceForText: BYTE, BufferFloatFinal: BYTE, NumberIsLessOrZeroFromFirstFile: DWORD, NumberIsZeroFromFirstFile: DWORD
public SecondPartProc
SecondPartProc proc

	; move ln(2) into st(0) 
	fldln2
	
	; move b into st(0), ln(2) into st(1)
	fld FloatsB[edi*8]
	
	; move a into st(0), b into st(1), ln(2) into st(2)
	fld FloatsA[edi*8]
	
	; move 4 into st(0), a into st(1), b into st(2), ln(2) into st(3)
	fld thirdConstant
	
	; divide a by 4 and move it into st(0), b into st(1), ln(2) into st(2)
	fdiv
	
	; convert float to text with 18 digits after "," into buffer
	invoke FpuFLtoA, 0, 18, addr BufferAdivFour, SRC1_FPU or SRC2_DIMM

	; subtract a/4 from b, move result into st(0), ln(2) into st(1)
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
	jbe NumberIsLessOrZeroFromProc
	
	; find ln(b - a/4) and move it into st(0), 2*c-d/23 into st(1)
	fyl2x
	
	; convert float to text with 18 digits after "," into buffer
	invoke FpuFLtoA, 0, 18, addr BufferSecondPart, SRC1_FPU or SRC2_DIMM
	
	; compare, if number is zero for dividing

	; compares the contents of st (0) to the source
	fcom zero
	; saves the current value of the SR register to the receiver
	fstsw ax
	; loads flags
	sahf
	; jump, if equal to zero.zero
	je NumberIsZeroFromProc

	; compares the contents of st (0) to the source
	fcom negativeZero
	; saves the current value of the SR register to the receiver
	fstsw ax
	; loads flags
	sahf
	; jump, if equal to negative zero.zero
	je NumberIsZeroFromProc

	; compares the contents of st (0) to zero
	ftst
	; saves the current value of the SR register to the receiver
	fstsw ax
	; loads flags
	sahf
	; jump, if equal to zero
	je NumberIsZeroFromProc
	
	; divides 2*c-d/23 by ln(b-a/4) and move it into st(0)
	fdiv
	
	; (2 * c - d / 23) / (ln( b - a / 4))
	
	; saves st(0) into variable
	fstp floatFinal

	;; value for final result
	invoke FloatToStr2, floatFinal, addr BufferFloatFinal

	jmp EndThisMacrosThirdProc
	
	; this 
	NumberIsLessOrZeroFromProc:
	
	pop edx
	
	push NumberIsLessOrZeroFromFirstFile
	
	mov edx, 0
	
	jmp EndThisMacrosThirdProc
	
	NumberIsZeroFromProc:
	
	pop edx
	
	push NumberIsZeroFromFirstFile
	
	mov edx, 0

	EndThisMacrosThirdProc:

    ret
SecondPartProc endp
end
