;Cryptography Program
; Ethan Cheatham
; Carl Argabright
; TCSS 371

    
                    

; Bigin at x3000 and clear registers for storage
                    .orig x3000
                    AND     R2, R2, #0          ; R2 -> Encrypt/Decrypt character
                    AND     R3, R3, #0          ; R3 -> Encryption key


; Display (E)ncrypt / (D)ecrypt message and store the result
                    LEA     R0, PROMPT_TYPE     ; Load the message to be displayed
                    PUTS                    
                    GETC                         ; Get an E or a D from the user
                    STI     R0, INPUT_TYPE      ; Store the value into the register that INPUT_TYPE points to
                    OUT
                    LEA     R0, NEWLINE
                    PUTS
                    
            

; Get input for encryption key
                    LEA     R0, PROMPT_KEY      ; Load prompt message to be displayed
                    PUTS
                    GETC                        ; Gets a single digit 1-9
                    OUT
                    LD      R1, NEG_ASCI        ; Loads -48 into R1 to prepare our digit for math
                    ADD     R0, R0, R1          ; Add the input digit to -48
                    STI     R0, INPUT_KEY       ; Store the proper digit that was input into the INPUT_KEY variable
                    LEA     R0, NEWLINE         ; Print a new line
                    PUTS

; Display a prompt for the user to input a message
                    LEA     R0, PROMPT_MSG
                    PUTS
                    LD      R1, INPUT_MESSAGE   ; Loads the register location of the first character
  
; Get input from the user one character at a time
; continue until we recieve the return key as a character
; of the users input string to be encrypted or decrypted
AGAIN               GETC
                    ADD     R7, R0, #-10        ; If we have a newline char we end the loop
                    BRz     END
                    OUT
                    STR     R0, R1, #0          ; Stores the input char into the address that R1 points twos
                    ADD     R1, R1, #1          ; advance the string position pointer by one
                    
                    BRnzp    AGAIN               ; If a newline character was not found we continue
                                                ; to store characters into memory address that R1 points to
END                 AND R0, R0, #0              ; R0 <- NULL terminating chacter
                    STR     R0, R1, #0          ; Store the null terminating character at the end of the string.                  
                    LEA     R0, NEWLINE         ; Print a new line character
                    PUTS

; If E, encrypt
                    LD      R2, NEG_E           ; Load the value of -E into R2
                    LDI     R1, INPUT_TYPE      ; Load the operation type into R1
                    ADD     R1, R1, R2          ; Add R1 and R2 to see if they equal zero
                    BRz     ENCRYPT             ; Goto the line that calls the Encrypt subroutine
; else, decrypt
                    JSR     Decrypt_SR          ; JMP to the Decrypt subroutine
                    BRnzp   DISPLAY_RESULT      ; Display the result and end the program

ENCRYPT             JSR     Encrypt_SR          ; Jumps to the Encrypte subroutine



; Display output and halt the cpu
DISPLAY_RESULT      LD      R0, RESULT  ; Loads the result into R0
                    PUTS
                    halt

; Routines
; The ecrypt subroutine
Encrypt_SR
                    ST      R7, BACKUP_R7       ; Save the value of R7 into a register
                    LD      R1, INPUT_MESSAGE   ; Load the pointer to the beginning address of the source string
                    LDI     R4, INPUT_KEY       ; Load the encryption key into R4
                    LD      R6, RESULT          ; Load the pointer to the beginning address of the result string
ENCRYPT_LOOP        LDR     R3, R1, #0          ; Load the first character into R3
                    ADD     R7, R3, #0          ; Add 0 to the char to see if we are done
                    BRz     DONE_ENCRYPT

                    JSR     isOdd               ; If bit[0:0] is 1 (odd)
                    BRp     ENCRYPT_ODD         ; Replace it by a 0 (add -1)
                    ADD     R3, R3, 1           ; else bit[0:0] is 0 (even)
                    BRnzp   ADD_KEY             ; Replace it with a 1 (add 1)
