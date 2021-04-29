; Processors
.386
.model flat, stdcall
option CaseMap:None

WinWarningProto proto :dword,:dword,:dword
WinMainProto proto :dword,:dword,:dword

; Libraries And Macroses
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
	
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
; For FloatToStr and FloatToStr2
include \masm32\macros\macros.asm

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
            16, heightPosition, 690, 50,
            hWnd, 7044, hInstance, NULL
endm

; Macros #2 for calculating
DoArithmeticOperations macro aFloat, bFloat, cFloat, dFloat
	; Label for ending macros
	Local EndThisMacros
	
	; My equation = (2 * c - d / 23) / (ln( b - a / 4))
	
	finit ; FPU Initialization
	
	fld numbersInEquation[0] ; st(0) = 2
	fld cFloat		 ; st(0) = c, st(1) = 2
	fmul 			 ; st(0) = st(1) * st(0)

	; 2*c
	; ^ works
	
	fld dFloat ; st(0) = d, st(1) = 2*c
	fld numbersInEquation[8] ; st(0) = 23, st(1) = d, st(2) = 2*c

	fdiv ; st(0) = st(1)/st(0) = d/23, st(1) = 2*c
	
	; d/23
	; ^ work
	
	fsub ; st(0) = st(1) - st(0) = 2*c - d/23
	
	; 2*c-d/23
	; ^ works
	
	fldln2 ; st(0) = ln(2), st(1) = 2*c-d/23
	; st(0) = ln(2), st(1) =  ln(b - a/4), st(2) = 2*c-d/23
	
	fld bFloat ; st(0) = b, st(1) = ln(2), st(2) = 2*c-d/23
	
	fld aFloat ; st(0) = a, st(1) = b, st(2) = ln(2), st(3) = 2*c-d/23
	fld numbersInEquation[16] ; st(0) = 4, st(1) = a, st(2) = b, st(3) = ln(2), st(4) = 2*c-d/23
	
	fdiv ; st(0) = st(1)/st(0) = a/4, st(1) = b, st(2) = ln(2), st(3) = 2*c-d/23
	
	; a/4
	; ^ works
	
	fsub ; st(0) = st(1) - st(0) = b - a/4, st(1) = ln(2), st(2) = 2*c-d/23
	
	; b-a/4
	; ^ works
	
	fyl2x ; st(0) = st(1)(st(0)) = ln(b - a/4), st(1) = 2*c-d/23
	
	; ln(b-a/4)
	; ^ works
	
	fdiv ; st(0) = st(1)/st(0) = (2*c-d/23)/(ln(b-a/4))
	
	; (2 * c - d / 23) / (ln( b - a / 4))
	; ^ works
	
	fstp intFinal
	
	;; parsing variables into TempPlaceForText
	invoke wsprintf, addr TempPlaceForText, addr equationVariables, 
	aFloat, bFloat, cFloat, dFloat, cFloat, dFloat, bFloat, aFloat, intFinal

	EndThisMacros:
endm

.data?
	hInstance HINSTANCE ? ; Handle of our program
	hWndOfWarnWindow HWND ? ; Handle of our warn window
	hWndOfMainWindow HWND ? ; Handle of our main window
	
	;; Text, that We will show
	TempPlaceForText DB 256 DUP(?)
	
	; Buffers for float numbers
	BufferFloatA DB 32 DUP(?)
	BufferFloatB DB 32 DUP(?)
	BufferFloatC DB 32 DUP(?)
	BufferFloatD DB 32 DUP(?)
	BufferFloatFinal DB 32 DUP(?)

; Data Segment
.data
	StartingText DB "� ���������� ��� �� �������� 5 ����� ������������ ������", 13, 0
	ZeroDivisionText DB "����� ����� �� ������ �� ����. �������� ��� ��������", 13, 0
	DivisionText DB "����� ����� �� ������ �� ����. �������� ��� ��������", 13, 0
	
	; Name Of Message Box
	MsgBoxName  DB "6-9-IP93-Dominskyi", 0

	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our warn window class
	NameOfMainWindows DB "Window with main text", 0 ; the name of our success window class
	
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForOKButton DB "��", 0
	
	; My equation = (2 * c - d / 23) / (ln( b - a / 4))
	
	; can't be 1 or 0
	; first way of declaring array
	FloatsA dq 0.3, 8 , -6, -2, 10 ;; first numbers
	FloatsB dq 1.98, 23, -2, 8, -3 ;; second numbers
	FloatsC dq 3.9, 23, -2, 8, -3 ;; third numbers
	
	; and the second one
	FloatsD dq -4.1 ;; fourth numbers
			  dq 24
			  dq -12
			  dq -2
			  dq 10
	
	numbersInEquation   dq 2.0, 23.0, 4.0
	
	;; global variables for interpolating for main window
	;; (I will put some int into them and show in main window)
	;; mostly used for negative nums
	;intA DQ 0
	;intB DQ 0
	;intC DQ 0
	;intD DQ 0
	;intFinal DQ 0
	
	; for automating 
	possibleHeight DD 12
	coefficientOfMultiplyingForTextHeight DD 3

	; first text to show
	variantToShow DB "My equation = (2 * c - d / 23) / (ln (b - a / 4))", 13, 0
	; form, which I will be filling with variables
	equationVariables DB "For a = (%s), b = (%s), c = (%s) and d = (%s) We have (2 * (%s) - (%s) / 23) / (ln( (%s) - (%s) / 4)) = (%s)", 13, 0

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
                250, 200, 740, 300,
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

		; ;; mov int with sign extending into global variable
		FloatToStr2 BufferFloatA, FloatsA[edi]
		
		; ;; mov int with sign extending into global variable
		; mov intB, FloatsB[edi]
		
		; ;; mov int with sign extending into global variable
		; mov intC, FloatsC[edi]
		
		; ;; mov int with sign extending into global variable
		; mov intD, FloatsD[edi]
		
		;; start macros with ints from arrays
		DoArithmeticOperations FloatsA[edi], FloatsB[edi], FloatsC[edi], FloatsD[edi]
		
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
                295, 215, 150, 30,
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
