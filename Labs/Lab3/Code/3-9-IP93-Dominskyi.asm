; Processors
.386
.model flat, stdcall
option  CaseMap:None

; WinMainProto proto :dword,:dword,:dword,:dword
; CheckPasswordProto   proto :dword,:dword,:dword,:dword
; GetTextDialogProto PROTO :DWORD,:DWORD,:DWORD

; Libraries And Macroses
    include \masm32\include\masm32rt.inc
    include \masm32\include\dialogs.inc

; .data?
	; hInstance HINSTANCE ?        ; Handle of our program
	
	; StringFromUser DB 128 dup(?)

; ; Data Segment


; .const
; IDC_EDIT EQU 1001
; IDC_TEXT EQU 1002
    ; msg_title  EQU "���� 3"
	   ; msg_pass   EQU "������ ������, ���� �����:"

IDC_EDIT EQU 1001
IDC_TEXT EQU 1002

MainDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
ErrorDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
DataDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD

.data?
    hInstance   DD ?
    usrInput    DB 64 DUP (?)

.data
	StartingText DB "����i�� ������. ����������, �� � ��� � ���� 4 ������:  ", 0
	AdditionalText DB "������ ������� ����",0
	FailureText DB "������ ���i����. ��������� �� ���. �-��� �����, ��� ���������� =  ",  0
	
	; Name Of Message Box
	MsgBoxName  DB "3-9-IP93-Dominskyi", 0
	
	; We can write password in two ways:
	Password  DB "Dominskyi"
	
	; And another one is:
	; Password  DB 31h 32h 33h
	
	PasswordCount = $-Password
	
	; Text To Show
	InformationText DB "�I� = ���i������ �������� �����i�����", 13, 
		 "���� ���������� = 22.02.2002", 13,
		 "����� ���i����� ������ = 9311", 0
		 
	NameOfTheStartingWindows DB "Window with starting text",0        ; the name of our window class

    msg_title  EQU "���� 3"
    msg_pass   EQU "������ ������, ���� �����:"
    msg_data   EQU 10, "������Ҳ ��Ͳ:", 10 ,\
        "ϲ� - ��������� �. �.", 10,      \
        "���� ���������� - 12.09.2001", 10,\
        "����� ��˲����� - 8410", 0
    msg_error  EQU 10, "������������ ������, ��������� �� ���!", 0
    passLen    DWORD 6

; Code Segment
.code
start: ; Generates program start-up code
	invoke MessageBox, 0, offset StartingText, offset MsgBoxName, MB_OK
	
        MOV hInstance, FUNC(GetModuleHandle, NULL)
        CALL mainWindow
        INVOKE ExitProcess, 0

    mainWindow PROC
        Dialog msg_title, "Monotype Corsiva", 20,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            3,                                         \
            50, 50, 150, 75,                            \
            1024
    
        DlgStatic msg_pass, 1, 0, 5, 150, 8, IDC_TEXT
        DlgEdit WS_BORDER or ES_WANTRETURN, 3, 20, 140, 9, IDC_EDIT
        DlgButton "OK", WS_TABSTOP, 50, 35, 50, 15, IDOK
        
        CallModalDialog hInstance, 0, MainDlgProc, NULL
        RET
    mainWindow ENDP

    MainDlgProc PROC hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
        LOCAL count:DWORD
        .IF uMsg == WM_COMMAND
            .IF wParam == IDOK
                MOV count, FUNC(GetDlgItemText, hWin, IDC_EDIT, ADDR usrInput, 512)
                MOV EAX, passLen
                .IF count != EAX
                    JMP error
                .ENDIF

                MOV EDI, 0
                validation:
                MOV DL, Password[EDI]
                MOV DH, usrInput[EDI]
                .IF DL != DH
                    JMP error
                .ENDIF

                INC EDI
                .IF EDI == count
                    JMP success
                .ENDIF

                JMP validation

                success:
                    invoke MessageBox, 0, offset InformationText, offset MsgBoxName, MB_OK
                    RET

                error:
                    	invoke MessageBox, 0, offset FailureText, offset MsgBoxName, MB_OK
                    RET
            .ENDIF
        .ELSEIF uMsg == WM_CLOSE
            INVOKE EndDialog, hWin, 0
        .ENDIF

        XOR EAX, EAX
        RET
    MainDlgProc ENDP

end start
