; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-3.asm
; * Descrição: Exemplos de instruções de acesso à memória,
; *            em word e em byte.
; *
; *********************************************************************
    MOV R0, 0100H   ; endereço da célula de memória a aceder em word
    MOV R2, 1234H   ; constante de dois bytes
    MOV R3, 5678H   ; constante de dois bytes
    MOV [R0], R2    ; escreve uma word (16 bits) na memória
    MOV R1, 0110H   ; endereço da célula de memória a aceder em byte
    MOV R2, 1234H   ; constante de dois bytes
    MOVB [R1], R2   ; escreve um byte (8 bits) na memória (0110H)
    ADD R1, 1       ; endereço 0111H
    MOVB [R1], R3   ; escreve um byte (8 bits) na memória (0111H)
    MOV R1, 0110H   ; repõe endereço 0110H em R1
    MOV R4, [R1]    ; lê uma word (16 bits) da memória (endereço par)
    MOVB R5, [R1]   ; lê um byte (8 bits) da memória (0110H)
    ADD R1, 1       ; endereço 0111H
    MOVB R6, [R1]   ; lê um byte (8 bits) da memória (0111H)
fim:
    JMP fim         ; forma expedita de "terminar"
