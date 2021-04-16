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
            16, heightPosition, 490, 50,
            hWnd, 7044, hInstance, NULL
endm

; Macros #2 for calculating
DoArithmeticOperations macro aInt, bInt, cInt
	; My equation = (21 - a * c / 4) / (1 + c / a + b)
	
	; (1 + c / a + b)
	; move cInt into al register
	mov al, cInt
	; Convert byte to word
	cbw
	; cInt / aInt
	idiv aInt
	; 1 + cInt / aInt 
	add al,1 
	; 1 + cInt / aInt + bInt
	add al, bInt
	; move (1 + cInt / aInt + bInt) into buffer TempPlaceForText
	mov TempPlaceForText, al
	
	; (21 - a * c / 4)
	; move aInt into al register
	mov al, aInt
	; Convert byte to word
	cbw
	; aInt * cInt
	imul cInt
	; move 4 into bl
	mov bl, 4
	; aInt * cInt / 4
	idiv bl
	; move 21 into bl
	mov bl, 21
	; 21 - (aInt * cInt / 4)
	sub bl, al
	; Convert byte to word
	cbw
	; move bl into al
	mov al,bl
	; Convert byte to word
	cbw
	
	; (21 - a * c / 4) / (1 + c / a + b)
    idiv TempPlaceForText
	; Convert byte to word
	cbw
	
	; Computes the bit-wise logical AND of first operand
	; (source 1 operand) and the second operand (source 2 operand)
	; and sets the SF, ZF, and PF status flags according to the result.
	; The result is then discarded.
	test al, al
	; Status of parity flag
	; if odd, then multiply
	.if parity?
		;; move 5 into bl
		mov bl, 5
		;; Convert byte to word
		cbw
		;; al * 5
		imul bl
		;; Convert byte to word
		cbw

	; if even, then divide
	.else
		;; move 2 into bl
		mov bl, 2
		;; Convert byte to word
		cbw
		; al / 2
		idiv bl
		;; Convert byte to word
		cbw
	.endif

	; Copies the contents of the source operand (register or memory location)
	; to the destination operand (register) and sign extends the value to 16 or 32 bits
	movsx eax,  al
	; move eax into intFinal
	mov intFinal, eax
endm

.data?
	hInstance HINSTANCE ? ; Handle of our program
	hWndOfWarnWindow HWND ? ; Handle of our warn window
	hWndOfMainWindow HWND ? ; Handle of our main window
	
	;; Text, that We will show
	TempPlaceForText DB 256 DUP(?)
	
; Data Segment
.data
	StartingText DB "У наступному вікні Ви побачите 5 різних арифметичних виразів", 13, 0
	
	; Name Of Message Box
	MsgBoxName  DB "5-9-IP93-Dominskyi", 0

	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our warn window class
	NameOfMainWindows DB "Window with main text", 0 ; the name of our success window class
	
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForOKButton DB "ОК", 0
	
	; My equation = (21 - a * c / 4) / (1 + c / a + b)
	
	; can't be 1 or 0
	; first way of declaring array
	IntegersA DB 2, 8 , -6, -2, 10 ;; first numbers
	IntegersB DB -33, 23, -2, 8, -3 ;; second numbers
	
	; and the second one
	IntegersC 	DB 66 ;; third numbers
				DB 24
				DB -12
				DB -2
				DB 10
	
	;; global variables for interpolating for main window
	;; (I will put some int into them and show in main window)
	;; mostly used for negative nums
	intA DD 0
	intB DD 0
	intC DD 0
	intFinal DD 0
	
	; for automating 
	possibleHeight DD 12
	coefficientOfMultiplyingForTextHeight DD 3

	; first text to show
	variantToShow DB "My equation = (21 - a * c / 4) / (1 + c / a + b)", 13, 0
	; form, which I will be filling with variables
	equationVariables DB "For a = %d, b = %d and c = %d and result = %d", 13, 0

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
                350, 200, 540, 300,
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
		;; mov int with sign extending from first array into eax
		movsx eax,  IntegersA[edi]
		;; mov eax with sign extending into global variable
		mov intA, eax
		
		;; mov int with sign extending from second array into eax
		movsx eax,  IntegersB[edi]
		;; mov eax with sign extending into global variable
		mov intB, eax
		
		;; mov int with sign extending from third array into eax
		movsx eax,  IntegersC[edi]
		;; mov eax with sign extending into global variable
		mov intC, eax
		
		;; start macros with ints from arrays
		DoArithmeticOperations IntegersA[edi], IntegersB[edi], IntegersC[edi]
		
		;; parsing variables into TempPlaceForText
		invoke wsprintf, addr TempPlaceForText, addr equationVariables, 
        intA, intB, intC, intFinal
		
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
                175, 215, 150, 30,
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
