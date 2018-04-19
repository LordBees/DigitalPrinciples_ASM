;***********************************************************************************************************
;*                                     This program configures the A/D Module to convert on     
;*                                     A/D channel 2 (the light dependant resistor) and display the             
;*                                     results on the 7 SEG display on PORTD.                                           
; *                                    Written by Robert painter
;***********************************************************************************************************
	include "p16f877.inc"

COUNTER EQU	H'0020'		 		;Delay value register
		org	0x000				;Originate at address 0000
		clrf	PORTD			;Clear Port D of any left-overs
Start	bsf	STATUS,RP0			;Change to bank 1 for 				  					
								;TRISD/TRISA/OPTION/ADCON1
		clrf	TRISD			;Clear PORTD as outputs for the leds
		movlw	H'003F'			;Set up Port A as inputs and ensure ldr is enabled
		movwf	TRISA			;
		movlw	H'0002'			; 
		movwf	ADCON1			;	
		bcf	STATUS, RP0			; 
		movlw	B'01010001'		;bit 4 has been unset this causes the channel to be 010 corresponding to the LDR
		movwf	ADCON0			;load adcon inputs
Main	bsf	ADCON0, GO_DONE		;Start A/D conversion
		movlw	10				;The sample and Hold of the A-D converter
		movwf	COUNTER			;resample values to get data 
Delay	decfsz COUNTER,F		;do it for an amount of times
		goto	Delay		
Conv	btfsc	ADCON0, GO_DONE	;Test this bit to check that A/D          
								;conversion is complete
		goto	Conv			;Keep checking until it is. 
		rrf ADRESH,1 ;rotate adress right 1 for 4 times
		rrf ADRESH,1 ;rotate adress
		rrf ADRESH,1 ;rotate adress
		rrf ADRESH,0 ;rotate adress
		andlw B'00001111'   ;and address so that we get a range of values(the higher ones for better range)
							;the high nibble has been shifted to the low nibble so that the value can be 
							;passed easily to the 7 seg lookup table 
		call Tableupd; update the 7 seg with the data obtained
		goto	Main			;Do it again




;lookup table
Table 	addwf PCL,F;;mov w to pc

		retlw H'0088';0
		retlw H'00ED';1
		retlw H'0094';2
		retlw H'00A4';3
		retlw H'00E1';4
		retlw H'00A2';5
		retlw H'0082';6
		retlw H'00EC';7
		retlw H'0080';8
		retlw H'00E0';9
		return; ensures bounds check as values unimplemented for nibble
		return;
		return;
		return;
		return;
		return;


Tableupd nop;
		;movf UPCOUNT,0
		call Table;call table sub
		movwf PORTD;;update leds with 7 seg
		return

		end
