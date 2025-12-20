; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo:    lab4.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *     Lê uma linha do teclado, verificando se há alguma tecla
; *     premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos portos de E/S de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 1       ; posição do bit correspondente à linha a testar (4)

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
espera_tecla:
    MOV  R1, LINHA     ; testar a linha 4 
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JZ   espera_tecla  ; se nenhuma tecla premida, repete
    SHL  R1, 4         ; coloca linha no nibble high
    OR   R1, R0        ; junta coluna (nibble low)
    MOVB [R4], R1      ; escreve linha e coluna nos displays
ha_tecla:
    MOV  R1, LINHA     ; testar a linha 4  (R1 tinha sido alterado)
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP  ciclo         ; repete ciclo

