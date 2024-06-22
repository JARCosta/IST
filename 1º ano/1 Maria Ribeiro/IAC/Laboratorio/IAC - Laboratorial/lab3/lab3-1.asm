; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-1.asm
; * Descri��o: Exemplos de instru��es simples no PEPE.
; *		       Ilustra igualmente o estilo de programa��o a usar em IAC.
; *
; *********************************************************************
    MOV R1, 5678H   ; constante de dois bytes
    ROR R1, 8       ; roda at� o byte mudar de s�tio
    MOV R2, 45H     ; constante de um byte
    ADD R1, R2      ; exemplo de adi��o
    MOV R3, R1      ; guarda resultado em R3
    MOV R6, 8       ; para ciclo de 8 itera��es
ciclo:
    SHL R1, 1       ; desloca 1 bit para a esquerda
    SUB R6, 1       ; decrementa contador e afeta bits de estado
    JNZ ciclo       ; salta se ainda n�o tiver chegado a 0
    SHL R3, 8       ; deslocamento de 8 bits para a esquerda
    SUB R1, R3      ; o resultado d� sempre 0. Porqu�?
fim:
    JMP fim         ; forma expedita de "terminar"

