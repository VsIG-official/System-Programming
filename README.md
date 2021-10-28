# System Programming

<p align="center">
  <img src="https://github.com/VsIG-official/System-Programming/blob/master/Labs/MASM.png" data-canonical-src="https://github.com/VsIG-official/System-Programming/blob/master/Labs/MASM.png" width="600" />
</p>

## Table of Contents

- [Description](#description)
- [Badges](#badges)
- [Contributing](#contributing)
- [License](#license)

### Description

My Labs for System Programming

## Badges

[![Theme](https://img.shields.io/badge/Theme-SysProg-blue)](https://img.shields.io/badge/Theme-SysProg-blue)
[![Assembly](https://img.shields.io/badge/Assembly-MASM-blue)](https://img.shields.io/badge/Assembly-MASM-blue)

---

## Example

```asm
	;; do the loop
	LoopItself:

	;; values for equation
        invoke FloatToStr2, FloatsA[8*edi], addr BufferFloatA
        invoke FloatToStr2, FloatsB[8*edi], addr BufferFloatB
        invoke FloatToStr2, FloatsC[8*edi], addr BufferFloatC
        invoke FloatToStr2, FloatsD[8*edi], addr BufferFloatD

        ;; start macros with floats from arrays
        DoArithmeticOperations FloatsA[8*edi], FloatsB[8*edi], FloatsC[8*edi], FloatsD[8*edi]
        
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

```

---

## Contributing

> To get started...

### Step 1

- 🍴 Fork this repo!

### Step 2

- **HACK AWAY!** 🔨🔨🔨

---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2021 © <a href="https://github.com/VsIG-official" target="_blank">VsIG</a>.
