;first asm file
include "p16f877.inc";include register names
					 ;from another source file

start movlw 0	;move literal value 0 into the working register

loop addlw 1	;add literal value 1 to the working register
	 nop;		;no operation
	 goto loop	;;goto label loop
	 end		;;end program