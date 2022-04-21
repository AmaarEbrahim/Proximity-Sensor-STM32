; Amaar Ebrahim
; Last updated 4/18/22
; Honors project: proximity sensor
; Important information:
;		The red LED turns on at ~.5 inches above the proximity sensor
;		The orange LED turns on at ~1.5 inches above the proximity sensor
;		The green LED turns on at ~6 inches above the proximity sensor

	GET GPIO_ADR.s
	GET CLOCK_ADR.s
	GET ADC_ADR.s

	AREA PROXIMITY_SENSOR, CODE
	ENTRY
	THUMB
		
	IMPORT TURN_ON_CLOCK
	IMPORT TURN_ON_ADC1_CLOCK
	IMPORT GET_ADC1_VALUE
	IMPORT SET_UP_LEDS
	IMPORT SET_LEDS
		
	EXPORT __main
		
; voltage difference thresholds for each LED.
GREEN_LED_INDICATOR_VALUE EQU 300
YELLOW_LED_INDICATOR_VALUE EQU 1000
RED_LED_INDICATOR_VALUE EQU 2500
		
__main 	PROC
	
			BL INITIALIZE_ADC
			BL INITIALIZE_ANALOG_IN_FROM_PHOTOTRANSISTOR
			BL INITIALIZE_IR_LED
			BL SET_UP_LEDS

			
			BL PROXIMITY_SENSOR_LOOP
			
			
		
	
		ENDP
			
			
; Make pin PB0 an analog input
MAKE_PB0_ANALOG PROC
	
			PUSH {R0, R1}
			LDR R0, =GPIOB	; get the address of GPIOB
			LDR R1, [R0]	; get the value of the GPIOB modes
			ORR R1, #2_11	; set pin 0 to analog by setting bits 0 and 1
							; to 1
			STR R1, [R0]
			
			POP {R0, R1}
			
			BX LR
			
	
		ENDP
			

			
; turn the adc on through ADON bit
; configure the adc to be continuous through CONT bit
CONFIGURE_ADC_CONTROL_SETTINGS PROC
	
			PUSH {R0, R1}
	
			LDR R0, =ADC_CR2	; load ADC_CR2. This is where the ADON and CONT bits are.
			LDR R1, [R0]		; get the value of ADC_CR2
			ORR R1, #2_11		; set bit 0 (the ADON bit) to 1 and bit 1 (the CONT bit) to 1
			STR R1, [R0]		; store the new value of ADC_CR2
			
			POP {R0, R1}
			
			BX LR
			
		ENDP
			
; sets the SWSTART bit of the ADC's control register 2 to begin conversion
START_ADC_CONVERSION PROC
			
			PUSH {R0, R1}
			
			LDR R0, =ADC_CR2
			LDR R1, [R0]
			ORR R1, #0X40000000	; set bit 30 (SWSTART) as 1 to start ADC conversion
			STR R1, [R0]
			
			POP {R0, R1}
			
			BX LR
			
		ENDP
			
; set channel 8 as the highest priority channel
CONFIGURE_SEQUENCE_REGISTER_FOR_ADC1_8 PROC
	
			PUSH {R0, R1}
	
			LDR R0, =ADC_SQR3	
			LDR R1, [R0]
			ORR R1, #0X8			; set SQR3's bottom 4 bits to 0100 to signify channel 8 is the highest priority
									; for conversion. Channel 8 corresponds to PB0, which is where analog input is being
									; received.
			STR R1, [R0]
			
			POP {R0, R1}
			
			BX LR
			
	
		ENDP

		
; makes pin PC0 an output pin. PC0 is connected to the IR LED	
MAKE_PC0_OUTPUT PROC
	
			PUSH {R0, R1}
			LDR R0, =GPIOC	; get the address of GPIOC
			LDR R1, [R0]	; get the value of the GPIOC modes
			ORR R1, #2_01	; set pin 0 to output
			STR R1, [R0]
			
			POP {R0, R1}
			
			BX LR
						
	
		ENDP
			
