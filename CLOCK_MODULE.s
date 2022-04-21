; Amaar Ebrahim
; Utilities module for the clock
; @MOVE THIS TO THE GPIO DRIVER
	
	GET GPIO_ADR.s


	AREA CLOCK_MODULE, CODE, READONLY
	THUMB
	ENTRY
	
;-----------------------------------------------------------------------
; turns on GPIO ports by enabling their clocks
;	@param (R0): a 32-bit number. Each bit corresponds to which port to
;	turn on. A 1 means turn it on.
;		Example: 0x0000_0008 means turn on GPIO D
;-----------------------------------------------------------------------
	EXPORT TURN_ON_CLOCK
TURN_ON_CLOCK PROC
		
			PUSH {R1, R2}			; push R1 and R2 onto the stack
		
			LDR R1,=RCC_AHB1ENR		; load the address of RCC_AHB1ENR, which controls the clocks
			LDR R2,[R1]				; load the value of RCC_AHB1ENR
			ORR R2, R0				; turn on the appropriate GPIO ports
			STR R2,[R1] 			; store the new settings
			
			POP {R1, R2}			
			BX LR					; exit
		ENDP
			
			
;-----------------------------------------------------------------------
; Delays N half seconds using a for loop
;	@param (R0): a 32-bit number with the number of half seconds to 
;		delay.
;-----------------------------------------------------------------------
	EXPORT DELAY_N_HALF_SECONDS
DELAY_N_HALF_SECONDS PROC
			PUSH {R1}
	
			LDR R1, =3600000		; there are 3600000 cycles/half second
			MUL R0, R1				; get total cycles to burn through
DELAY_N_HALF_SECONDS_LP
			SUBS R0, #1	
			BNE DELAY_N_HALF_SECONDS_LP
			
			POP {R1}
			BX LR
			
			
			
		ENDP
			
			
	END