; Processors
.386
.model flat, stdcall
option CaseMap:None

WinWarningProto proto :dword,:dword,:dword
WinMainProto proto :dword,:dword,:dword

; Libraries And Macroses
includelib /masm32/lib/Fpu.lib
include /masm32/include/Fpu.inc
include /masm32/include/masm32rt.inc

; Our Macroses
; We place them here, 'cause it won't degrade the readability of the code

; Macros #1 for printing some text
PrintInformationInWindow macro heightPosition, infoToShow
	; for example, this commentary is included into macroexpansion
	;; but this - not
	
	; just pass position of the text on vertical
	; and text, that We want to show
	invoke CreateWindowEx,NULL,
            offset NameOfTheText, offset infoToShow,
            WS_VISIBLE or WS_CHILD or BS_TEXT or SS_CENTER  or BS_VCENTER,
            16, heightPosition, 890, 75,
            hWnd, 7044, hInstance, NULL
endm

; Macros #2 for calculating
DoArithmeticOperations macro aFloat, bFloat, cFloat, dFloat
	; Label for ending macros
	Local EndThisMacros
	; Label for checking, if numerator is zero (for zero division)
	Local NumberIsZero
	; Label for checking, if numerator is zero or less than it (for ln function)
	Local NumberIsLessOrZero
	
	; My equation = (2 * c - d / 23) / (ln(b - a / 4))
	
	finit ; FPU Initialization
	
	fld firstConstant ; st(0) = 2
	fld cFloat		 ; st(0) = c, st(1) = 2
	fmul 			 ; st(0) = st(1) * st(0)

	;fstp TwoMulC
	invoke FpuFLtoA, 0, 7, addr BufferTwoMulC, SRC1_FPU or SRC2_DIMM
	; 2*c
	; ^ works
	
	fld dFloat ; st(0) = d, st(1) = 2*c
	fld secondConstant ; st(0) = 23, st(1) = d, st(2) = 2*c

	fdiv ; st(0) = st(1)/st(0) = d/23, st(1) = 2*c
	
	;fstp DdivTwenThree
	invoke FpuFLtoA, 0, 7, addr BufferDdivTwenThree, SRC1_FPU or SRC2_DIMM
	; d/23
	; ^ work
	
	fsub ; st(0) = st(1) - st(0) = 2*c - d/23
	
	;fstp FirstPart
	invoke FpuFLtoA, 0, 7, addr BufferFirstPart, SRC1_FPU or SRC2_DIMM
	; 2*c-d/23
	; ^ works
	
	fldln2 ; st(0) = ln(2), st(1) = 2*c-d/23
	; st(0) = ln(2), st(1) =  ln(b - a/4), st(2) = 2*c-d/23
	
	fld bFloat ; st(0) = b, st(1) = ln(2), st(2) = 2*c-d/23
	
	fld aFloat ; st(0) = a, st(1) = b, st(2) = ln(2), st(3) = 2*c-d/23
	fld thirdConstant ; st(0) = 4, st(1) = a, st(2) = b, st(3) = ln(2), st(4) = 2*c-d/23
	
	fdiv ; st(0) = st(1)/st(0) = a/4, st(1) = b, st(2) = ln(2), st(3) = 2*c-d/23
	
	;fstp AdivFour
	invoke FpuFLtoA, 0, 7, addr BufferAdivFour, SRC1_FPU or SRC2_DIMM
	; a/4
	; ^ works
	
	fsub ; st(0) = st(1) - st(0) = b - a/4, st(1) = ln(2), st(2) = 2*c-d/23
	
	;fstp BsubPartOfLn
	invoke FpuFLtoA, 0, 7, addr BufferBsubPartOfLn, SRC1_FPU or SRC2_DIMM
	; b-a/4
	; ^ works
	
	; zero or less comparing
	fcom zero
	fstsw ax
	sahf
	je NumberIsLessOrZero
	jb NumberIsLessOrZero
	
	fyl2x ; st(0) = st(1)(st(0)) = ln(b - a/4), st(1) = 2*c-d/23
	
	;fstp SecondPart
	invoke FpuFLtoA, 0, 7, addr BufferSecondPart, SRC1_FPU or SRC2_DIMM
	; ln(b-a/4)
	; ^ works
	
	; zero comparing
	fcom zero
	fstsw ax
	sahf
	je NumberIsZero
	
	fcom negativeZero
	fstsw ax
	sahf
	je NumberIsZero
	
	ftst
	fstsw ax
	sahf
	je NumberIsZero
	
	fdiv ; st(0) = st(1)/st(0) = (2*c-d/23)/(ln(b-a/4))
	
	; (2 * c - d / 23) / (ln( b - a / 4))
	; ^ works
	
	fstp floatFinal

	;; value for final result
	invoke FloatToStr2, floatFinal, addr BufferFloatFinal
	
	;; parsing variables into TempPlaceForText
	invoke wsprintf, addr TempPlaceForText, addr equationVariables, 
	addr BufferFloatA, addr BufferFloatB, addr BufferFloatC, addr BufferFloatD,
	addr BufferFloatC, addr BufferFloatD, addr BufferFloatB, addr BufferFloatA,
	addr BufferTwoMulC, addr BufferDdivTwenThree, addr BufferFloatB,
	addr BufferAdivFour, addr BufferFirstPart, addr BufferBsubPartOfLn,
	addr BufferFirstPart, addr BufferSecondPart, addr BufferFloatFinal
	
	jmp EndThisMacros
	
	NumberIsZero:
		;; parsing variables into TempPlaceForText
		invoke wsprintf, addr TempPlaceForText, addr ZeroDivisionText
		jmp EndThisMacros

	NumberIsLessOrZero:
		;; parsing variables into TempPlaceForText
		invoke wsprintf, addr TempPlaceForText, addr NegativeOrZeroLnText
		jmp EndThisMacros
		
	EndThisMacros:
