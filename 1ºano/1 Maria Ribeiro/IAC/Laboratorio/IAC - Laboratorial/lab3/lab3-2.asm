; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-2.asm
; * Descrição: Exemplos de instruções simples no PEPE.
; *		Ilustra igualmente o estilo de programação a usar em IAC.
; *
; *********************************************************************
    MOV R1, 4356H   ; constante de dois bytes
    MOV R2, 21H     ; constante de um byte
    SUB R1, R2      ; exemplo de subtração
    MOV R5, 00FFH   ; máscara
    AND R1, R5      ; elimina bits 8 a 15
    XOR R1, R5      ; nega os bits 0 a 7
    MOV R4, 0H      ; inicializa R4
ciclo:
    MOV R6, 01H     ; máscara
    AND R6, R1      ; força a 0 todos menos o bit de menor peso
    JZ  salta       ; salta se for 0
    ADD R4, 1       ; se não der zero adiciona 1
salta:
    SHR R1, 1       ; deslocamento de um bit a direita
    JNZ ciclo       ; salta se ainda não tiver chegado a 0
fim:
    JMP fim         ; forma expedita de "terminar"

