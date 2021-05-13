; Processors
.386
.model flat, stdcall
option CaseMap:None

.data
.code
extern FloatsB: qword, FloatsA: qword, BufferLowerPart: qword, thirdConstant: qword
public SecondPartProc
SecondPartProc proc

    ret
SecondPartProc endp
end
