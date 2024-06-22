; *********************************************************************
; *
; * IST-UL
; *
; *********************************************************************

; *********************************************************************
; *
; * Modulo: 	programa4-21.asm
; * Descrição : Algoritmo para contar '1s' numa constante.
; *		Utilização dos registos:
; *		R1 - valor cujo número de '1s' deve ser contado
; *		R2 - contador
; *
; * Nota : 	Verifique como se declaram constantes   
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
valor   EQU 6AC5H   ; valor cujos bits a 1 vão ser contados

; **********************************************************************
; * Código
; **********************************************************************

início:
    MOV R1, valor   ; inicializa registo com o valor a analisar
    MOV R2, 0       ; inicializa contador de número de 1s
    MOV R3, 0
maisUm:
    ADD R1, 0       ; isto é só para atualizar os bits de estado
    JZ  fim         ; se o valor já é zero, não há mais 1s para contar
    SHR R1, 1       ; retira o bit de menor peso (fica no bit C-Carry)
    ADDC R2, R3     ; soma mais 1 ao contador, se esse bit for 1
    JMP maisUm      ; vai analisar o próximo bit 
fim:
    JMP fim         ; acabou. R2 tem o número de bits a 1 no valor 





