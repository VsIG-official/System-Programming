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
	
	; address for Library
	hLib DWORD ?
	
	; address for function
	DoArithmeticOperationsAddress DWORD ?

; Data Segment
.data
	StartingText DB "У наступному вікні Ви побачите 5 різних арифметичних виразів", 13, 0
	ZeroDivisionText DB "Даний вираз має ділення на нуль. Перевірте Свої значення", 13, 0
	NegativeOrZeroLnText DB "Даний вираз має негативне число або нуль в (ln). Перевірте Свої значення", 13, 0
	
	; Name Of Message Box
	MsgBoxName  DB "8-9-IP93-Dominskyi", 0

	; Name of the Library to use
	LibraryName DB "8-9-IP93-Dominskyi-Dynamic-Entry-Library", 0
	
	; Name of the Function to use
	DoArithmeticOperationsFunctionFromTheLib DB "DoArithmeticOperations", 0

	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our warn window class
	NameOfMainWindows DB "Window with main text", 0 ; the name of our success window class
	
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForOKButton DB "ОК", 0
	
	; My equation = (2 * c - d / 23) / (ln( b - a / 4))
	
	; can't be 1 or 0
	; first way of declaring array
	FloatsA dq 2.0, -16.0, -68.946, 0.001, 4.0 ;; first numbers
	FloatsB dq 4.0, 23.091, 6.67, -3.33, 2.0 ;; second numbers
	FloatsC dq -99.0, -2.111, -78.2, 123.4, 44.47 ;; third numbers
	
	; and the second one
	FloatsD dq -15.125 ;; fourth numbers
			  dq 0.5
			  dq -22.1
			  dq -9.0
			  dq 12.2222

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

		; Dynamically Load Library
		invoke LoadLibrary, addr LibraryName
		; save descriptor
		mov hLib, eax
		
		; get function
		invoke GetProcAddress, hLib, addr DoArithmeticOperationsFunctionFromTheLib
		; save function
		mov DoArithmeticOperationsAddress, eax

		;; do the loop
		LoopItself:

		;; values for equation
		invoke FloatToStr2, FloatsA[8*edi], addr BufferFloatA
		invoke FloatToStr2, FloatsB[8*edi], addr BufferFloatB
		invoke FloatToStr2, FloatsC[8*edi], addr BufferFloatC
		invoke FloatToStr2, FloatsD[8*edi], addr BufferFloatD


		call [DoArithmeticOperationsAddress]
		
		;; start macros with floats from arrays
		;DoArithmeticOperations FloatsA[8*edi], FloatsB[8*edi], FloatsC[8*edi], FloatsD[8*edi]
		
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
