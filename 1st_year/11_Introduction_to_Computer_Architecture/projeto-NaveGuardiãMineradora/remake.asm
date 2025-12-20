DEFINE_BACK     EQU 6042H
DEFINE_LINHA    EQU 600AH
DEFINE_COLUNA   EQU 600CH
DEFINE_COR      EQU 6014H
DEFINE_ECRA     EQU 6004H
APAGA_ECRA      EQU 6000H
ESCREVER        EQU 601AH
CINZENTO        EQU 0F888H
AZUL            EQU 0F06DH
VERMELHO        EQU 0FF00H
PRETO           EQU 0F000H
MISSIL          EQU 0FF0FH
VAZIO           EQU 0000H
TEC_LIN         EQU 0C000H
TEC_COL         EQU 0E000H
DISPLAYS        EQU 0A000H

PLACE     1000H
pilha:    TABLE 100H
fim_da_pilha:

tab:      WORD rot_int_0      ; rotina de atendimento da interrupção 0
          WORD rot_int_1      ; rotina de atendimento da interrupção 1
          WORD rot_int_2      ; rotina de atendimento da interrupção 2

NAVE:
    WORD VAZIO
	WORD CINZENTO
	WORD VAZIO
	WORD CINZENTO
	WORD VAZIO
	
    WORD CINZENTO
	WORD CINZENTO
	WORD AZUL
	WORD CINZENTO
	WORD CINZENTO
	
	WORD CINZENTO
	WORD CINZENTO
	WORD AZUL
	WORD CINZENTO
	WORD CINZENTO
	
    WORD CINZENTO
	WORD CINZENTO
	WORD CINZENTO
	WORD CINZENTO
	WORD CINZENTO
	
    WORD VAZIO
	WORD CINZENTO
	WORD CINZENTO
	WORD CINZENTO
	WORD VAZIO

TAB_ASTEROID:
    WORD OVNI_ASTEROID_2x2
	WORD ASTEROID_3x3
	WORD ASTEROID_4x4
	WORD ASTEROID_5x5
	
TAB_OVNI:
    WORD OVNI_ASTEROID_2x2
	WORD OVNI_3x3
	WORD OVNI_4x4
	WORD OVNI_5x5

OVNI_ASTEROID_2x2:
    WORD CINZENTO
	WORD CINZENTO
	
	WORD CINZENTO
	WORD CINZENTO
	
ASTEROID_3x3:
    WORD AZUL
	WORD AZUL
	WORD VAZIO
	
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
	WORD VAZIO
	WORD AZUL
	WORD AZUL
	
ASTEROID_4x4:
    WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD VAZIO
	
    WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
	WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
	WORD VAZIO
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
ASTEROID_5x5:
    WORD VAZIO
	WORD AZUL
	WORD AZUL
	WORD VAZIO
	WORD VAZIO
	
    WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD VAZIO
	
	WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
	WORD VAZIO
	WORD AZUL
	WORD AZUL
	WORD AZUL
	WORD AZUL
	
	WORD VAZIO
	WORD VAZIO
	WORD AZUL
	WORD AZUL
	WORD VAZIO

OVNI_3x3:
    WORD VERMELHO
	WORD VAZIO
	WORD VERMELHO
	
    WORD VERMELHO
	WORD PRETO
	WORD VERMELHO
	
	WORD PRETO
	WORD VAZIO
	WORD PRETO

OVNI_4x4:
    WORD PRETO
	WORD VERMELHO
	WORD VAZIO
	WORD PRETO
	
	WORD PRETO
	WORD VERMELHO
	WORD VERMELHO
	WORD PRETO
	
	WORD PRETO
	WORD PRETO
	WORD VERMELHO
	WORD PRETO
	
	WORD PRETO
	WORD VAZIO
	WORD PRETO
	WORD PRETO

OVNI_5x5:
    WORD PRETO
	WORD VERMELHO
	WORD VAZIO
	WORD VERMELHO
	WORD PRETO
	
    WORD PRETO
	WORD VERMELHO
	WORD VERMELHO
	WORD VERMELHO
	WORD PRETO
	
    WORD PRETO
	WORD VERMELHO
	WORD PRETO
	WORD VERMELHO
	WORD PRETO
	
    WORD PRETO
	WORD VERMELHO
	WORD VAZIO
	WORD VERMELHO
	WORD PRETO
	
    WORD VAZIO
	WORD PRETO
	WORD VAZIO
	WORD PRETO
	WORD VAZIO

ECRA:
    WORD 1
	WORD 2
	WORD 3
	WORD 4

PLACE 0

    MOV  BTE, tab
    MOV  SP, fim_da_pilha
	EI0
	EI1
	EI2
	EI

    MOV  R0, DEFINE_BACK
	MOV  R1, 0
	MOV  [R0], R1
	MOV  R4, 0
	push R4

update:
    pop  R4
    ADD  R4, 1
	push R4
    push R1
	push R2
	CALL conversor
	CALL missil_escreve

;
; em teclado:, corre o codigo para observar o input das teclas 1, 2, 3, c, d
;

