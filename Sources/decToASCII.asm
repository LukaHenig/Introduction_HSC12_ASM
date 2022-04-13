;   Author:   	   Luka Henig & Michael Stober
;   Last Modified: L. Henig & M. Stober, April 11, 2022
;
;   Usage:
;               JSR decToASCII   --> Convert a decimal number to null terminated ASCII string
;   Parameter: X, D
;
; export symbols
        XDEF decToASCII
      
; include derivative specific macros 
  INCLUDE 'mc9s12dp256.inc'

; RAM: Variable data section
.data: SECTION
       divider: DS.W  1
       remainder: DS.W 1

; ROM: Constant data
.const: SECTION
        D2A:  DC.B "0123456789"     ; Decoding_Tabel for translation

; ROM: Code section
.init: SECTION


;**************************************************************
; Public interface function: decToASCII ... Convert a decimal number to null terminated ASCII string
; Parameter: X ... pointer to string
;            D ... decimal value to convert
; Return: -
decToASCII: pshy            ; Safe register on stack
            pshx
            pshd
         
            tfr X, Y        ; Safe string adress in Y
            anda #$80       ; Mask msb, to check if number is negative
            cmpa #$80       ; If MSB is set branch, beacuse number is negative
            beq negativNum

            movb #' ', Y    ; Place 'space' at string begin 
            bra continue
negativNum: movb #'-', Y    ; Place '-' at string begin
            puld            ; Convert 2 Value into 2 complement
            coma            ; By converting registr A
            comb            ; And B
            addb #1         ; And adding 1
            adca #0         ; Add carry to A
            pshd            ; Store convertet number on stack
continue:   iny             ; Increment adress from string
            puld            ; Reload vaule in D, needed if number was negativ
            pshd
            tfr D, X        ; Store value in X
            stx remainder   ; Store value in variable remainder
            ldx #10000      ; Load X with the first divider
 loop:       
            stx divider     ; Store X in Divider variable
            cpx #0          ; Check if divider is 0 to leave subroutine
            beq leaveLoop
            ldd remainder   ; Load the remainder for next digit 
            idiv            ; Dividing by the divider stored in X
            std remainder   ; Store new remainder for next loop
            ldab D2A, X     ; Convert vaule with offset to ASCII
            stab 0, Y       ; Store ASCII value to string adress 
            iny
            ldx divider      
            
            tfr X, D        ; Store divider in D register
            ldx #10         ; Load X with 10 for division to get a smaler divider
            idivs           ; Next number
            
            stx divider     ; Store new divider 
            bra loop        
leaveLoop:  ldab #$00
            stab 0, Y       ; Append null-termination 
            puld            ; Get registers from stack 
            pulx
            puly
            rts
            
            