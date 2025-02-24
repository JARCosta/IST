;************************************************************************************
; 				Fun��o de cada tecla
; 0 - diminui o valor nos displays em regime cont�nuo
; 1 - diminui o valor nos displays uma vez por clique
; 2 - aumenta o valor nos displays uma vez por clique
; 3 - aumenta o valor nos displays em regime cont�nuo
;
;*************************************************************************************

DISPLAYS   EQU 0A000H   ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    EQU 0C000H   ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    EQU 0E000H   ; endere�o das colunas do teclado (perif�rico PIN)

PLACE 1000H

pilha: TABLE 100H		;cria a pilha para a utiliza��o das rotinas: conversor e continuo
fim_pilha:

PLACE      0

inicio:		
; inicializa��es
    MOV  R2, TEC_LIN    ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL    ; endere�o do perif�rico das colunas
    MOV  R4, DISPLAYS   ; endere�o do perif�rico dos displays
	MOV  SP, fim_pilha	; move o step pointer para poder iniciar o registo de mudan�as na pilha

;********************************************************************************
; Nos seguintes registos s�o escritos v�rios valores utilizados pelo conversor
;********************************************************************************
    MOV  R6, 100
	MOV  R7, 100H
	MOV  R8, 10
	MOV  R9, 10H
	
    MOV  R5, 0
    MOV [R4], R5		; escreve a linha e a coluna a 0 nos displays
	MOV  R5, 1000		; para n�o haver erro ao subtrair 1 ao valor inicial nos displays, inicia-se o programa com 1000, devido a todos os m�ltiplos de 1000 serem equivalentes a 0, nos displays
	
; corpo principal do programa

espera_tecla:           ; neste ciclo espera-se at� uma tecla ser premida
    MOV  R1, 1          ; testar a linha 1
    MOVB [R2], R1       ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]       ; ler do perif�rico de entrada (colunas)
    CMP  R0, 1         	; verifica de a tecla 0 est� a ser premida
	JZ   a				; quando a tecla 0 for premida executar as linhas do programa "a"
	CMP  R0, 2			; verifica de a tecla 1 est� a ser premida
	JZ   b				; quando a tecla 1 for premida executar as linhas do programa "b"
	CMP  R0, 4			; verifica de a tecla 2 est� a ser premida
	JZ   c				; quando a tecla 2 for premida executar as linhas do programa "c"
	CMP  R0, 0			; verifica de a tecla 3 est� a ser premida
	JNZ  d				; quando a tecla 3 for premida executar as linhas do programa "d"
    JMP  espera_tecla   ; se nenhuma tecla premida, continua � procura de uma tecla premida

;*********************************************************************************************************************
;As seguintes linhas de comando (a:, b:, c:, e d:) s�o executadas para alterar o numero representado no contador
; - a:  diminui varias vezes o valor, varia em fun��o do tempo premido
; - b:  diminui, mas apenas 1 vez por clique
; - c:  aumenta o valor do contador, 1 unidade por clique
; - d:  aumenta o numer�rio apresentado. Assim como a:, o valor alterado varia dependendo do tempo pressionado na tecla
;*********************************************************************************************************************

a:
    SUB  R5, 1			; subtrai uma unidade ao contador
    CALL continuo		; chama a rotina que provoca o delay entre a mudan�a de valor
	CMP  R0, 0			; analisa o estado da tecla, caso esteja premida, mantem a: ativo
	JNZ  a				; continua a aumentar o valor enquanto a tecla continuar a ser premida
	JMP  espera_tecla	; depois de soltar a tecla, procurar por um novo input

b:
    SUB  R5, 1			; subtrai uma unidade ao contador
	JMP por_clique		; executa as linhas do programa denominadas por_clique:
	
c:
    ADD  R5, 1			; aumenta uma unidade ao contador
	JMP por_clique		; executa as linhas do programa denominadas por_clique:

d:
    ADD  R5, 1			; adiciona uma unidade ao contador
    CALL continuo		; chama a rotina que provoca o delay entre a mudan�a de valor
	CMP  R0, 0			; analisa o estado da tecla, caso esteja premida, mantem d: ativo
	JNZ  d				; continua a aumentar o valor enquanto a tecla continuar a ser premida
	JMP  espera_tecla	; quando a tecla j� n�o estiver a ser premida recua para procurar um novo input

por_clique:				;
    CALL conversor		; chama a rotina para converter o valor hexadecimal recebido, em decimal
	MOV  [R4], R1		; escreve o valor em decimal nos displays
loop:
	MOVB R0, [R3]		; l� do perif�rico de entrada (colunas)
	CMP  R0, 0			; h� tecla premida?
	JNZ  loop			; se ainda houver tecla premida, espera at� n�o haver
	JMP  espera_tecla	; quando a tecla j� n�o estiver a ser premida recua para procurar um novo input

;*******************************************ROTINAS*****************************************************

conversor:				; nesta rotina s�o convertidos o valores de hexadecimal (linguagem utilizada pelo processador) para decimal(linguagem mostrada pelo contador para facilitar o uso do utilizador)
	PUSH R5				
	PUSH R5				
	PUSH R5				; escreve na pilha o valor de hexadecimal a ser convertido
	MOV  R1, 1000		; impede que valores superiores a 999 apare�am nos displays
	
	MOD  R5, R1			;*******************************************************************
    DIV  R5, R6			; Determina a quantidade de centenas decimais, no valor hexadecimal
	MUL  R5, R7			;
	MOV  R1, R5			;*******************************************************************

    POP  R5				;*******************************************************************
	MOD  R5, R6			; 
	DIV  R5, R8			; Determina a quantidade de dezenas decimais, no valor hexadecimal
	MUL  R5, R9			; 
	ADD  R1, R5			;*******************************************************************
	
    POP  R5				;*******************************************************************
	MOD  R5, R8			; Determina a quantidade de unidades decimais, no valor hexadecimal
	ADD  R1, R5			;*******************************************************************
	
	POP  R5				;************************************************************************************************************************************
	CMP  R1, 0			;
	JNZ  jump			; Para n�o haver erro ao subtrair 1 ao valor inicial nos displays,
	MOV  R5, 1000		; sempre que o valor nos displays for 0 altera o valor hexadecimal utilizado pelo programa para 3E8H (1000 em decimal)
jump:					;
	RET					;************************************************************************************************************************************


continuo:				; enquanto a tecla estiver premida, aumenta o valor nos displays
	CALL conversor		; chama a rotina para converter o valor hexadecimal recebido, em decimal
	MOV  [R4], R1		; escreve o valor em decimal nos displays
	MOV  R1, 5FFFH		; define o tempo de delay entre mudan�a de valores quando a tecla se encontra premida
delay:
	SUB  R1, 1			; diminui o valor anterior at� 0
	JNZ  delay			; apenas depois do valor anterior chegar a 0, aumentar valor do display em 1 unidade
	MOVB R0, [R3]		; l� do perif�rico de entrada (colunas)
	RET