ENCRYPT_ODD         ADD     R3, R3, #-1
ADD_KEY             ADD     R3, R3, R4          ; For all cases add the key
                    STR     R3, R6, #0          ; Store the result in the address pointed to by R6
                    ADD     R1, R1, #1          ; Increment R1 the character pointer
                    ADD     R6, R6, #1          ; Increment R6 the character pointer
                    BRnzp   ENCRYPT_LOOP        ; Continue encrypting until we reach the newline character

DONE_ENCRYPT        AND     R0, R0, #0          ; R0 <- NULL terminating chacter
                    STR     R0, R6, #0          ; Store the null terminating character at the end of the string.                  
                    LD      R7, BACKUP_R7       ; Load our return address into R7
                    RET                         ; JMP R7

; The Decrypt subroutine
Decrypt_SR
                    ST      R7, BACKUP_R7       ; Save the value of R7 into a register
                    LD      R1, INPUT_MESSAGE   ; Load the pointer to the beginning address of the source string
                    LDI     R4, INPUT_KEY       ; Load the encryption key into R4
                    NOT     R4, R4              ; Take the twos complement of the KEY so we can continue to add it
                    ADD     R4, R4, #1 
                    LD      R6, RESULT          ; Load the pointer to the beginning address of the result string

DECRYPT_LOOP        LDR     R3, R1, #0          ; Load the first character into R3
                    ADD     R7, R3, #0          ; Add 0 to the char to see if we are done
                    BRz     DONE_DECRYPT
SUBTRACT_KEY        ADD     R3, R3, R4          ; Subtract the key
                    JSR     isOdd               ; If bit[0:0] is 1 (odd)
                    BRp     DECRYPT_ODD         ; Replace it by a 0 (add -1)
DECRYPT_EVEN        ADD     R3, R3, 1           ; else bit[0:0] is 0 (even)
                    BRnzp   STORE_RESULT        ; Replace it with a 1 (add 1)
DECRYPT_ODD         ADD     R3, R3, #-1

STORE_RESULT        STR     R3, R6, #0          ; Store the result in the address pointed to by R6
                    ADD     R1, R1, #1          ; Increment R1 the character pointer
                    ADD     R6, R6, #1          ; Increment R6 the character pointer
                    BRnzp   DECRYPT_LOOP          ; Continue encrypting until we reach the newline character

DONE_DECRYPT        AND     R0, R0, #0          ; R0 <- NULL terminating chacter
                    STR     R0, R6, #0          ; Store the null terminating character at the end of the string.                  
                    LD      R7, BACKUP_R7       ; Load our return address into R7
                    RET                         ; JMP R7


; Source: Week 09 Subroutine slides
; Routine to determine whether a given number is even
; Input:  A number that is stored in register R3
; Output: R2 is set to 1 if the number is odd or 0 if it is even  
isOdd   
            AND     R2, R3, #1      ; Mask the last bit in the number
            RET

; Variables
PROMPT_TYPE             .STRINGZ "(E)ncrypt / (D)ecrypt: "
PROMPT_KEY              .STRINGZ "Enter encrpytion key(1-9): "
PROMPT_MSG              .STRINGZ "Enter message (20 char limit): "
NEWLINE                 .STRINGZ "\n"
NEG_ASCI                .FILL #-48  ; Offsets the decimal value of our ASCII to 
                                    ; regular integer values we can do math with.
NEG_E                   .FILL xFFBB ; -E

; Memory register locations
INPUT_TYPE      .FILL   x3100
INPUT_KEY       .FILL   x3101
INPUT_MESSAGE   .FILL   x3102   ; This needs to take up 20 regeisters + 1 for the termination
BACKUP_R7       .BLKW   1       ; Reserver one block of memory for when we need to save R7
RESULT          .FILL   x3117   ; (x3102 + 21 in base 10) gives us the next avaialbe space to save a value

                .END            ; Stop assembling!
