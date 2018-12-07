;Cryptography Program
; Ethan Cheatham
; Carl Argabright
; TCSS 371

	
            .orig x3000 ; Begin at x3000

;Storage
;R2 -> Encrypt/ Decrypt character
;R3 -> Encryption key


;Clear registers
            AND R2, R2, #0
            AND R3, R3, #0

;Display input messages and parse data:
;Encrypt/Decrypt
            LEA R0 TYPE
            PUTS
            GETC
            OUT
            LEA     R0, NEWLINE
            PUTS

;Encryption Key
            LEA     R0 KEY
            PUTS
            GETC
            OUT
            LD      R3, NEGASCI
            ADD     R3, R3, R0
            LEA     R0 NEWLINE
            PUTS

;Store key to x3101

            STI     R4, KEYLOC





; Read a message from the console character by character
          
	LEA R1, HELLO

AGAIN	LDR R2, R1, #0
	BRz NEXT
	ADD R1, R1, #1
	BR AGAIN

NEXT	LEA R0, MSG
	PUTS
	LD R3, NEGENTER

AGAIN2	GETC
	OUT
	ADD R2, R0, R3	
	BRz CONT
	STR R0, R1, #0
	ADD R1, R1, #1
	BR AGAIN2

CONT	AND R2, R2, #0
	STR R2, R1, #0



;Encryption Algorithm
ENCRYPT	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R5, R5, #0
	AND R4, R4, #0 
	AND R6, R6, #0

	LEA R2, HELLO ; gets address of value

	BRnzp ENCRYPTLOOP


ENCRYPTLOOP	

	

	LDR R3, R2, #0; interpret value at address, based on offset

	ADD R3, R3, #0 ; changes asci value by 0
	
	STR R3, R2, #0; stores value to location in memory
	
	LDR R0, R3, #0
	OUT
	LEA R0, NEWLINE
	PUTS


	ADD R4, R4, #1
	ADD R2, R2, #1
	
	;Determine if new line
	LD R5, NEGNEWLINE
	ADD R5, R5, R3

	BRnp ENCRYPTLOOP

	
	

	
ENCRYPTDONE
	LEA R0, HELLO
	PUTS
	LEA R0, NEWLINE
	PUTS
	


            halt



TYPE            .STRINGZ "(E)ncrypt / (D)ecrypt: "
KEY             .STRINGZ "Enter encrpytion key(1-9): "
MSG             .STRINGZ "Enter message (20 char limit): "
NEWLINE         .STRINGZ "\n"
HELLO 		.STRINGZ ""
		.BLKW #10
NEGNEWLINE 	.FILL #-10
KEYLOC          .FILL x3101
ASCI		.FILL X30
NEGASCI         .FILL #-48
INPUT_MESSAGE   .FILL x3102
NEGENTER 	.FILL xFFF6



            .end