; Processors
.386
.model flat, stdcall
option  CaseMap:None

WinMainProto proto :dword,:dword,:dword
; CheckPasswordProto   proto :dword,:dword,:dword,:dword
; GetTextDialogProto PROTO :DWORD,:DWORD,:DWORD

; Libraries And Macroses
    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
 
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

.data?
	hInstance HINSTANCE ?        ; Handle of our program
	
	StringFromUser DB 128 dup(?)

; Data Segment
.data
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 4 спроби:  ", 0
	AdditionalText DB "Пароль вводити сюди",0
	FailureText DB "Пароль невiрний. Спробуйте ще раз. К-сть спроб, яка залишилася =  ",  0
	
	; Name Of Message Box
	MsgBoxName  DB "3-9-IP93-Dominskyi", 0
	
	; We can write password in two ways:
	Password  DB "Dominskyi"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	
	; Text To Show
	InformationText DB "ПIБ = Домiнський Валентин Олексiйович", 13, 
		 "Дата Народження = 22.02.2002", 13,
		 "Номер Залiковки книжки = 9311", 0
		 
	NameOfTheStartingWindows DB "Window with starting text",0        ; the name of our window class

; Code Segment
.code
start: ; Generates program start-up code
	invoke MessageBox, 0, offset StartingText, offset MsgBoxName, MB_OK

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
    mov   wc.hbrBackground, COLOR_WINDOW
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
                addr NameOfTheStartingWindows,
                addr MsgBoxName,
                WS_OVERLAPPEDWINDOW,
                470, 280, 300, 200,
                NULL, NULL, hInst, NULL
				

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
    mov     eax,msg.wParam
	; return
    ret 
	;The ENDP directive defines the end of the procedure
	;and has the same name as in the PROC directive
WinMainProto endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
    .if uMsg==WM_DESTROY               
		; exit program
        invoke PostQuitMessage,NULL 
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProc endp
end start