endm

.data?
	hInstance HINSTANCE ? ; Handle of our program
	hWndOfWarnWindow HWND ? ; Handle of our warn window
	hWndOfMainWindow HWND ? ; Handle of our main window
	
	;; Text, that We will show
	TempPlaceForText DB 256 DUP(?)
	
	; Buffers for final float numbers
	BufferFloatA DB 32 DUP(?)
	BufferFloatB DB 32 DUP(?)
	BufferFloatC DB 32 DUP(?)
	BufferFloatD DB 32 DUP(?)
	BufferFloatFinal DB 32 DUP(?)
	
	; Start = (2 * c - d / 23) / (ln(b - a / 4))
	
	; Values for intermediate results
	
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
	StartingText DB "У наступному вікні Ви побачите 5 різних арифметичних виразів", 13, 0
	ZeroDivisionText DB "Даний вираз має ділення на нуль. Перевірте Свої значення", 13, 0
	NegativeOrZeroLnText DB "Даний вираз має негативне число або нуль в (ln). Перевірте Свої значення", 13, 0
	
	; Name Of Message Box
	MsgBoxName  DB "6-9-IP93-Dominskyi", 0

	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our warn window class
	NameOfMainWindows DB "Window with main text", 0 ; the name of our success window class
	
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForOKButton DB "ОК", 0
	
	; My equation = (2 * c - d / 23) / (ln( b - a / 4))
	
	; can't be 1 or 0
	; first way of declaring array
	FloatsA dq 0.3, 4.0, 6.0, -2.0, 10.0 ;; first numbers
	FloatsB dq 1.98, 2.0, -2.0, 8.0, 3.0 ;; second numbers
	FloatsC dq 3.9, 3.9, -2.0, 8.0, -3.0 ;; third numbers
	
	; and the second one
	FloatsD dq -4.1 ;; fourth numbers
			  dq -4.1
			  dq -12.0
			  dq -2.0
			  dq -10.0

	firstConstant dq 2.0
	secondConstant dq 23.0
	thirdConstant dq 4.0
	
	zero dq 0.0
	negativeZero dq -0.0
	
	;; global variables for interpolating for main window
	;; (I will put some int into them and show in main window)
	;; mostly used for negative nums
	floatFinal DQ 0
	
	; for automating 
	possibleHeight DD 25
	coefficientOfMultiplyingForTextHeight DD 3
	valueForDQvalues DB 8

	; first text to show
	variantToShow DB "My equation = (2 * c - d / 23) / (ln(b - a / 4))", 13, 0
	; form, which I will be filling with variables
	equationVariables DB "For a = (%s), b = (%s), c = (%s) and d = (%s) We have (2 * (%s) - (%s) / 23) / (ln((%s) - (%s) / 4)) = ((%s) - (%s)) / (ln((%s) - (%s))) = (%s) / (ln((%s))) = (%s) / (%s) = (%s)", 13, 0

; Code Segment
.code
start: ; Generates program start-up code
	invoke WinWarningProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

	invoke GetModuleHandle, NULL
	mov hInstance, eax

	invoke WinMainProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

	invoke ExitProcess, eax ; quit program. code returns in EAX register from Main Function.

	; function declaration of WinWarn
	WinWarningProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	; there we need LOCAL variables
	LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

	; assign variables of WNDCLASSEX
	; window class is a specification of a window
    mov   wc.cbSize, sizeof WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, offset WndWarnProc
    mov   wc.cbClsExtra, NULL
    mov   wc.cbWndExtra, NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground, COLOR_WINDOW+1
    mov   wc.lpszMenuName, NULL
    mov   wc.lpszClassName, offset NameOfTheWarnWindows
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   wc.hIcon, eax
    mov   wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   wc.hCursor, eax

	; create class of the window
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, NULL,
                offset NameOfTheWarnWindows,
                offset MsgBoxName,
                WS_OVERLAPPEDWINDOW or DS_CENTER,
                470, 310, 300, 150,
                NULL, NULL, hInst, NULL
		mov hWndOfWarnWindow, eax

	; write window handle in eax
    mov   hwnd,eax
	
	; Show window
    invoke ShowWindow, hwnd,CmdShow
	; update screen
    invoke UpdateWindow, hwnd

	; waits for message
    .while TRUE
				;returns FALSE IF WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .IF (!eax)
				;takes raw keyboard input and generates a new message
                invoke TranslateMessage, addr msg
				;sends the message data to the window procedure responsible for the specific window the message is for
                invoke DispatchMessage, addr msg
	; end while
   .endw

   ; code returns in EAX register from Main Function.
	mov	eax, msg.wParam

	; return
	ret

	;The ENDP directive defines the end of the procedure
	;and has the same name as in the PROC directive
