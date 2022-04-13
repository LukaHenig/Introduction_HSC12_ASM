
;   Author:   	   Luka Henig & Michael Stober
;   Last Modified: L. Henig & M. Stober, April 13, 2022
;
; Export symbols
        XDEF Entry, main

; Import symbols
        XREF __SEG_END_SSTACK                     ; End of stack
        XREF initLCD, writeLine, delay_10ms       ; LCD functions
        XREF decToASCII, hexToASCII, delay_0_5sec ; Transver routins   
        XREF initLED, setLED, getLED, toggleLED   ; Led routins
; Include derivative specific macros
        INCLUDE 'mc9s12dp256.inc'

; RAM: Variable data section
 .data:  SECTION
     i:  dc.w 1
msghex:  ds.b 80     ; Pointer to array of 80 chars to save converted string
msgdec:  ds.b 80       

; ROM: Constant data
.const: SECTION

; ROM: Code section
.init:  SECTION


main:
Entry:
        lds  #__SEG_END_SSTACK          ; Initialize stack pointer
        cli                             ; Enable interrupts, needed for debugger

        jsr  delay_10ms                 ; Delay 20ms during power up
        jsr  delay_10ms

        jsr  initLCD                    ; Initialize the LCD
        jsr  initLED                    ; Initialize the LED

        movw #$0, i                     ; Initialize variable i with start value
        
loop:   ldd i                           ; Convert i to decimal string and display on LCD
        ldx #msgdec                     ; Preparation parameter D and X
        jsr decToASCII
        ldab #0                         ; Preparation for LCD
        jsr writeLine
        
        ldd i                           ; Convert i to hexadecimal string and display on LCD
        ldx #msghex                     ; Preparation parameter D and X
        jsr hexToASCII
        ldab #1                         ; Preparation for LCD
        jsr writeLine 
                                        ; Prepare B register for LEDs to only output lower 8 bit from i
        ldd i                           
        ldaa #$0
        jsr setLED
        
        ldab PTH                        ; For debug purpose
        ; Check if buttons are pressed
        brclr PTH, #$01, butten0pressed 
        brclr PTH, #$02, butten1pressed
        brclr PTH, #$04, butten2pressed
        brclr PTH, #$08, butten3pressed
        
        ldd i                           ; Increment i with 1
        addd #1
        std i
        
 
 
skip:   jsr delay_0_5sec                
        bra loop
        
        
  butten0pressed:                       ; Increment i with 16
        ldd i                           
        addd #16
        std i
        bra skip 
        
  butten1pressed:                       ; Increment i with 10
        ldd i                           
        addd #10
        std i
        bra skip 
        
  butten2pressed:                       ; Decrement i with 16
        ldd i                           
        subb #16
        std i
        bra skip 
        
  butten3pressed:                       ; Decrement i with 10
        ldd i                           
        subd #10
        std i
        bra skip

