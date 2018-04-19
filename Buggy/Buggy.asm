; PIC18F45K20 buggycodes starter.asm
;author robert painter,Luke clayton
;buggy object avoidance code
; *******************************************************************

;DON'T  FORGET TO REMEMBER TO OUTPUT 00000000 TO PORT D IF YOU STOP THE PROGRAM. 
;THE PORT AND MOTORS WILL HAVE ONE OF THE 4 CODES ON IT AND MAYBE OVERHEAT!

;************************************************************************
	
#include <p18f45k20.inc>

;WE CAN SET UP THE CONFIGURATION HERE INSTEAD OF BY SETTING 'configuration bits' AS WE DID BEFORE. 
;BUT HAVE A LOOK AT THEM:    click on 'Configure' at the top when you have assembled your code.
 
	config FOSC = INTIO67
	config FCMEN = OFF
	config IESO = OFF
	config PWRT = OFF, BOREN = SBORDIS, BORV = 30                      	
	config WDTEN = OFF, WDTPS = 32768                                 	
 	config MCLRE = OFF, LPT1OSC = OFF, PBADEN = ON, CCP2MX = PORTC     	
	config STVREN = ON, LVP = OFF, XINST = OFF                        	
 	config CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF                  	
	config CPB = OFF, CPD = OFF                                       	
 	config WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF             	
 	config WRTB = OFF, WRTC = OFF, WRTD = OFF                          
 	config EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF          
 	config EBTRB = OFF  	


    cblock     0x20  	;THIS SAYS LEAVE 20 BYTES (FOR THE DELAY ROUTINES) JUST AFTER THE PROGRAM
			;INSTRUCTIONS WHEREVER IT FINISHES

	;Register names defined For the delay routine

	TIMINNER	
	TIMOUTER
	endc
     
     org 0x0			;Start assembling the program code at address 0

;****************************SET UP REGISTERS****************************
	    
;NOTE THAT WITH THIS PIC WE DO NOT HAVE TO CHANGE BANKS TO ACCESS THESE REGISTERS

INNER	EQU H'0020';setup delay values
OUTER	EQU H'0021'
outval	EQU H'0020'
inval	EQU H'0020'

;movlw targdel
;movwf dMov
targdel EQU H'0032';04'	;amount of rotations to do
targbk  EQU H'0019'	;amount of turns back to go
dMov	EQU H'0022';;addr 0x0022 ;	register for counting backwards

;Rotd EQU H'0023';rotation register
;Rott EQU H'00050';;200 steps for buggy 1 rot

Start movlw     0xFF         ;DON'T FORGET TO COMMENT EACH LINE TO SHOW YOU 
                             ;UNDERSTAND.

     movwf    TRISA       	; (Port A is connected to the potentiometer but we do not need this for the 
							; project).
     clrf	TRISD                
     ;movlw	B'00101111';'1110100';'00101111';0x01
	 movlw  0x0E;B'00001011'     			
     movwf	TRISB               	
     movlw	0x1F              	; PIC18F45K20 Data sheet see page 136 for ANSEL Bits 1= Analog 0 = Digital
     movwf	ANSEL         		; PortA pins are all analog, PortE pins are digital
     movlw	0x00	  			; see page 137 ANSELH bits 0 for Digital
     movwf	ANSELH      		; PortB pins are digitial (important as RB0 is switch)

									


;--main
main
	;;

		;movf PORTB,0;;to keep leds on or bitmask on leds
		;iorlw B'00101111';0x2F
		;goto main
	;call Forward
		call	lsense;poll each set of sensors to see what to do
		call	rsense
		call	bsense
		call	Forward;;go forward
	;;
	goto main

;------------------movement routines---------------------
Backward ;go backward
       	movlw  H'00C6';1100 0110	     
   		movwf  PORTD  ;move to working reg	    
       	call   delay  ;delay to allow time for motor to turn 

       	movlw  H'0093';1001 0011
     	movwf  PORTD  ;move to working reg	
		call   delay  ;delay to allow time for motor to turn

       	movlw  H'0039';0011 1001
     	movwf  PORTD  ;move to working reg
		call   delay  ;delay to allow time for motor to turn 
             
       	movlw  H'006C';0110 1100
     	movwf  PORTD  ;move to working reg
       	call   delay  ;delay to allow time for motor to turn

       	return		  ;return from movement function  

Leftb ;go left backwards
		movlw  H'0006';0000 0110	     
   		movwf  PORTD  ;move to working reg    
       	call delay    ;delay to allow time for motor to turn 

       	movlw  H'0003';0000 0011
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn 

       	movlw  H'0009';0000 1001
     	movwf   PORTD ;move to working reg
		call delay    ;delay to allow time for motor to turn 
             
       	movlw  H'000C';0000 1100
     	movwf  PORTD  ;move to working reg
       	call delay    ;delay to allow time for motor to turn 
		
		return		  ;return from movement function

