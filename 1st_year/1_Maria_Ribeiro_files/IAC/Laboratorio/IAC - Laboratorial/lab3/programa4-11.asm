; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo: 	programa4-11.asm (do livro)
; * Descrição : Algoritmo para calcular o fatorial.
; *		Utilização dos registos:
; *		R1 - Produto dos vários fatores (valor do fatorial no fim)
; *		R2 - fator auxiliar que começa com N-1, depois N-2, ...
; *		... até ser 2 (1 já não vale a pena).
; *
; * Nota : 	Verifique como se declaram constantes   
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
N   EQU 6       ; número de que se pretende calcular o fatorial

; **********************************************************************
; * Código
; **********************************************************************

início:
    MOV R1, N   ; valor inicial do produto
    MOV R2, R1  ; valor auxiliar
maisUm:
    SUB R2, 1   ; decrementa factor
    MUL R1, R2  ; acumula produto de fatores
    JV  erro    ; se houve excesso, o fatorial tem de acabar aqui
    CMP R2, 2   ; verifica se o fator diminuiu até 2
    JGT maisUm  ; se ainda é maior do que 2, deve continuar
fim:
    JMP fim     ; acabou. R1 com o valor do fatorial
erro:
    JMP erro    ; termina com erro 
