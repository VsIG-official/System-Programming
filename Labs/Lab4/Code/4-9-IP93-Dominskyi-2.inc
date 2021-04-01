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

; Macros #2 for decrypting string from user
DecryptStringFromUser macro StringFromUserInput
	; for example, this commentary is included into macroexpansion
	;; but this - not

	; create a local mark, to so that there won't be confusion,
	;; when invoking macros more then 1 time
	LOCAL LoopItself
	
	; creating a loop, to check all letters
    LoopItself:
	
	;; incrementing counter edi
	inc edi
	
	; write one letter from input to ah register
	mov ah, StringFromUser[edi]
	;; decrypt one letter
	xor ah, XORKey

	; compare password length and counter
    cmp edi, PasswordCount
	
	;; if they are not equal, then continue the loop
	jne LoopItself
endm

; Macros #3 for checking string from user
IsPasswordLegit macro StringFromUserInput
	; for example, this commentary is included into macroexpansion
	;; but this - not

	; create a local mark, to so that there won't be confusion,
	;; when invoking macros more then 1 time
	LOCAL WrongPassword
	
	; create a local mark, to so that there won't be confusion,
	;; when invoking macros more then 1 time
	LOCAL LoopItself

    LoopItself:
	
	; incrementing counter edi
	inc edi
	
	;; compare password length and register
    cmp ax, PasswordCount
	
	; if they are the same, then quit macros
	je WrongPassword
	
	;; write one letter from input to ah register
	mov ah, StringFromUser[edi]
	; check ah register and one letter from user's input
    cmp ah, StringFromUserInput[edi]
	
	;; if they are the same, then continue the loop
    je LoopItself
	
	WrongPassword:
	
	; set some value, so our checks 
	;; will pass, IF password is legit
	mov ecx, -10
endm