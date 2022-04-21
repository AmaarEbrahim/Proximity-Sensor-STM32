; Amaar Ebrahim
; This file stores addresses related to the ADC

		AREA ADC_ADR, DATA
		

ADC1			EQU 0x40012000		; address of ADC1
ADC_SR			EQU 0x40012000		; address of ADC_SR
ADC_CR1			EQU 0x40012004		; global address of ADC_CR1. ADC1 + CR1 offset (0x4)
ADC_CR2			EQU 0x40012008		; global address of ADC_CR2. ADC1 + CR2 offset (0x8)
ADC_DR			EQU 0x4001204C		; global address of ADC_DR. ADC1 + DR offset (0x4C)
ADC_SQR3		EQU 0x40012034		; global address of ADC_SQR3. ADC1 + SQR3 offset (0x34)

		END