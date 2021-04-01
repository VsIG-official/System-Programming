; Processors
.386
.model flat, stdcall
option  CaseMap:None

WinMainProto proto :dword,:dword,:dword
WinWarningProto proto :dword,:dword,:dword
WinSuccessProto proto :dword,:dword,:dword

; Libraries And Macroses
    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
 
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

; Our Macroses
; We place them here, 'cause it won't degrade the readability of the code

; Macros for printing some text
PrintInformationInWindow macro widthPosition, heightPosition, infoToShow 
	invoke CreateWindowEx,NULL,
            offset NameOfTheText, offset infoToShow,
            WS_VISIBLE or WS_CHILD or BS_TEXT or SS_CENTER  or BS_VCENTER,
            widthPosition, heightPosition, 170, 50,
            hWnd, 7044, hInstance, NULL
endm


.data?
	hInstance HINSTANCE ? ; Handle of our program
	hWndOfMainWindow HWND ? ; Handle of our main window
	hWndOfWarnWindow HWND ? ; Handle of our warn window
	hWndOfEditbox HWND ? ; Handle of our editbox
	StringFromUser DB 128 dup(?)

; Data Segment
.data
	StartingText DB "Введiть пароль у наступому вікні, щоб отримати дані", 0
	FailureText DB "Пароль невiрний. Спробуйте ще раз",  0
	
	; Name Of Message Box
	MsgBoxName  DB "4-9-IP93-Dominskyi", 0
	
	; We can write password in two ways:
	Password  DB "Mfd`gzbp`"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	XORKey DB 9h
	
	; Text To Show
	InformationText DB "ПIБ = Домiнський Валентин Олексiйович", 13, 
		 "Дата Народження = 22.02.2002", 13,
		 "Номер Залiковки книжки = 9311", 0
		 
	InformationTextSNP DB "ПIБ = Домiнський Валентин Олексiйович", 0
	InformationTextBirth DB "Дата Народження = 22.02.2002", 0
	InformationTextZalikova DB "Номер Залiковки книжки = 9311", 0

	NameOfTheStartingWindows DB "Window with starting text", 0 ; the name of our window class
	NameOfTheWarnWindows DB "Window with warn text", 0 ; the name of our success window class
	NameOfFailureWindows DB "Window with failure text", 0 ; the name of our success window class
	NameOfSuccessWindows DB "Window with some text", 0 ; the name of our success window class
	NameOfTheEditBox DB "Edit", 0 ; the name of our editbox class
	NameOfTheButton DB "Button", 0 ; the name of our button class
	NameOfTheText DB "Static", 0 ; the name of our text class
	
	TextForButton DB "Перевірити пароль", 0
	TextForWarnButton DB "ОК", 0

; Code Segment
.code
start: ; Generates program start-up code
	invoke WinWarningProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

	invoke GetModuleHandle, NULL
	mov hInstance, eax

	invoke WinMainProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function

	invoke ExitProcess, eax ; quit program. code returns in EAX register from Main Function.

	; function declaration of WinMain
	WinMainProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	 ; there we need local variables
	local wc:WNDCLASSEX
    local msg:MSG
    local hwnd:HWND

	; assign variables of WNDCLASSEX
	; window class is a specification of a window
    mov   wc.cbSize, sizeof WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, offset WndProc
    mov   wc.cbClsExtra, NULL
    mov   wc.cbWndExtra, NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground, COLOR_WINDOW+2
    mov   wc.lpszMenuName, NULL
    mov   wc.lpszClassName, offset NameOfTheStartingWindows
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   wc.hIcon, eax
    mov   wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   wc.hCursor, eax
	
	; create class of the window
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, NULL,
                offset NameOfTheStartingWindows,
                offset MsgBoxName,
                WS_OVERLAPPEDWINDOW or DS_CENTER,
                470, 280, 300, 200,
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
				;returns FALSE if WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .if (!eax)
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



; function declaration of WinWarn
	WinWarningProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	 ; there we need local variables
	local wc:WNDCLASSEX
    local msg:MSG
    local hwnd:HWND

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
                520, 310, 200, 150,
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
				;returns FALSE if WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .if (!eax)
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
WinSuccessProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	; there we need local variables
	local wc:WNDCLASSEX
    local msg:MSG
    local hwnd:HWND

	; assign variables of WNDCLASSEX
	; window class is a specification of a window
    mov   wc.cbSize, sizeof WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, offset WndSuccessProc
    mov   wc.cbClsExtra, NULL
    mov   wc.cbWndExtra, NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground, COLOR_WINDOW+1
    mov   wc.lpszMenuName, NULL
    mov   wc.lpszClassName, offset NameOfSuccessWindows
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov   wc.hIcon, eax
    mov   wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov   wc.hCursor, eax
	
	; create class of the window
    invoke RegisterClassEx, addr wc
    invoke CreateWindowEx, NULL,
                offset NameOfSuccessWindows,
                offset MsgBoxName,
                WS_OVERLAPPEDWINDOW or DS_CENTER,
                510, 280, 220, 200,
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
				;returns FALSE if WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .if (!eax)
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
WinSuccessProto endp

