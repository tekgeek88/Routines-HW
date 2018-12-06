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





            LEA     R0 MSG
            PUTS

            LEA     R0 NEWLINE
            PUTS



; Read a message from the console character by character
            LEA     R0, MSG
            PUTS
            LD      R1, INPUT_MESSAGE ; Let R1 be the starting address for the string to be stored

PROMPT      GETC
            STR     R0, R1, #0
            ADD     R1, R1, #1
            ADD     R0, R0, xFFF6   ; R0 <- R0 - New Line Char
END         BRnzp   PROMPT

; Display the string back to the console
            LD      R0, INPUT_MESSAGE
            PUTS




            halt



TYPE            .STRINGZ "(E)ncrypt / (D)ecrypt: "
KEY             .STRINGZ "Enter encrpytion key(1-9): "
MSG             .STRINGZ "Enter message (20 char limit): "
NEWLINE         .STRINGZ "\n"
KEYLOC          .FILL x3101
NEGASCI         .FILL #-48
INPUT_MESSAGE   .FILL x3102


            .end