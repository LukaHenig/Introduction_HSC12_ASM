;   Author:   	   Luka Henig & Michael Stober
;   Last Modified: L. Henig & M. Stober, April 11, 2022
;
;   Usage:
;               initLED   --> Initialization on PortB
;                             (Must be called once)
;               setLED    --> Output register B on LEDs
;               getLED    --> Get set LEDs from PortB to register B
;               toggleLED --> Toggle LEDs on PortB
;
;   Parameter: -

; export symbols
        XDEF initLED, setLED, getLED, toggleLED
      
; include derivative specific macros             
        INCLUDE 'mc9s12dp256.inc'

; ROM: Code section
.init: SECTION

;**************************************************************
; Public interface function: initLED ... Initialize LED (called once)
; Parameter: -
; Return: -
initLED: 
          bset DDRJ, #2       ; Bit set: Port J.1 as output
          bclr PTJ,#2         ; Bit clear: Port J.1 =0 --> Activate LEDs
          movb #$00ff, DDRB   ; Activate leds
          movb #00, PORTB     ; Set all LEDs off
          rts
          
;**************************************************************
; Public interface function: setLED ... Output register B on  LEDs
; Parameter: B    
; Return: -
setLED:
          stab PORTB          ; Load PORTB with B
          rts

;**************************************************************
; Public interface function: getLED ... Get set LEDs from PortB to register B
; Parameter: -
; Return: B
getLED:
          ldab PORTB          ; Load B with PORTB
          rts

;**************************************************************
; Public interface function: toggleLED ... Toggle LEDs on PortB
; Parameter: -
; Return: -
toggleLED:      
          pshb                ; Load B  data to stack
          eorb PORTB          ; B xor PORTB -> B
          stab PORTB          ; Load Port B with xor result
          pulb                ; Pull B data from stack
          
          rts