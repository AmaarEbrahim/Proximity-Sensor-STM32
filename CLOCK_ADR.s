; Amaar Ebrahim
; This file stores addresses related to the clock

		AREA CLOCK_ADR, DATA

RCC				EQU 0x40023800		; starting address of RCC
RCC_APB1ENR		EQU 0x40023840		; global location of RCC_APB1ENR. Equal to RCC + APB1ENR offset (which is 0x40)
RCC_APB2ENR		EQU 0x40023844		; global location of RCC_APB2ENR. Equal to RCC + APB2ENR offset (which is 0x44)
	

		END