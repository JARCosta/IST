; **********************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)


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
    MOV  R1, 0 
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays
ciclo:
    MOV  R1, 1         ; Reset linhas        
    MOV  R7, 0
    MOV  R5, 0	
tecla:
    MOVB [R2],R1
	MOVB R0, [R3]      ; Adquire a coluna
	CMP  R0, 0         ; Sem valor?
	JNZ  ha_tecla      ; Se tiver temos coluna e linha
	MOV  R8, 8
	CMP  R1 , R8        ; Se já tiver no 8 e ainda não encontrou muda de linha
	JNZ  aumant_linha
	MOV	 R1, 1
	JMP  tecla	       ; Volta a repetir até acabar as colunas	
aumant_linha:
    SHL  R1,1          ; Anda para a linha 2 4 ou 8
	JMP  tecla         ;Volta a reiniciar
num:
	CMP  R0,1          ;Verifica se ja ta no 1
	JNZ  adici     
	CMP  R1,1          ;Verifica se ja ta no 1
    JNZ  adici_2
	JMP valr           ;Se ja tiverem os dois boa vamos ter o numero
adici:
	SHR  R0,1           ;Anda um bit para o lado da coluna
	ADD  R5,1           ;Add 1 ao R5 - contador de colunas
	JMP  num
adici_2:
	SHR  R1,1           ;Anda um bit para o lado da linha
	Add  R7,1           ;Add 1 ao R7 que é linha
	JMP  num
valr:	                ;Binario para Hexa
    MOV  R8,4
	MUL  R7,R8          ; linha x 4
	Add  R7,R5          ; linha x 4 + coluna
displays:
    MOVB [R4],R7
	JMP  ciclo
ha_tecla:
	MOVB [R2],R7
    MOVB  R6,[R3]       ;Botão da coluna clicado
	CMP   R6,0          ;Botao largado
	JNZ   ha_tecla     
	JMP   num