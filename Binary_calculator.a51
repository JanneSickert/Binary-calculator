INPUT_1				EQU P0
INPUT_2				EQU P1
RESULT				EQU P2
D_ENTER				EQU P3.0
D_ADDITION			EQU P3.1
D_SUBSTRACTION		EQU P3.2
D_MULTIPLICATION	EQU P3.3
D_DIVISION			EQU P3.4
RESULT_TO_INPUT_1	EQU P3.5
LAST_RESULT			EQU P3.6
D_CARRY				EQU P3.7

ORG 0h
LJMP Main

Main:
	MOV R0, #30h
	MOV A, R0
	MOV R2, A
	CALL ClearPorts
	JMP Wait

ClearPorts:
	MOV P0, #0d
	MOV P1, #0d
	MOV P2, #0d
	MOV P3, #0d
RET

Wait:
	JB D_ENTER, Calculate
	JB RESULT_TO_INPUT_1, PutUp
	JB LAST_RESULT, ShowLast
	JMP Wait

Calculate:
	CLR D_ENTER
	MOV R3, #0d
	MOV A, R2
	MOV R0, A
	MOV R7, P3
	MOV R6, INPUT_1			;Storage INPUT_1
	MOV R5, INPUT_2			;Storage INPUT_2
		CJNE R7, #2d, Cal0
		JMP Addition
	Cal0:
		CJNE R7, #4d, Cal1
		JMP Substraction
	Cal1:
		CJNE R7, #8d, Cal2
		JMP Multiplication
	Cal2:
		CJNE R7, #16d, ModeError
		JMP Division
	ModeError:
		MOV P3, #255d
		CALL Delay
		MOV P3, #0d
		CALL Delay
		JMP ModeError

Delay:
	MOV R0, #255d
	DJ1:
		MOV R1, #255d
	DJ2:
		MOV R2, #255d
	DJ3:
		DJNZ R2, DJ3
		DJNZ R1, DJ2
		DJNZ R0, DJ1
RET

Addition:
	MOV A, R6
	ADD A, R5
	MOV @R0, A				;@R0 storage of result.
	JMP GetResult

Substraction:
	MOV A, R5
	SUBB A, R6
	MOV @R0, A
	JMP GetResult

Multiplication:
	MOV A, R6
	MOV B, R5
	MUL AB
	MOV @R0, A
	JMP GetResult

Division:
	MOV A, R6
	MOV B, R5
	DIV AB
	MOV @R0, A
	JMP GetResult

GetResult:
	JC SetCarry
	MOV RESULT, @R0
	INC R0
	MOV A, R0
	MOV R2, A
	LJMP Wait
	
SetCarry:
	SETB D_CARRY
	INC @R0
	MOV RESULT, @R0
	INC R0
	MOV A, R0
	MOV R2, A
	LJMP Wait

PutUp:
	CLR RESULT_TO_INPUT_1
	MOV R4, RESULT
	MOV RESULT, #0d
	MOV INPUT_1, R4
	LJMP Wait

ShowLast:
	CLR LAST_RESULT
	CJNE R0, #30h, Last
		JMP ErrorShowLast
	Last:
		CJNE R3, #0d, NextLast
		DEC R0
	CJNE R0, #30h, LLLL
		JMP ErrorShowLast
	LLLL:
		DEC R0
		MOV R3, #1d
		MOV RESULT, @R0
		LJMP Wait
	NextLast:
		DEC R0
		MOV RESULT, @R0
		LJMP Wait

ErrorShowLast:
	MOV A, #1d
	MOV R1, #0d
	Sesl:
		MOV RESULT, A
		LCALL Delay
		JB D_ENTER, JumpCalculate
		RL A
		INC R1
		CJNE R1, #7d, Sesl
		JMP ErrorShowLast

JumpCalculate:
	LJMP Calculate

END