;   Author:   	   Luka Henig & Michael Stober
;   Last Modified: L. Henig & M. Stober, April 11, 2022
;
;   Usage:
;               JSR delay_0_5sec   --> delay 0.5 secound (@ 24MHz  bus clock) 
;   Parameter: -

; export symbols
        XDEF delay_0_5sec
      
; include derivative specific macros             
        INCLUDE 'mc9s12dp256.inc'

; ROM: Code section
.init: SECTION

;**************************************************************
; Public interface function: delay_0_5sec ... 0.5s Delay (@24MHz bus clock)
; Parameter: -
; Return: -
delay_0_5sec: pshd
              pshy
              ldd #$C8        ; 1 cycle, 200 decimal
loop2:        ldy #$4E20      ; 1 cycle, 20000 decimal
loop1:        dbne Y, loop1   ; 3 cycle
              dbne D, loop2   ; 3 cycle
              puld            
              puly
              rts