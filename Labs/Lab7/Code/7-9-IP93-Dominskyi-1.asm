; Processors
.386
.model flat, stdcall
option CaseMap:None

.data
.code
extern FloatsB: qword, FloatsA: qword, BufferLowerPart: qword
public SecondPartProc
SecondPartProc proc
    fld a_arr[8*edi] ; st(0) = a
	fld constants[16]; st(0) = 4, st(1) = a
	fdiv			 ; st(0) = st(1)/st(0) = a/4

	fld b_arr[8*edi] ; st(0) = b, st(1) = a/4
	fsub 			 ; st(0) = st(1) - st(0) = a/4 - b
    fstp denominator
    ret
SecondPartProc endp
end