Rightb ;go right backwards
		movlw  H'00C0';1100 0000	     
   		movwf  PORTD  ;move to working reg   
       	call delay 	  ;delay to allow time for motor to turn 

       	movlw  H'0090';1001 0000
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn 

       	movlw  H'0030';0011 0000
     	movwf   PORTD ;move to working reg
		call delay    ;delay to allow time for motor to turn 
             
       	movlw  H'0060';0110 0000
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn
		
		return		  ;return from movement function

Forward 				;R|L
       	movlw  H'006C';0110 1100
   		movwf  PORTD  ;move to working reg	    
       	call delay    ;delay to allow time for motor to turn

       	movlw  H'0039';0011 1001
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn

       	movlw  H'0093';1001 0011
     	movwf   PORTD ;move to working reg
		call delay    ;delay to allow time for motor to turn
             
       	movlw  H'00C6';;1100 0110
     	movwf  PORTD  ;move to working reg
       	call delay    ;delay to allow time for motor to turn

       	return		  ;return from movement function 

Leftf	nop
		movlw  H'000C';0000 1100	     
   		movwf  PORTD  ;move to working reg	    
       	call delay    ;delay to allow time for motor to turn

       	movlw  H'0009';0000 1001
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn

       	movlw  H'0003';0000 0011
     	movwf   PORTD ;move to working reg
		call delay    ;delay to allow time for motor to turn
             
       	movlw  H'0006';0000 0110
     	movwf  PORTD  ;move to working reg
       	call delay    ;delay to allow time for motor to turn
		
		return		  ;return from movement function

Rightf	nop
		movlw  H'0060';0110 0000
   		movwf  PORTD  ;move to working reg	    
       	call delay    ;delay to allow time for motor to turn

       	movlw  H'0030';0011 0000
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn

       	movlw  H'0090';1001 0000
     	movwf   PORTD ;move to working reg
		call delay    ;delay to allow time for motor to turn
             
       	movlw  H'0060';0110 0000
     	movwf  PORTD  ;move to working reg
		call delay    ;delay to allow time for motor to turn
		
		return		  ;return from movement function

;----quick routines----;
SRB nop;stop right back
	call Leftb;Rightb
	;call delayMove
	;call Backward
	;call delayMove
	decfsz dMov,F;decfsz Rotd,F ;decrement set rotations until 0, if 0 skip next instruction
	goto SRB
	movlw targbk
	movwf dMov;reload register with reverse turn amount
SRB2 nop
	call Backward;go backward
	decfsz dMov,F;decrement set steps until 0, if 0 skip next instruction
	goto SRB2
	return


SLB nop;stop left back
	call Rightb;Leftb
	decfsz dMov,F;decrement set steps until 0, if 0 skip next instruction
	goto SLB

	movlw targbk
	movwf dMov;reload register with reverse turn amount
SLB2 nop
	call Backward
	decfsz dMov,F;decrement set steps until 0, if 0 skip next instruction
	goto SLB2
	return


SBB nop;stop Back forward
	call Forward
	decfsz dMov,F;decrement set steps until 0, if 0 skip next instruction
	goto SBB
	;call Rightf
	return
;----------checking routine

;lsense
lsense 
		;btfsc
		;movf PORTB,0
		movlw targdel
		movwf dMov;load register with amount of loops needed to turn by 1/4 (200 steps per complete rotation)

		;movlw Rott;move steps of rotation into the working register
		;movwf Rotd

		btfsc PORTB,1;5	;bit test bit1 of portb(left sensor)
		return			;if clear skip next instruction
		call SLB
		return
;rsense
rsense 	nop
		movlw targdel
		movwf dMov
		btfsc PORTB,2;3	;bit test bit2 of portb(right sensor)
		return			;if clear skip next instruction
		call SRB
		return
		
;bsense
bsense	nop
		btfsc PORTB,3;6	;bit test bit3 of portb(back sensor)
		return		
		call SBB		;if clear skip next instruction
		return
		             
    
 ;*************************DELAY ROUTINE*****************    

delay 	movlw outval;load register outer
		movwf OUTER
delayx 	movlw inval;load register inner
		movwf INNER
delayin decfsz INNER,F;decrement until zero then skip out
		goto delayin
		decfsz OUTER,F;decrement untill zero then skip out
		goto delayx
		return

delayMove 	movlw targdel
			movwf dMov
delayMove1 	decfsz INNER,F
			goto delayMove1
			return
		


;**********************************************************************************		
end