; turn on the IR_LED by clearing PB0's output value
TURN_ON_IR_LED PROC
	
			PUSH {R0, R1}
			LDR R0, =GPIOC
			LDR R1, [R0, #GPIO_ODR]
			BIC R1, #1
			STR R1, [R0, #GPIO_ODR]
			
			POP {R0, R1}
			
			BX LR
	
		ENDP
		
; turn on the IR_LED by setting PB0's output value to 1	
TURN_OFF_IR_LED PROC
	
			PUSH {R0, R1}
			LDR R0, =GPIOC
			LDR R1, [R0, #GPIO_ODR]
			ORR R1, #1
			STR R1, [R0, #GPIO_ODR]
			
			POP {R0, R1}
			
			BX LR
	
		ENDP
			
			
; configure the ADC and start conversion
INITIALIZE_ADC PROC
	
			PUSH {LR}
			; turn on the ADC clock
			BL TURN_ON_ADC1_CLOCK
			
			; turn on the ADC1 and make it continuous
			BL CONFIGURE_ADC_CONTROL_SETTINGS
			
			; make ADC1_8 (pin PB0) the first priority channel
			BL CONFIGURE_SEQUENCE_REGISTER_FOR_ADC1_8
			
			; start converting
			BL START_ADC_CONVERSION			
			POP {LR}
			
			BX LR
	
		ENDP
			
; turn on PC0's clock, make it an output pin, and turn on the IR LED
INITIALIZE_IR_LED PROC
	
			PUSH {LR}
	
			; turn on GPIOC
			MOV R0, #0X4
			BL TURN_ON_CLOCK
			
			; configure PC0 as digital output for the IR LED. The IR LED is driven by PC0.
			BL MAKE_PC0_OUTPUT
			
			; turn on the IR LED
			BL TURN_ON_IR_LED		

			POP {LR}
			
			BX LR
	
		ENDP
			
; turn on the clock for PB0, and make PB0 an analog input
INITIALIZE_ANALOG_IN_FROM_PHOTOTRANSISTOR PROC
	
			PUSH {LR}
			; turn on GPIOB
			MOV R0, #0X2
			BL TURN_ON_CLOCK
			
			; adjust PB0 (ADC1_8) to analog. The phototransistor feeds PB0.
			BL MAKE_PB0_ANALOG	
			
			POP {LR}
			
			BX LR
		ENDP
			
; delay for n cycles
; R0 contains the n
DELAY_FOR_N_CYCLES PROC
	
DELAY_FOR_N_CYCLES_LOOP
			SUBS R0, #1
			BNE DELAY_FOR_N_CYCLES_LOOP
			
			BX LR
	
		ENDP
			
			
; set the on-board LEDs based on the voltage difference
; r0: the voltage difference 
LED_INDICATOR PROC
	
			PUSH {LR, R0, R1}
	
			; compare the voltage difference to the threshold for each
			; LED. If the voltage is greater than one of the thresholds,
			; then that LED, and no other, will turn on.
			LDR R1, =RED_LED_INDICATOR_VALUE
			CMP R0, R1
			BGT LED_INDICATOR_RED_LIGHT
			
			LDR R1, =YELLOW_LED_INDICATOR_VALUE
			CMP R0, R1
			BGT LED_INDICATOR_YELLOW_LIGHT
			
			LDR R1, =GREEN_LED_INDICATOR_VALUE
			CMP R0, R1
			BGT LED_INDICATOR_GREEN_LIGHT
			
			
			MOV R0, #2_0000
			BL SET_LEDS
			B LED_INDICATOR_LEAVE
		
LED_INDICATOR_RED_LIGHT
			MOV R0, #2_0100
			BL SET_LEDS
			B LED_INDICATOR_LEAVE
			
LED_INDICATOR_GREEN_LIGHT	
			MOV R0, #2_0001
			BL SET_LEDS
			B LED_INDICATOR_LEAVE

LED_INDICATOR_YELLOW_LIGHT
			MOV R0, #2_0010
			BL SET_LEDS


LED_INDICATOR_LEAVE
			POP {LR, R0, R1}
			BX LR
	
		ENDP
			

; continuously get the digital value from the ADC, get the voltage difference
; and 
PROXIMITY_SENSOR_LOOP PROC
			
			; get ADC value after the IR LED has been off for a while
			BL GET_ADC1_VALUE
			MOV R1, R0
			LDR R0, =ADC_OFF
			STR R1, [R0]

			;turn on the IR LED
			BL TURN_ON_IR_LED
	
			; allow discharging
			LDR R0, =0X10000
			BL DELAY_FOR_N_CYCLES
		
			; get the ADC value after the IR LED has been on for a while
			BL GET_ADC1_VALUE
			MOV R2, R0
			LDR R0, =ADC_ON
			STR R2, [R0]
			
			; turn off the IR LED
			BL TURN_OFF_IR_LED
			
			; find the voltage difference (R1 - R2)
			; if the voltage diff is negative, make it 0
			SUBS R1, R2
			BGT DO_CHANGE
			MOV R1, #0
			
			
DO_CHANGE

			; store the voltage difference
			MOV R0, R1
			LDR R1, =VOLTAGE_DIFFERENCE
			STR R0, [R1]
			
			; turn on the appropriate LEDS (voltage diff is in R0 ^^)
			BL LED_INDICATOR
			
			
			; allow charging
			LDR R0, =0X40000
			BL DELAY_FOR_N_CYCLES
			
			
			
			B PROXIMITY_SENSOR_LOOP
	
		ENDP
		
		
	
	AREA PROXIMITY_SENSOR_DATA, DATA
	EXPORT VOLTAGE_DIFFERENCE
	EXPORT ADC_OFF
	EXPORT ADC_ON
VOLTAGE_DIFFERENCE DCD 32		; helpful for debug: stores voltage diff
ADC_OFF DCD 32					; helpful for debug: stores voltage value when IR LED is off for a while
ADC_ON DCD 32					; helpful for debug: stores voltage value when IR LED is on for a while

	
	
	
	END
	
	
	