; function declaration of WinSuccess
WinFailureProto  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
	; there we need local variables
	local wc:WNDCLASSEX
    local msg:MSG
    local hwnd:HWND

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
                510, 280, 220, 200,
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
				;returns FALSE if WM_QUIT message is received and will kill the loop
                invoke GetMessage, addr msg,NULL,0,0
                .break .if (!eax)
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

WndSuccessProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.if ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .elseif ourMSG==WM_CREATE
		PrintInformationInWindow 16, 10, offset InformationTextSNP
				
		PrintInformationInWindow 16, 40, offset InformationTextBirth
				
		PrintInformationInWindow 16, 70, offset InformationTextZalikova
				
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForWarnButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                65, 125, 70, 30,
                hWnd, 7033, hInstance, NULL
				
	.elseif ourMSG==WM_COMMAND
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 
	  
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	 
	ExitCode:
    xor    eax,eax
    ret
WndSuccessProc endp

WndFailureProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.if ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .elseif ourMSG==WM_CREATE
		PrintInformationInWindow 16, 10, offset FailureText
				
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForWarnButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                65, 125, 70, 30,
                hWnd, 7033, hInstance, NULL
				
	.elseif ourMSG==WM_COMMAND
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 
	
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	 
	ExitCode:
    xor    eax,eax
    ret
WndFailureProc endp

WndProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.if ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .elseif ourMSG==WM_CREATE
		invoke CreateWindowEx,NULL,
                offset NameOfTheEditBox, NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL ,
                65,20,150, 30,
                hWnd, 7000, hInstance, NULL 
        mov hWndOfEditbox, eax

		 invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                60, 90, 170, 30,
                hWnd, 7001, hInstance, NULL
				
	.elseif ourMSG==WM_COMMAND
		mov  bx, 03h ; counter for tries
		
    	cmp wParam, 7001
		jne ExitCode
		
    	invoke SendMessage, hWndOfEditbox, WM_GETTEXT, PasswordCount+2, offset StringFromUser
		
    	mov edi, 0
    	cmp ax, PasswordCount
    	jne WrongPasswordByUser
		
		LoopItself:
		inc edi ; incrementing
		loop IsPasswordCorrect
		
		IsPasswordCorrect:
		cmp edi, PasswordCount
		je CorrectPasswordByUser
    	mov ah, StringFromUser[edi]
		xor ah, XORKey
		cmp ah, Password[edi] ; Compare 

		je LoopItself ; Jump Equal
 
		jmp WrongPasswordByUser ; Unconditional jump
		
    	WrongPasswordByUser:
		; counting tries
		add bx, -01h ; decrementing
		cmp bx, -01h ; negative possible tries
		je TotalExitCode
		
    	;invoke MessageBox, hWnd, offset FailureText, offset MsgBoxName, MB_OK
		
		invoke WinFailureProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function
		
    	jmp ExitCode
		
    	CorrectPasswordByUser:
		
    	;invoke MessageBox, hWnd, offset InformationText, offset MsgBoxName, MB_OK
		
		invoke WinSuccessProto, hInstance,NULL, SW_SHOWDEFAULT ;invoke function
		
		jmp ExitCode
		
	TotalExitCode:
         	invoke DestroyWindow,hWndOfMainWindow
	  
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	 
	ExitCode:
    xor    eax,eax
    ret
WndProc endp

WndWarnProc proc hWnd:HWND, ourMSG:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
	.if ourMSG==WM_CLOSE
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 

    .elseif ourMSG==WM_CREATE
		invoke CreateWindowEx,NULL,
                offset NameOfTheButton, offset TextForWarnButton,
                WS_VISIBLE or WS_CHILD or BS_CENTER or BS_TEXT or BS_VCENTER,
                55, 65, 70, 30,
                hWnd, 7003, hInstance, NULL
		invoke CreateWindowEx,NULL,
                offset NameOfTheText, offset StartingText,
                WS_VISIBLE or WS_CHILD or BS_TEXT or SS_CENTER  or BS_VCENTER,
                16, 10, 150, 50,
                hWnd, 7004, hInstance, NULL
				
	.elseif ourMSG==WM_COMMAND
		; exit program
		invoke DestroyWindow,hWnd
        invoke PostQuitMessage,NULL 
	  
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,ourMSG,wParam,lParam
        ret
    .ENDIF
	 
	ExitCode:
    xor    eax,eax
    ret
WndWarnProc endp

end start
