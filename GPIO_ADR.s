; Amaar Ebrahim
; This file stores addresses related to the GPIO pins

		AREA GPIO_ADR, DATA

GPIOA		EQU 0X40020000		; address of GPIOA
GPIOB		EQU 0X40020400		; address of GPIOB
GPIOC		EQU 0X40020800		; address of GPIOC
GPIOD		EQU 0x40020C00		; address of GPIOD
GPIO_IDR	EQU 0X00000010		; offset of IDR from the base address
GPIO_ODR	EQU 0x00000014		; offset of ODR from the base address
RCC_AHB1ENR EQU 0x40023830     	; RCC base address + AHB1ENR offset
	
		END