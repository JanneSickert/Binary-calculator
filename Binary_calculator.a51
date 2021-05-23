INPUT_1				EQU P0
INPUT_2				EQU P1
RESULT				EQU P2
D_ENTER				EQU P3.0
D_ADDITION			EQU P3.1
D_SUBSTRACTION		EQU P3.2
D_MULTIPLICATION	EQU P3.3
D_DIVISION			EQU P3.4

ORG 0h
LJMP Main

Main:
	MOV R0, #30h
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
	JMP Wait

Calculate:
	CLR D_ENTER
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
	MOV RESULT, @R0
	LJMP Wait

END