# Capitulo 5 - Listas
def cria_lista_multiplos(num):
    """
    Funcao cria_lista_multiplos que recebe um n�mero inteiro positivo num, e devolve uma lista com os dez primeiros m�ltiplos desse n�mero. A sua fun��o deve testar se o seu argumento � um n�mero inteiro positivo e dar uma mensagem de erro adequada em caso contr�rio. Considere que zero � m�ltiplo de todos os n�meros.
    """
    if not (isinstance(num, int) and num>0):
        raise ValueError('Argument not an int > 0')
    mul=[]
    for i in range(10):
        mul+=[num*i]
    return mul

# ou
def cria_lista_multiplos(num):
    """
    Funcao cria_lista_multiplos que recebe um n�mero inteiro positivo num, e devolve uma lista com os dez primeiros m�ltiplos desse n�mero. A sua fun��o deve testar se o seu argumento � um n�mero inteiro positivo e dar uma mensagem de erro adequada em caso contr�rio. Considere que zero � m�ltiplo de todos os n�meros.
    """
    def cria_lista_multiplos_aux(num,mul,count):
        if count==10:
            return mul
        else:
            return cria_lista_multiplos_aux(num, mul+[num*count], count+1)
        return cria_lista_multiplos_aux(num, [], 0)