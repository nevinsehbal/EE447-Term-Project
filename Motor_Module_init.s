

;PORTF(0,4) config & PORTD(0,1,2,3) Config & GPTM(Timer0A) Config

;GPIO Registers


GPIO_PORTD_DATA		EQU 0x4000703C ; Access BIT2
GPIO_PORTD_DIR 		EQU 0x40007400 ; Port Direction
GPIO_PORTD_AFSEL	EQU 0x40007420 ; Alt Function enable
GPIO_PORTD_DEN 		EQU 0x4000751C ; Digital Enable

;GPIO_PORTF_DATA		EQU 0x40025044 ; Access BIT 0&4
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_PUR		EQU 0x40025510 ; PullDown
GPIO_PORTF_IS		EQU 0x40025404 ; Interrupt
GPIO_PORTF_IBE		EQU 0x40025408 ; Interrupt
GPIO_PORTF_IEV		EQU 0x4002540C ; Interrupt
GPIO_PORTF_IM		EQU 0x40025410 ; Interrupt
;GPIO_PORTF_RIS		EQU 0x40025414 ; Interrupt Status
;GPIO_PORTF_ICR		EQU 0x4002541C ; Interrupt Clear
GPIO_PORTF_LOCK 	EQU 0x40025520	
GPIO_PORTF_OCR		EQU	0x40025524

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

;Nested Vector Interrupt Controller registers
;NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register

; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register

;Additional Addresses
FREQ_ADR	EQU	0x20000814

			AREA   initialization4, READONLY, CODE
			THUMB
			EXPORT MotorModule_init 


MotorModule_init PROC
			PUSH{R0-R2}
PORTF_04_SwitchConfig
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x20 ; set bit 3,5 for port D, F
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR 	R1 , =GPIO_PORTF_LOCK	;unlock
			LDR 	R0 , [ R1 ]
			MOV32 	R0 , #0x4C4F434B
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_OCR	;give acces to write enable
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x1
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_DIR 
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11 ;F0,F4 input
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_AFSEL
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11 ; No Afsel F0,F4
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_DEN
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11 ; Digital enabled F0,F4
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_PUR
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11 ; PUR F0,F4
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IS
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11 ; Interrupt select default
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IBE
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11 
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IEV
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11	;trigger in falling edge
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IM
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11	;trigger in falling edge
			STR 	R0 , [ R1 ] 
			
			LDR R1, =NVIC_EN0
			LDR	R0, [R1]
			ORR R0, #0x40000000 ; GPIO PortF interrupts on
			STR R0, [R1]
			CPSIE  I

PORTD_0123_MotorConfig
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3,5 for port D, F
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR 	R1 , =GPIO_PORTD_DIR 
			LDR 	R0 , [ R1 ]
			MOV 	R0 , #0x0F ; Output
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_AFSEL
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x0F ; No Afsel
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_DEN
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x0F ; Digital Enabled
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_DATA
			LDR 	R0 , [ R1 ]
			BIC     R0,#0xFF ; Initially 1 is written
			ORR 	R0 , #0x01
			STR 	R0 , [ R1 ]

GPTM_Timer0A_Config
			LDR R1, =SYSCTL_RCGCTIMER ; Start Timer0
			LDR R2, [R1]
			ORR R2, R2, #0x01
			STR R2, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			LDR R1, =TIMER0_CTL ; disable timer during setup 
			LDR R2, [R1]
			BIC R2, R2, #0x01
			STR R2, [R1]
			LDR R1, =TIMER0_CFG ; set 16 bit mode
			MOV R2, #0x04
			STR R2, [R1]
			LDR R1, =TIMER0_TAMR
			MOV R2, #0x02 ; set to periodic, count down
			STR R2, [R1]
			;LDR R1, =TIMER0_TAILR ; initialize match clocks
			;LDR R2, =FREQ_ADR
			;LDR	R2, [R2]
			;STR R2, [R1]
			LDR R1, =TIMER0_TAPR
			MOV R2, #15 ; divide clock by 16 to
			STR R2, [R1] ; get 1us clocks
			LDR R1, =TIMER0_IMR ; enable timeout interrupt
			MOV R2, #0x01
			STR R2, [R1]
			
; Configure interrupt priorities
; Timer0A is interrupt #19.
; Interrupts 16-19 are handled by NVIC register PRI4.
; Interrupt 19 is controlled by bits 31:29 of PRI4.
; set NVIC interrupt 19 to priority 2
			LDR R1, =NVIC_PRI4
			LDR R2, [R1]
			AND R2, R2, #0x00FFFFFF ; clear interrupt 19 priority
			ORR R2, R2, #0x40000000 ; set interrupt 19 priority to 2
			STR R2, [R1]
; NVIC has to be enabled
; Interrupts 0-31 are handled by NVIC register EN0
; Interrupt 19 is controlled by bit 19
; enable interrupt 19 in NVIC
			LDR R1, =NVIC_EN0
			LDR R0,[R1]
			MOVT R2, #0x08 ; set bit 19 to enable interrupt 19
			STR R2, [R1]
; Enable timer
			LDR R1, =TIMER0_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03 ; set bit0 to enable
			STR R2, [R1] ; and bit 1 to stall 
				
			POP{R0-R2}
			BX LR
			ENDP
			ALIGN
			END