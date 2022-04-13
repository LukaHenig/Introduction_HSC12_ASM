;   Author:   	   Luka Henig & Michael Stober
;   Last Modified: L. Henig & M. Stober, April 11, 2022
;
;   Usage:
;               JSR hexToASCII   --> Convert a hex number to null terminated ASCII string 
;   Parameter: X, D

; export symbols
        XDEF hexToASCII
      
; include derivative specific macros             
        INCLUDE 'mc9s12dp256.inc'

; RAM: Variable data section
   .data: SECTION

; ROM: Constant data
  .const: SECTION
     H2A: DC.B "0123456789ABCDEF"   ; Decoding_Table for translation

; ROM: Code section
   .init: SECTION

;**************************************************************
; Public interface function: hexToASCII ... Convert a hex number to null terminated ASCII string
; Parameter: X ... pointer to string
;            D ... hex value to convert
; Return: -
hexToASCII: pshx            ; Safe registers on stack
            pshy
            pshd
                
            ldy #H2A        ; Store adress of decodeing tabel      
            movb #'0', X    ; Store 0 at start of hex string  
            inx             ; Increment destination adress of string
            movb #'x', X    ; Store x at start of hex string
            inx
            ;Nibble 1
            lsra            ; Seperate first nibble by shifting 4 zeros
            lsra
            lsra
            lsra
            ldab A, Y       ; Load table with nibble offset
            stab 0, X       ; Store with offset 0 on adress X
            inx             
            ;Nibble 2
            puld            ; Reload d register with given hex value
            pshd
            lsla            ; Seperate secound nibble by shifting 4 zeros
            lsla            ; First left then right
            lsla
            lsla
            lsra
            lsra
            lsra
            lsra
            ldab A, Y       ; Load table with nibble offset 
            stab 0, X       ; Store with offset 0 on adress X
            inx
            ;Nibble 3
            puld            ; For last nibbles its the same procedure with register B
            pshd
            lsrb
            lsrb
            lsrb
            lsrb
            ldab B, Y
            stab 0, X
            inx
            ;Nibble 4
            puld            ; Reload d register with given value
            pshd
            lslb            ; Seperate secound nibble by shifting 4 zeros
            lslb            ; First left then right
            lslb
            lslb
            lsrb
            lsrb
            lsrb
            lsrb
            ldab B, Y
            stab 0, X
            inx
            movb #$00, X
            puld             ; Reload registers from stack
            puly
            pulx
            rts