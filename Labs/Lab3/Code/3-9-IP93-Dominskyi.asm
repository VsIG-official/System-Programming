; Processors
.386
.model flat, stdcall
option  CaseMap:None

; WinMainProto proto :dword,:dword,:dword,:dword
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

MainDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
ErrorDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
DataDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD

; Data Segment
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

; Code Segment
.code
start: ; Generates program start-up code
	invoke MessageBox, 0, offset StartingText, offset MsgBoxName, MB_OK
	
        

end start
