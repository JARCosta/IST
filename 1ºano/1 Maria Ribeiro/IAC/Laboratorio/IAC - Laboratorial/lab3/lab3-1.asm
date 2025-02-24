; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-1.asm
; * Descrição: Exemplos de instruções simples no PEPE.
; *		       Ilustra igualmente o estilo de programação a usar em IAC.
; *
; *********************************************************************
    MOV R1, 5678H   ; constante de dois bytes
    ROR R1, 8       ; roda até o byte mudar de sítio
    MOV R2, 45H     ; constante de um byte
    ADD R1, R2      ; exemplo de adição
    MOV R3, R1      ; guarda resultado em R3
    MOV R6, 8       ; para ciclo de 8 iterações
ciclo:
    SHL R1, 1       ; desloca 1 bit para a esquerda
    SUB R6, 1       ; decrementa contador e afeta bits de estado
    JNZ ciclo       ; salta se ainda não tiver chegado a 0
    SHL R3, 8       ; deslocamento de 8 bits para a esquerda
    SUB R1, R3      ; o resultado dá sempre 0. Porquê?
fim:
    JMP fim         ; forma expedita de "terminar"

