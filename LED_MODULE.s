; Amaar Ebrahim
; Utilities module for the LED

	GET GPIO_ADR.s


	AREA CLOCK_MODULE, CODE, READONLY
	THUMB
	ENTRY
	IMPORT TURN_ON_CLOCK
	
;-----------------------------------------------------------------------
; Sets up the LEDs
;-----------------------------------------------------------------------	
	EXPORT SET_UP_LEDS
SET_UP_LEDS PROC
	
			PUSH {R0, LR}
	
			;PUSH {LR}
			MOV R0, #2_1000			; configuration to turn on the the clock for GPIOD
			BL TURN_ON_CLOCK		; call TURN_ON_CLOCK
			BL CONFIG_MODE			; make the leds output
			
			POP {R0, LR}
		ENDP
			
			
	
;-----------------------------------------------------------------------
; sets the mode of GPIOD pins 12 - 15 to output. 
;-----------------------------------------------------------------------
	EXPORT CONFIG_MODE
CONFIG_MODE PROC
	
			PUSH {R0, R1}
	
			LDR R0, =GPIOD			; load GPIOD's address into r0
			LDR R1, [R0]			; load GPIOD's value into r1.
			MOVT R1, #0x5500		; set the mode of pins 12 - 15 to output
			STR R1, [R0]			; make the changes take effect

			
			POP {R0, R1}
			
			BX LR					; exit
			
		ENDP
	
; ------------------------------------------------------------
; Turns on or off the LEDs controlled by pins 12 - 15 of GPIOD 
; 	@param (R0): a 4 bit number. Bit 0 corresponds to the yellow LED
;	Bit 1 correponds to the green LED. Bit 2 corresponds to the
;	red LED. Bit 3 corresponds to the blue LED.
;		Example: 0x0000_000F means turn on all LEDs
; ------------------------------------------------------------
	EXPORT SET_LEDS
SET_LEDS	PROC
	
			PUSH {R1, R2}
	
			; clear bits 12 - 15 of the output LED pins
			LDR R1, =GPIOD
			LDRH R2, [R1, #GPIO_ODR]
			BIC R2, #0XF000
			
			LSL R3, R0, #12		; shift R0 by 12 bits, to align it with GPIOD's pins
			; put the new LED states into r2
			ORR R2, R3
			
			; write r2 to the pins
			STR R2, [R1, #GPIO_ODR]
			
			POP {R1, R2}
			
			BX LR
	
		ENDP
			
; ------------------------------------------------------------
; Turns on or off the blue LED (pin 15 of GPIOD)
; 	@param (R0): a 1 bit number. 1 if to turn it on. 0 if to turn
;	it off.
;		Example: 0x1 means turn on the LED
; ------------------------------------------------------------
	EXPORT TOGGLE_BLUE_LED
TOGGLE_BLUE_LED PROC
	
			PUSH {R1, R2}
	
			; clear bit 15 of the output LED pins
			LDR R1, =GPIOD
			LDRH R2, [R1, #GPIO_ODR]
			BIC R2, #0X8000
			
			LSL R3, R0, #15		; shift R0 by 15 bits, to align it with pin 15 (blue)
			; put the new LED states into r2
			ORR R2, R3
			
			; write r2 to the pins
			STR R2, [R1, #GPIO_ODR]
			
			POP {R1, R2}
			
			BX LR			
	
		ENDP
			
; ------------------------------------------------------------
; Turns on or off the orange LED (pin 13 of GPIOD)
; 	@param (R0): a 1 bit number. 1 if to turn it on. 0 if to turn
;	it off.
;		Example: 0x1 means turn on the LED
; ------------------------------------------------------------
	EXPORT TOGGLE_ORANGE_LED
TOGGLE_ORANGE_LED PROC
	
			PUSH {R1, R2}
	
			; clear bit 13 of the output LED pins
			LDR R1, =GPIOD
			LDRH R2, [R1, #GPIO_ODR]
			BIC R2, #0X2000
			
			LSL R3, R0, #13		; shift R0 by 13 bits, to align it with pin 13 (orange)
			; put the new LED states into r2
			ORR R2, R3
			
			; write r2 to the pins
			STR R2, [R1, #GPIO_ODR]
			
			POP {R1, R2}
			
			BX LR			
	
		ENDP
			
			
; ------------------------------------------------------------
; Turns on or off the green LED (pin 12 of GPIOD)
; 	@param (R0): a 1 bit number. 1 if to turn it on. 0 if to turn
;	it off.
;		Example: 0x1 means turn on the LED
; ------------------------------------------------------------
	EXPORT TOGGLE_GREEN_LED
TOGGLE_GREEN_LED PROC
	
			PUSH {R1, R2}
	
			; clear bit 12 of the output LED pins
			LDR R1, =GPIOD
			LDRH R2, [R1, #GPIO_ODR]
			BIC R2, #0X1000
			
			LSL R3, R0, #12		; shift R0 by 12 bits, to align it with pin 12 (green)
			; put the new LED states into r2
			ORR R2, R3
			
			; write r2 to the pins
			STR R2, [R1, #GPIO_ODR]
			
			POP {R1, R2}
			
			BX LR			
	
		ENDP


	END