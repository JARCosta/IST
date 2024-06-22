; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab3-2.asm
; * Descri��o: Exemplos de instru��es simples no PEPE.
; *		Ilustra igualmente o estilo de programa��o a usar em IAC.
; *
; *********************************************************************
    MOV R1, 4356H   ; constante de dois bytes
    MOV R2, 21H     ; constante de um byte
    SUB R1, R2      ; exemplo de subtra��o
    MOV R5, 00FFH   ; m�scara
    AND R1, R5      ; elimina bits 8 a 15
    XOR R1, R5      ; nega os bits 0 a 7
    MOV R4, 0H      ; inicializa R4
ciclo:
    MOV R6, 01H     ; m�scara
    AND R6, R1      ; for�a a 0 todos menos o bit de menor peso
    JZ  salta       ; salta se for 0
    ADD R4, 1       ; se n�o der zero adiciona 1
salta:
    SHR R1, 1       ; deslocamento de um bit a direita
    JNZ ciclo       ; salta se ainda n�o tiver chegado a 0
fim:
    JMP fim         ; forma expedita de "terminar"

