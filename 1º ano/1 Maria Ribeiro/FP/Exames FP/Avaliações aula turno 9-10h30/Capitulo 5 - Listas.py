# Capitulo 5 - Listas
def cria_lista_multiplos(num):
    """
    Funcao cria_lista_multiplos que recebe um número inteiro positivo num, e devolve uma lista com os dez primeiros múltiplos desse número. A sua função deve testar se o seu argumento é um número inteiro positivo e dar uma mensagem de erro adequada em caso contrário. Considere que zero é múltiplo de todos os números.
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
    Funcao cria_lista_multiplos que recebe um número inteiro positivo num, e devolve uma lista com os dez primeiros múltiplos desse número. A sua função deve testar se o seu argumento é um número inteiro positivo e dar uma mensagem de erro adequada em caso contrário. Considere que zero é múltiplo de todos os números.
    """
    def cria_lista_multiplos_aux(num,mul,count):
        if count==10:
            return mul
        else:
            return cria_lista_multiplos_aux(num, mul+[num*count], count+1)
        return cria_lista_multiplos_aux(num, [], 0)