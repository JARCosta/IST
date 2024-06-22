; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-3.asm
; * Descri��o: Exemplos de instru��es de acesso � mem�ria,
; *            em word e em byte.
; *
; *********************************************************************
    MOV R0, 0100H   ; endere�o da c�lula de mem�ria a aceder em word
    MOV R2, 1234H   ; constante de dois bytes
    MOV R3, 5678H   ; constante de dois bytes
    MOV [R0], R2    ; escreve uma word (16 bits) na mem�ria
    MOV R1, 0110H   ; endere�o da c�lula de mem�ria a aceder em byte
    MOV R2, 1234H   ; constante de dois bytes
    MOVB [R1], R2   ; escreve um byte (8 bits) na mem�ria (0110H)
    ADD R1, 1       ; endere�o 0111H
    MOVB [R1], R3   ; escreve um byte (8 bits) na mem�ria (0111H)
    MOV R1, 0110H   ; rep�e endere�o 0110H em R1
    MOV R4, [R1]    ; l� uma word (16 bits) da mem�ria (endere�o par)
    MOVB R5, [R1]   ; l� um byte (8 bits) da mem�ria (0110H)
    ADD R1, 1       ; endere�o 0111H
    MOVB R6, [R1]   ; l� um byte (8 bits) da mem�ria (0111H)
fim:
    JMP fim         ; forma expedita de "terminar"
