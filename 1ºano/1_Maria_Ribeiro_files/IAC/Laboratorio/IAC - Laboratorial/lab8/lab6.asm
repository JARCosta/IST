; *********************************************************************************
; *
; * IST-UL
; *
; *********************************************************************************
; *********************************************************************************
; *
; * Modulo:    lab6.asm
; * Descrição: Este é um programa simples de teste dos processos cooperativos.
; *	    O display de 7 segmentos conta sozinho enquanto se estiver a 
; *	    carregar no botão. P1 lê o botão e liga uma variável de 
; *	    comunicação (R7) com o processo P2. P2 monitoriza o sinal dado 
; *	    pelo RTC (Real Time Clock) e incrementa o display se R7 o indicar.
; *	    Os processos são programados de forma independente (usando apenas a 
; *	    variável para comunicar).
; *	    O estado do processo P1 é mantido no R5 e o do processo P2 no R6.
; *	    O registo R8 é usado como contador.
; *	    Em vez dos registos R5, R6, R7 e R8 poder-se-iam usar variáveis 
; *	    de memória (método mais geral).
; *
; * Nota: Utilização de variáveis de estado para manter o estado de cada 
; *	      processo entre chamadas consecutivas.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
ON      EQU 1       ; contagem ligada
OFF     EQU 0       ; contagem desligada
INPUT   EQU 8000H   ; endereço do porto de entrada (bit 0 = RTC; bit 1 = botão)
OUTPUT  EQU 8000H   ; endereço do porto de saída. No mesmo endereço
                    ; que o porto de entrada, mas como estes portos
                    ; usam operações diferentes (leitura e escrita) 
                    ; não há conflito

; *********************************************************************************
; * Stack 
; *********************************************************************************
PLACE       1000H
pilha:      TABLE 100H     ; espaço reservado para a pilha 
fim_pilha:				

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0

inicio:
    MOV  R9, INPUT         ; endereço do porto de entrada
    MOV  R10, OUTPUT       ; endereço do porto de saÌda
    MOV  SP, fim_pilha
    MOV  R5, 1             ; inicializa estado do processo P1
    MOV  R6, 1             ; inicializa estado do processo P2
    MOV  R8, 0             ; inicializa contador
    MOV  R7, OFF           ; inicialmente não permite contagem do display

ciclo:
    CALL P1                ; invoca processo P1
    CALL P2                ; invoca processo P2
    JMP  ciclo             ; repete ciclo

; *********************************************************************************
; * ROTINAS
; *********************************************************************************

;* -- Processo P1 -----------------------------------------------------------------
;* 
;* Descrição: Trata do botão 
;*
;* Parâmetros:  --
;* Retorna:     R7 - ON, se botão premido e OFF, no caso contrário.  
;* Destrói:     R0
;* Notas: Não há parâmetros de entrada explícitos. Contudo, existe uma variável global:
;*	R5 - variável que contém o estado anterior do botão (1 - não premido, 2 - botão premido)
;*	     e é atualizada de acordo com o estado actual do botão.
;*	R7 - também é uma variável global, embora possa ser visto como resultado desta
;*	rotina. 

P1:
    CMP R5, 1       ; se estado = 1
    JZ  P1_1
    CMP R5, 2       ; se estado = 2
    JZ  P1_2
sai_P1:
    RET	            ; sai do processo. Dá oportunidade aos outros
                    ; processos de se executarem

P1_1:
    MOVB R0, [R9]   ; lê porto de entrada
	BIT  R0, 1
	JZ   sai_P1     ; se botão não carregado, sai do processo
	MOV  R7, ON     ; permite contagem do display
	MOV  R5, 2      ; passa ao estado 2 do P1
	JMP  sai_P1 	
				
P1_2:
    MOVB R0, [R9]   ; lê porto de entrada
    BIT  R0, 1
    JNZ  sai_P1     ; se botão continua carregado, sai do processo
    MOV  R7, OFF    ; caso contrário, desliga contagem do display
    MOV  R5, 1      ; passa ao estado 1 do P1
    JMP  sai_P1		
				

;* -- Processo P2 -----------------------------------------------------------------
;* 
;* Descrição: 	trata do RTC e da contagem do display
;*      incrementa R8 e mostra-o no display de cada vez que o RTC
;*      varia de 0->1 & R7=ON
;*
;* Parâmetros:  --
;* Retorna:     R8 - actualizado com o valor da contagem.  
;* Destrói:     R0
;* Notas: Não há parâmetros de entrada explícitos. Contudo, existe uma variável global:
;*	R6 - variável que contém o estado anterior do RTC (1 - RTC=0, 2 - RTC=1) 
;*	R6 é atualizado de acordo com o estado atual do RTC.
;*	R8 - também é uma variável global, embora possa ser visto como resultado desta
;*	rotina. 

P2:
    CMP R6, 1       ; se estado = 1
    JZ  P2_1
    CMP R6, 2       ; se estado = 2
    JZ  P2_2
sai_P2:
    RET             ; sai do processo. Dá oportunidade aos outros
                    ; processos de se executarem

P2_1:
    MOVB R0, [R9]   ; lê porto de entrada
    BIT  R0, 0
    JZ   sai_P2     ; se RTC=0 espera que passe para 1
    MOV  R6, 2      ; passa ao estado 2 do P2
    CMP  R7, ON     ; vê se a contagem do display está permitida
    JNZ  sai_P2     ; se não estiver, sai sem fazer nada
    ADD  R8, 1      ; incrementa contador
    MOVB [R10], R8  ; atualiza display
    JMP  sai_P2 	
				
P2_2:
    MOVB R0, [R9]   ; lê porto de entrada
    BIT  R0, 0
    JNZ  sai_P2     ; se RTC=1 espera que passe para 0
    MOV  R6, 1      ; passa ao estado 1 do P2
    JMP  sai_P2		
