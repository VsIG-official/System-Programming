; Processors
.386
.model flat, stdcall
option CaseMap:None

; Libraries And Macroses
includelib /masm32/lib/Fpu.lib
include /masm32/include/Fpu.inc
include /masm32/include/masm32rt.inc

.data?
	; Start = (2 * c - d / 23) / (ln(b - a / 4))
	
	;; Text, that We will show

	
	; Buffers for final float numbers
	BufferFloatA DB 32 DUP(?)
	BufferFloatB DB 32 DUP(?)
	BufferFloatC DB 32 DUP(?)
	BufferFloatD DB 32 DUP(?)
	BufferFloatFinal DB 32 DUP(?)
	
	; Buffers for intermediate results
	
	; First Step
	; Value of 2 * c
	BufferTwoMulC DB 32 DUP(?)
	; Value of d / 23
	BufferDdivTwenThree DB 32 DUP(?)
	; Value of a - 4
	BufferAdivFour DB 32 DUP(?)

	; Second Step
	; Value of 2 * c - d / 23
	BufferFirstPart DB 32 DUP(?)
	; Value of b - a / 4
	BufferBsubPartOfLn DB 32 DUP(?)
	
	; Third Step
	; Value of ln(b - a / 4)
	BufferSecondPart DB 32 DUP(?)

; Data Segment
.data
	ZeroDivisionText DB "Даний вираз має ділення на нуль. Перевірте Свої значення", 13, 0
	NegativeOrZeroLnText DB "Даний вираз має негативне число або нуль в (ln). Перевірте Свої значення", 13, 0

	; Name Of Message Box
	MsgBoxName  DB "8-9-IP93-Dominskyi", 0

	firstConstant dq 2.0
	secondConstant dq 23.0
	thirdConstant dq 4.0
	
	zero dq 0.0
	negativeZero dq -0.0
	
	;; global variables for interpolating for main window
	;; (I will put some int into them and show in main window)
	;; mostly used for negative nums
	floatFinal DQ 0

	; form, which I will be filling with variables
	equationVariables DB "For a = (%s), b = (%s), c = (%s) and d = (%s) We have (2 * (%s) - (%s) / 23) / (ln((%s) - (%s) / 4)) = ((%s) - (%s)) / (ln((%s) - (%s))) = (%s) / (ln((%s))) = (%s) / (%s) = (%s)", 13, 0

; Code Segment
.code
	; procedure #1 for calculating
	DoArithmeticOperations proc aFloat: ptr qword, bFloat: ptr qword, cFloat: ptr qword, dFloat: ptr qword, TempPlaceForText: dword
		; My equation = (2 * c - d / 23) / (ln(b - a / 4))
		
		;; values for equation
		mov eax, aFloat
		invoke FloatToStr2, [eax], addr BufferFloatA
		mov eax, bFloat
		invoke FloatToStr2, [eax], addr BufferFloatB
		mov eax, cFloat
		invoke FloatToStr2, [eax], addr BufferFloatC
		mov eax, dFloat
		invoke FloatToStr2, [eax], addr BufferFloatD
	
		finit ; FPU Initialization
	
		; 2 * c
	
		; move 2 into st(0)
		fld firstConstant
		; move c into st(0) and 2 into st(1)
		mov eax, cFloat
		fld qword ptr [eax]
		; multiply 2 by c and move result into st(0)
		fmul

		; convert float to text with 18 digits after "," into buffer
		invoke FpuFLtoA, 0, 18, addr BufferTwoMulC, SRC1_FPU or SRC2_DIMM
	
		; d / 23
	
		; move d into st(0) and 2*c into st(1)
		mov eax, dFloat
		fld qword ptr [eax]
		; move 23 into st(0), d into st(1) and 2*c into st(2)
		fld secondConstant

		; divide d by 23 and move result into st(0), 2*c to st(1)
		fdiv
	
		; convert float to text with 18 digits after "," into buffer
		invoke FpuFLtoA, 0, 18, addr BufferDdivTwenThree, SRC1_FPU or SRC2_DIMM
	
		; 2 * c - d / 23
	
		; subtract d/23 from 2*c, move result into st(0)
		fsub
	
		; convert float to text with 18 digits after "," into buffer
		invoke FpuFLtoA, 0, 18, addr BufferFirstPart, SRC1_FPU or SRC2_DIMM
	
		; move ln(2) into st(0) and 2*c-d/23 into st(1)
		fldln2
	
		; move b into st(0), ln(2) into st(1) and 2*c-d/23 into st(2)
		mov eax, bFloat
		fld qword ptr [eax]
	
		; move a into st(0), b into st(1), ln(2) into st(2) 2*c-d/23 into st(3)
		mov eax, aFloat
		fld qword ptr [eax]
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
	
		; compare, if number is zero for dividing
	
		; compares the contents of st (0) to the source
		fcom zero
		; saves the current value of the SR register to the receiver
		fstsw ax
		; loads flags
		sahf
		; jump, if equal to zero.zero
		je NumberIsZero
	
		; compares the contents of st (0) to the source
		fcom negativeZero
		; saves the current value of the SR register to the receiver
		fstsw ax
		; loads flags
		sahf
		; jump, if equal to negative zero.zero
		je NumberIsZero
	
		; compares the contents of st (0) to zero
		ftst
		; saves the current value of the SR register to the receiver
		fstsw ax
		; loads flags
		sahf
		; jump, if equal to zero
		je NumberIsZero
	
		; divides 2*c-d/23 by ln(b-a/4) and move it into st(0)
		fdiv
	
		; (2 * c - d / 23) / (ln( b - a / 4))
	
		; saves st(0) into variable
		fstp floatFinal

		;; value for final result
		invoke FloatToStr2, floatFinal, addr BufferFloatFinal
	
		;; parsing variables into TempPlaceForText
		invoke wsprintf, TempPlaceForText, addr equationVariables, 
		addr BufferFloatA, addr BufferFloatB, addr BufferFloatC, addr BufferFloatD,
		addr BufferFloatC, addr BufferFloatD, addr BufferFloatB, addr BufferFloatA,
		addr BufferTwoMulC, addr BufferDdivTwenThree, addr BufferFloatB,
		addr BufferAdivFour, addr BufferFirstPart, addr BufferBsubPartOfLn,
		addr BufferFirstPart, addr BufferSecondPart, addr BufferFloatFinal
	
		jmp EndThisMacros
	
		NumberIsZero:
		;; parsing variables into TempPlaceForText
		invoke wsprintf, TempPlaceForText, addr ZeroDivisionText
		jmp EndThisMacros

		NumberIsLessOrZero:
		;; parsing variables into TempPlaceForText
		invoke wsprintf, TempPlaceForText, addr NegativeOrZeroLnText
		jmp EndThisMacros

		EndThisMacros:
		;INVOKE MessageBox, 0, ADDR TempPlaceForText, ADDR MsgBoxName, MB_OK
		ret
DoArithmeticOperations endp
end