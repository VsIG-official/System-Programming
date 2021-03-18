; Processors
.386
.model flat, stdcall
option  CaseMap:None

WinMain proto :dword,:dword,:dword

; Libraries And Macroses
include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
 
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib

.data?
hInstance HINSTANCE ?        ; Handle of our program

; Data Segment
.data	
	StartingText DB "Введiть пароль. Попереджаю, що у Вас є лише 4 спроби:  ", 0
	FailureText DB "Пароль невiрний. Спробуйте ще раз. К-сть спроб, яка залишилася =  ",  0
	
	; Name Of Message Box
	MsgBoxName  DB "3-9-IP93-Dominskyi", 0
	
	;StringFromUser DB 128 dup(128)
	
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
	
;constant data (constants)
.const
	;The EQU directive assigns a value to the label, which is determined as the 
	;result of the integer expression on the right-hand side. The result of this 
	;expression can be an integer, an address, or any string of characters:
	;BUT
	;The EQU directive is most often used to introduce parameters common;
	; to the entire program, similar to the #define command of the C preprocessor
	IDC_START equ 3000
	IDC_FAILURE equ 3001
	IDC_INFORMATION equ 3002

; Code Segment
.code
start: ; Generates program start-up code
	InvitePoint:	; Starting Code

	invoke GetModuleHandle, NULL
	mov hInstance, eax

	invoke WinMain, hInstance,NULL, SW_SHOWDEFAULT ;invoke function
	invoke ExitProcess, eax ; quit program. code returns in EAX register from Main Function.

	;jmp InputOfTheUser ; Unconditional jump

	; Responsible For Input
	; function declaration of WinMain
	WinMain  proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdShow:dword
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
    invoke CreateWindowEx, NULL,\
                addr NameOfTheStartingWindows,\
                addr MsgBoxName,\
                WS_OVERLAPPEDWINDOW,\
                CW_USEDEFAULT,\
                CW_USEDEFAULT,\
                300,\
                200,\
                NULL,\
                NULL,\
                hInst,\
                NULL
    mov   hwnd,eax
	; Show window
    invoke ShowWindow, hwnd,CmdShow
	; update screen
    invoke UpdateWindow, hwnd

	; waits for message
    .while TRUE
                invoke GetMessage, addr msg,NULL,0,0
                .break .if (!eax)
                invoke TranslateMessage, addr msg
                invoke DispatchMessage, addr msg
   .endw
   ; code returns in EAX register from Main Function.
    mov     eax,msg.wParam
	; return
    ret 
	;The ENDP directive defines the end of the procedure
	;and has the same name as in the PROC directive
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	; on window close
    .if uMsg==WM_DESTROY               
		; exit program
        invoke PostQuitMessage,NULL 
    .else
		 ; process the message
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
    .endif
    xor eax,eax
    ret
WndProc endp
		; mov ah, 0Ah
		; mov dx, offset StringFromUser
		; int 21h
		;invoke MessageBox, 0, offset StartingText, offset MsgBoxName, MB_OK
		
		; mov ax, PasswordCount
		; cmp al, StringFromUser+1 ; Compare
        ; jne WrongPasswordByUser ; Jump Not Equal

		; mov si, offset Password
		; mov di, offset StringFromUser+2 ; low-order 16 bits of 32-bit registers
		; mov cl,PasswordCount ; counter register
		
	; ; Responsible For Checking, if password and input string are the same
	; IsPasswordCorrect:
		; lodsb ; loads 1 byte into the AL register
		
		; mov bh, byte ptr [di]
		
		; cmp al, bh ; Compare 
		; ; ptr = The first operator forces the expression to be treated as having
		; ; the specified type. The second operator specifies a pointer to type
		; je LoopItself ; Jump Equal
 
		; jmp WrongPasswordByUser ; Unconditional jump
        
	; LoopItself:
		; inc di ; incrementing
		; loop IsPasswordCorrect
 
	; ; Responsible For Correct Input
	; CorrectPasswordByUser:
		; ; Clear the screen
		; mov ax, 0600h ; register si 32-bit general-purpose register, used for temporary data storage and memory access
		; mov bh, 7h ; register represent the high-order 8 bits of the corresponding register
		; mov cx, 0000h
		; mov dx, 184fh
		; int 10h

		; ; Set the position of cursor
		; mov ah, 02h
		; mov bh, 00h
		; mov dl, 00h
		; mov dh, 00h
		; int 10h
	
		; mov ah, 09h
		; mov dx, offset InformationText
		; int 21h
	
		; jmp ExitCode ; Unconditional jump
	
	; ; Responsible For Wrong Input
	; WrongPasswordByUser:
		; ; Clear the screen
		; mov ax, 0600h
		; mov bh, 7h
		; mov cx, 0000h
		; mov dx, 184fh
		; int 10h

		; ; Set the position of cursor
		; mov ah, 02h
		; mov bh, 00h
		; mov dl, 00h
		; mov dh, 00h
		; int 10h
	
		; ; display text
		; mov ah, 09h
		; mov dx, offset FailureText
		; int 21h
		
		; mov  ah, 02h ; Display Counter
		; mov  dl, bl
		; add  dl, "0"   ; Integer to single-digit ASCII character
		; int  21h
		
		; mov dl, 0ah ; New Line
		; int 21h
		
		; ; counting tries
		; add bx, -01h ; decrementing
		; cmp bx, -01h ; negative possible tries
		; je ExitCode ; Jump Equal
		
		; jmp InputOfTheUser ; Unconditional jump
		
	; Responsible For Exit
	;ExitCode:
	;	invoke ExitProcess, 0
end start
