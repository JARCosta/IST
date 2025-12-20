# Capitulo 6 - Funcoes recursivas
def num_digitos(n):
    """
    Funcao que recebe um numero interio nao negativo e devolve o numero de digitos de n.
    """
    n=str(n)
    count=0
    for i in range(len(n)):
        count+=1
    return count

# ou
def num_digitos(n):
    """
    Funcao que recebe um numero interio nao negativo e devolve o numero de digitos de n.
    """
    if n//10==0:
        return 1
    else:
        return 1+num_digitos(n//10)

# Capitulo 6 - Funcoes de ordem superior
def soma_quadrados_lista(lst):
    res=0
    if lst==[]:
        return 0
    else:
        for i in range(len(lst)):
            res+=lst[i]**2
        return res
# ou 
def soma_quadrados_lista(lst):
    return acumula(lambda x,y: x+y, tranfora(lambda z: z*z, lst))
    