; Amaar Ebrahim
; ADC_DRIVER contains analog to digital converter driver subroutines

	GET ADC_ADR.s
	GET CLOCK_ADR.s
		
	AREA ADC_DRIVER, CODE
	ENTRY
	THUMB
		
		
;-----------------------------------------------------------------------
; Turns on ADC1's clock
;-----------------------------------------------------------------------
	EXPORT TURN_ON_ADC1_CLOCK
TURN_ON_ADC1_CLOCK PROC
	
			PUSH {R0, R1}
	
			LDR R0, =RCC_APB2ENR	; the ADC1's clock is controlled by RCC_APB2ENR
			LDR R1, [R0]			; load RCC_APB2ENR's value
			ORR R1, #0X100			; set bit 8 of RCC_APB2ENR (the ADC1 clock bit) to 1
			STR R1, [R0]			; store the new RCC_APB2ENR value
			
			POP {R0, R1}
			
			BX LR					; leave
	
		ENDP
			
			
;-----------------------------------------------------------------------
; Gets the ADC's most recent conversion, located in ADC_DR.
; 	@return R0: a 32-bit number between 0 and 4096 indicating the digital
;		voltage. 
;-----------------------------------------------------------------------
	EXPORT GET_ADC1_VALUE
GET_ADC1_VALUE PROC
	
			PUSH {R1}
			
			LDR R1, =ADC_DR
			LDR R0, [R1] ; load the value at address ADC_DR into r0
			
			POP {R1}
			
			BX LR
	
		ENDP
		
		
	END