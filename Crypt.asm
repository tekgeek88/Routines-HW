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
                    GETC                        ; Get an E or a D from the user
                    STI     R0, INPUT_TYPE      ; Store the value into the register that INPUT_TYPE points to
                    OUT
                    LEA     R0, NEWLINE
                    PUTS
                    
            

; Get input for encryption key
                    LEA     R0, PROMPT_KEY      ; Load prompt message to be displayed
                    PUTS
                    GETC                        ; Gets a single digit 1-9
                    OUT
                    LEA     R0, NEWLINE
                    PUTS
                    LD      R1, NEG_ASCI        ; Loads -48 into R1 to prepare our digit for math
                    ADD     R0, R0, R1          ; Add the input digit to -48
                    STI     R0, INPUT_KEY       ; Store the proper digit that was input into the INPUT_KEY variable

; Display a prompt for the user to input a message
                    LEA     R0, PROMPT_MSG
                    PUTS
                    LD      R1, INPUT_MESSAGE   ; Loads the register location of the first character
  
; Get input from the user one character at a time
; continue until we recieve the return key as a character
; of the users input string to be encrypted or decrypted
AGAIN               GETC
                    STR     R0, R1, #0          ; Stores the input char into R1 at the offset given by the following line
                    ADD     R1, R1, #1          ; Increment the offset of our strings position
                                                ; R1 <- M[R1 + 1]
                    ADD     R0, R0, xFFF6       ; Check our input for the new line character
                    BRnp    AGAIN               ; If a newline character was not found we continue
                                                ; to store characters into memory address that R1 points to
                    LD      R0, INPUT_MESSAGE   ; Load R0 with the first character of the string the user input
                    PUTS                        ; Display the string

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
Encrypt_SR
                    ST      R7, BACKUP_R7       ; Save the value of R7 into a register
                    LD      R1, INPUT_MESSAGE   ; Load the input message to be encrypted

            ; Ecryption happens here

                    LD      R7, BACKUP_R7       ; Load our return address into R7
                    RET                             ; JMP R7

Decrypt_SR
                    ST      R7, BACKUP_R7       ; Save the value of R7 into a register
                    LD      R1, INPUT_MESSAGE  

            ; Decryption happens here

                    LD      R7, BACKUP_R7       ; Load our return address into R7
                    RET                             ; JMP R7


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