teclado:
    MOV  R0, TEC_LIN
	MOV  R1, TEC_COL
    MOV  R2, 1				; celeciona a 1ª linha do teclado
    MOVB [R0], R2
	MOVB R2, [R1]
	CMP  R2, 1				; na primeira linha, quando a primeira coluna é precionada
	JZ   nave_esquerda		; executa os comandos para mover a nave para a esquerda (tecla 1)
	CMP  R2, 2				; verifica se a a tecla 2 esta a ser premida
	JZ   missil				; se sim, disparar missil
	CMP  R2, 4				; quando a tecla 3 esta a ser premida:
	JZ   nave_direita		; mover a a nave para a direita
	MOV  R2, 8				; observar a 4ª linha (teclas C, D, E, F)
    MOVB [R0], R2			
	MOVB R2, [R1]			
	CMP  R2, 1				; observa a tecla C
	JZ   game_start			; executa os comandos para começar a jogar
	CMP  R2, 2				; observa a D
	CMP  R2, 4				; observa a E
	pop  R2
	pop  R1
	JMP  update

game_start:					; depois de clicar C
    pop  R2
	pop  R1
    MOV  R0, DEFINE_BACK	;----
	MOV  R1, 1				;celeciona o 1º ecrã
	MOV  [R0], R1			;----
    CALL inicio_display
	CALL nave
	JMP  update

nave_esquerda:
    pop  R2
	pop  R1
	CMP  R10, 0
	JZ   update
	MOV  R7, 0
	MOV  R3, NAVE
	MOV  R6, 5
	CALL escrever_apagar
	SUB  R1, 1
	MOV  R7, 1
	MOV  R3, NAVE
	MOV  R6, 5
	CALL escrever_apagar
	MOV  R3, 1000H
delay_e:
	SUB  R3, 1
	JNZ  delay_e
	JMP  update
	
nave_direita:
    pop  R2					; obtem a posição da nave
	pop  R1					; "
	CMP  R10, 0
	JZ   update
	MOV  R7, 0				
	MOV  R3, NAVE			
	MOV  R6, 5
	CALL escrever_apagar	; depois de alterar a posição da nave, move-a
	ADD  R1, 1
	MOV  R7, 1
	MOV  R3, NAVE
	MOV  R6, 5
	CALL escrever_apagar
	MOV  R3, 1000H
delay_d:
	SUB  R3, 1
	JNZ  delay_d
	JMP  update
	
missil:
    pop  R2
	pop  R1
	CMP  R10, 0
	JZ   update
    CMP  R11, 0
	JNZ  update
	SUB  R10, 5
	MOV  R9, R1
	MOV  R11, R2
	ADD  R9, 2
	JMP  update
    
missil_escreve:
    MOV  R6, R11
    CMP  R6, 0
	JZ   missil_escreve_ret
	MOV  R0, DEFINE_COLUNA
	MOV  [R0], R9
	MOV  R0, DEFINE_LINHA
	MOV  [R0], R6
	MOV  R0, ESCREVER
	MOV  R7, 0
	MOV  [R0], R7
	SUB  R6, 1
	MOV  R7, 14
	CMP  R6, R7
	JNZ  missil_escreve2
	MOV  R11, 0
	JMP  missil_escreve_ret
missil_escreve2:
	MOV  R0, DEFINE_COLUNA
	MOV  [R0], R9
	MOV  R0, DEFINE_LINHA
	MOV  [R0], R6
	MOV  R0, DEFINE_COR
	MOV  R7, MISSIL
	MOV  [R0], R7
	MOV  R0, ESCREVER
	MOV  R7, 1
	MOV  [R0], R7
missil_escreve_ret:
	RET

nave:
    MOV  R1, 30
	MOV  R2, 27
	MOV  R7, 1
	MOV  R3, NAVE
	MOV  R6, 5
	CALL escrever_apagar
	RET

escrever_apagar:
    MOV  R4, R6
	push R2
escrever_apagar_l:				;
    MOV  R5, R6
    CMP  R4, 0
	JZ   escrever_apagar_fim
    MOV  R0, DEFINE_LINHA
	MOV  [R0], R2
	push R1
escrever_apagar_c:
    CMP  R5, 0
	JZ   nova_linha
	MOV  R0, DEFINE_COLUNA
	MOV  [R0], R1
	MOV  R0, DEFINE_COR
	push R6
	MOV  R6, [R3]
	MOV  [R0], R6
	pop  R6
	MOV  R0, ESCREVER
	MOV  [R0], R7
	ADD  R1, 1
	ADD  R3, 2
	SUB  R5, 1
	JMP  escrever_apagar_c
nova_linha:
    pop  R1
	ADD  R2, 1
	SUB  R4, 1
	JMP  escrever_apagar_l
escrever_apagar_fim:
    pop  R2
	RET

inicio_display:
    MOV  R10, 100
conversor:
    MOV  R0, DISPLAYS
    MOV  R3, 10
	MOV  R4, 10H
    MOV  R2, R10
	push R2
	DIV  R2, R3
	CMP  R2, R3
	JNZ  conversor2
	MOV  R1, 100H
	pop  R2
	JMP update_display
conversor2:
	MUL  R2, R4
	MOV  R1, R2
	pop  R2
	MOD  R2, R3
	ADD  R1, R2
update_display:
	MOV  [R0], R1
	RET

rot_int_0:
    ADD  R8, 1
    RFE
	
rot_int_1:
    CMP  R11, 0
	JZ   rot_int_1_ret
    SUB  R11, 1
rot_int_1_ret:
    RFE
	
rot_int_2:
    CMP  R10, 0
	JZ   rot_int_2_ret
    SUB  R10, 5
rot_int_2_ret:
    RFE
	

    