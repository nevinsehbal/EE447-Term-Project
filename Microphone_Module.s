NVIC_ST_CTRL 	EQU 0xE000E010
SAMPLE_ADDR 		EQU 0x20000400
SAMPLE_ADDR_MAG 		EQU 0x20000404
MAGNITUDE_AND_FREQ_ADDR			EQU 0x20000810
			
			AREA  Microphone_Module, READONLY, CODE
			THUMB
			EXTERN		arm_cfft_q15
			EXTERN		arm_cfft_sR_q15_len256
			;EXTERN 		find_magnitude
			EXTERN Convrt
			EXTERN OutStr
			EXTERN Blink_Led
			EXTERN Disp_Frequency
			EXTERN Disp_Amplitude
			;EXPORT MicrophoneModule
			EXPORT Find_Magnitude
			EXPORT FFT_Calculator

Find_Magnitude PROC
			PUSH{LR,R0-R8}
			MOV R9,#0
			MOV R6,#127 ; counter
			MOV R7,#0 ;maxval --> will be compared with R8
			LDR R0,=SAMPLE_ADDR_MAG
loop_mag	LDR R1, [R0];real
			LDR R2, [R0],#4;imaginary
			LSR R2, #16
			MOV R3,#0x0000FFFF
			AND R1, R3
			NOP
			B check_real

check_real			
			MOV R3,#0x00008000
			CMP R1,R3
			BHI negative_real	
positive_real			
			MUL R1, R1, R1  ;finding magnitude
			B check_imag
negative_real		MOV R3,#0x0000FFFF
			EOR R1,R3
			ADD R1,#1
			MUL R1,R1,R1
			B check_imag
			
check_imag	
			MOV R3,#0x00008000
			CMP R2,R3
			BHI negative_imag
positive_imag	
			MUL R2,R2,R2
			B finish	
negative_imag  MOV R3,#0x0000FFFF
			EOR R2,R3
			ADD R2,#1
			MUL R2,R2,R2
			B finish

finish		ADD R8,R1,R2
			CMP R8,R7
			MOVHI R7,R8 ;holds the max magnitude
			MOVHI R9,R6 ; holds the counter of max mag
			SUBS R6,#1
			BNE loop_mag
			BL Disp_Amplitude
			
finish_mag_finding	MOV R3,#127 ;burada index ters halde
			SUB R9,R3,R9; burada indexi bulduk
			;ADD R9,#1
			MOV R3,#2000
			MUL R9,R9,R3 ; burada index*2kHZ
			MOV R3,#256
			UDIV R9,R9,R3 ; burada index*2kHz/256 = max_mag_Frekans
			
			BL Disp_Frequency		;updates frequency 
					;LDR R5,=0x20000400
					;MOV R4,R9
					;BL Convrt
					;BL OutStr
					;LDR R5,=0x20000400
					;MOV R4,R7;R4 IS THE AMPLITUDE
					;BL Convrt
					;BL OutStr
			LDR R0,=MAGNITUDE_AND_FREQ_ADDR
			STR R7,[R0],#4	
			STR R9,[R0]
			BL Blink_Led
			POP{LR,R0-R8}
			BX LR
			ENDP
				
FFT_Calculator PROC
			PUSH{LR,R2,R3}
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#0
			STR R0,[R1]
			LDR	R0, =arm_cfft_sR_q15_len256
			LDR	R1, =SAMPLE_ADDR
			MOV R2, #0
			MOV R3, #1
			BL arm_cfft_q15
			BL Find_Magnitude
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#3
			STR R0,[R1]
			POP {LR,R2,R3}
			BX LR
			ENDP

			ALIGN
			END