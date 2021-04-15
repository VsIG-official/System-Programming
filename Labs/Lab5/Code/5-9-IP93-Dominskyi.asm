; Processors
.386
.model flat, stdcall
option CaseMap:None

WinWarningProto proto :dword,:dword,:dword
WinFailureProto proto :dword,:dword,:dword

; Libraries And Macroses
    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
 
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

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
            16, heightPosition, 170, 50,
            hWnd, 7044, hInstance, NULL
endm

; Macros #2 for calculating
DoArithmeticOperations macro aInt, bInt, cInt
	; My equation = (21 - a*c/4)/( 1 + c/a + b)
	
	xor ax,ax          ; �������� ������� ax
	
	mov al, d; � al c
	cbw
	idiv a; c/a
	add al,1 ; 1+c/a 
	add al, b; 1+c/a +b
	MOV res, AL   ; 1+c/a +b -> res
	
	mov al, a  ; � al a
	cbw
	imul d ;a * c       -> AL
	mov bl, 4
	IDIV bl    ; a * c / 4     -> AL
	mov bl, 21
	; mov al, 21; � al 21
	sub bl, al ; 21 -(a * c / 4)  -> AL
	cbw
	mov al,bl
	cbw
	
    IDIV res ;  (21 - a*c/4)/( 1 + c/a + b) -> AL
	cbw
endm

.data?
	hInstance HINSTANCE ? ; Handle of our program
	hWndOfWarnWindow HWND ? ; Handle of our warn window
	hWndOfFailureWindow HWND ? ; Handle of our failure window
	
	StringFromUser DB 128 dup(?)

; Data Segment
.data
	StartingText DB "� ���������� ���� �� �������� 5 ����� ������������ ������", 0
	
	; Name Of Message Box
	MsgBoxName  DB "5-9-IP93-Dominskyi", 0

	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our success window class
	NameOfFailureWindows DB "Window with failure text", 0 ; the name of our success window class
	
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForOKButton DB "��", 0
	
	; can't be 1 or 0
	; first way of declaring array
	IntegersA = DB 2, 8 , 13, -2, 70
	IntegersB = DB -33, 23, -2, 4, 5
	
	; and the second one
	IntegersC = DB 66
							  DB 24
							  DB 121
							  DB -54
							  DB 4

	variantToShow DB "My equation = (21 - a*c/4)/( 1 + c/a + b)"
	equation

; Code Segment
.code
start: ; Generates program start-up code
	invoke WinWarningProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

	invoke GetModuleHandle, NULL
	mov hInstance, eax

	invoke WinFailureProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

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
WinFailureProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	; there we need LOCAL variables
	LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

	; assign variables of WNDCLASSEX
	; window class is a specification of a window
    mov   wc.cbSize, sizeof WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, offset WndFailureProc
    mov   wc.cbClsExtra, NULL
    mov   wc.cbWndExtra, NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground, COLOR_WINDOW+1
    mov   wc.lpszMenuName, NULL
    mov   wc.lpszClassName, offset NameOfFailureWindows
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   wc.hIcon, eax
    mov   wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   wc.hCursor, eax
	
	; create class of the window
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, NULL,
                offset NameOfFailureWindows,
                offset MsgBoxName,
                WS_OVERLAPPEDWINDOW or DS_CENTER,
                510, 280, 220, 150,
                NULL, NULL, hInst, NULL
		mov hWndOfFailureWindow, eax

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
WinFailureProto endp

WndFailureProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.IF ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .ELSEIF ourMSG==WM_CREATE
		; invoke macros #1 one time to create text
		;DoArithmeticOperations 
		PrintInformationInWindow 10, offset MsgBoxName
		; create button
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForOKButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                65, 65, 70, 30,
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
WndFailureProc endp

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