WinWarningProto endp

; function declaration of WinSuccess
WinMainProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	; there we need LOCAL variables
	LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

	; assign variables of WNDCLASSEX
	; window class is a specification of a window
    mov   wc.cbSize, sizeof WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, offset WndMainProc
    mov   wc.cbClsExtra, NULL
    mov   wc.cbWndExtra, NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground, COLOR_WINDOW+1
    mov   wc.lpszMenuName, NULL
    mov   wc.lpszClassName, offset NameOfMainWindows
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   wc.hIcon, eax
    mov   wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   wc.hCursor, eax
	
	; create class of the window
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, NULL,
                offset NameOfMainWindows,
                offset MsgBoxName,
                WS_OVERLAPPEDWINDOW or DS_CENTER,
                170, 50, 940, 550,
                NULL, NULL, hInst, NULL
		mov hWndOfMainWindow, eax

	; write window handle in eax
    mov   hwnd,eax
	
	; Show window
    invoke ShowWindow, hwnd,CmdShow
	; update screen
    invoke UpdateWindow, hwnd

	; waits for message
    .while TRUE
				;returns FALSE IF WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .IF (!eax)
				;takes raw keyboard input and generates a new message
                invoke TranslateMessage, addr msg
				;sends the message data to the window procedure responsible for the specific window the message is for
                invoke DispatchMessage, addr msg
	; end while
   .endw

   ; code returns in EAX register from Main Function.
	mov	eax, msg.wParam
	
	; return
	ret
   
	;The ENDP directive defines the end of the procedure
	;and has the same name as in the PROC directive
WinMainProto endp

WndMainProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.IF ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .ELSEIF ourMSG==WM_CREATE

		mov edi, 0
		; invoke macros #1 one time to create text
		PrintInformationInWindow possibleHeight, offset variantToShow

		;; do the loop
		LoopItself:

		;; values for equation
		invoke FloatToStr2, FloatsA[8*edi], addr BufferFloatA
		invoke FloatToStr2, FloatsB[8*edi], addr BufferFloatB
		invoke FloatToStr2, FloatsC[8*edi], addr BufferFloatC
		invoke FloatToStr2, FloatsD[8*edi], addr BufferFloatD

		;; start macros with floats from arrays
		DoArithmeticOperations FloatsA[8*edi], FloatsB[8*edi], FloatsC[8*edi], FloatsD[8*edi]
		
		; mov possibleHeight into eax
		mov eax, possibleHeight
		;; Convert byte to word
		cbw
		
		; mov possibleHeight into ebx
		mov ebx, coefficientOfMultiplyingForTextHeight
		;; Convert byte to word
		cbw
		
		;; coefficientOfMultiplyingForTextHeight * possibleHeight
		;; eax * ebx
		imul ebx

		imul esi
		
		; print text
		PrintInformationInWindow eax, offset TempPlaceForText
		
		inc edi
		inc esi
		
		cmp edi, 5
		jne LoopItself
		
		; create button
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForOKButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                395, 465, 150, 30,
                hWnd, 7033, hInstance, NULL

	.ELSEIF ourMSG==WM_COMMAND
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 
	
    .ELSE
		; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	
	ExitCode:
    xor eax, eax
    ret
WndMainProc endp

WndWarnProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.IF ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .ELSEIF ourMSG==WM_CREATE
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForOKButton,
                WS_CHILD or WS_VISIBLE or BS_CENTER or BS_TEXT or BS_VCENTER,
                65, 65, 150, 30,
                hWnd, 7003, hInstance, NULL
				
		invoke CreateWindowEx,NULL,
                offset NameOfTheText, offset StartingText,
                WS_VISIBLE or WS_CHILD or BS_TEXT or SS_CENTER  or BS_VCENTER,
                16, 10, 250, 50,
                hWnd, 7004, hInstance, NULL
				
	.ELSEIF ourMSG==WM_COMMAND
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 
	  
    .ELSE
		 ; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	 
	ExitCode:
    xor    eax,eax
    ret
WndWarnProc endp

end start
