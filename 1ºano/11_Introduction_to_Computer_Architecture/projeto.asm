; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descri��o: Exemplifica o acesso a um teclado.
; *            L� uma linha do teclado, verificando se h� alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos portos de E/S de 8 bits
; *       atrav�s da instru��o MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATEN��O: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto n�o altera o valor de 16 bits e permite distinguir n�meros de identificadores
DISPLAYS   EQU 0A000H  ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    EQU 0C000H  ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    EQU 0E000H  ; endere�o das colunas do teclado (perif�rico PIN)
LINHA1      EQU 1       ; linha a testar (1� linha, 0001b)
LINHA2      EQU 2       ; linha a testar (2� linha, 0010b)
LINHA3      EQU 4       ; linha a testar (3� linha, 0100b)
LINHA4      EQU 8       ; linha a testar (4� linha, 1000b)

; **********************************************************************
; * C�digo
; **********************************************************************
PLACE      0
inicio:		
; inicializa��es
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R4, DISPLAYS  ; endere�o do perif�rico dos displays

; corpo principal do programa
ciclo:
    MOV  R1, 0 
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays

espera_tecla:          ; neste ciclo espera-se at� uma tecla ser premida
    MOV  R1, LINHA1    ; testar a linha 1
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    CMP  R0, 0         ; h� tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA2    ; testar a linha 2
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    CMP  R0, 0         ; h� tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA3    ; testar a linha 3 
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    CMP  R0, 0         ; h� tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA4    ; testar a linha 4 
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    CMP  R0, 0         ; h� tecla premida?
    JZ   espera_tecla  ; se nenhuma tecla premida, repete

tecla_premida:
    MOV  R5, 0
    MOV  R6, 0                

loopL:
    ADD  R5, 1
    SHR  R1, 1
    CMP  R1, 0
    JNZ  loopL

    SUB  R5, 1
    MOV  R1, 4
    MUL  R5, R1

loopC:
    ADD  R6, 1
    SHR  R0, 1
    CMP  R0, 0
    JNZ  loopC

    SUB  R6, 1
    ADD  R5, R6
    MOVB [R4], R5
    
ha_tecla:              ; neste ciclo espera-se at� NENHUMA tecla estar premida
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    CMP  R0, 0         ; h� tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera at� n�o haver
    JMP  ciclo         ; repete ciclo

