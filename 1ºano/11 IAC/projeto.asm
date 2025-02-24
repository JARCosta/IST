; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos portos de E/S de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA1      EQU 1       ; linha a testar (1ª linha, 0001b)
LINHA2      EQU 2       ; linha a testar (2ª linha, 0010b)
LINHA3      EQU 4       ; linha a testar (3ª linha, 0100b)
LINHA4      EQU 8       ; linha a testar (4ª linha, 1000b)

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays

; corpo principal do programa
ciclo:
    MOV  R1, 0 
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOV  R1, LINHA1    ; testar a linha 1
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA2    ; testar a linha 2
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA3    ; testar a linha 3 
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  tecla_premida ;

    MOV  R1, LINHA4    ; testar a linha 4 
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
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
    
ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP  ciclo         ; repete ciclo

