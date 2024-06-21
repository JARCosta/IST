# Capitulo 3 - Funcoes
def soma_quadrados(n):
    """
    Funcao que recebe um inteiro positivo e tem como valor  a soma dos quadrados de todos os numeros inteiros de 1 ate' n.
    """
    soma=0
    while n!=0:
        soma+=n*n
        n=n-1
    return soma

# ou
def soma_quadrados(n):
    """
    Funcao que recebe um inteiro positivo e tem como valor  a soma dos quadrados de todos os numeros inteiros de 1 ate' n.
    """    
    if not (isinstance(n, int) and n>0):
        raise ValueError('soma_quadrados: Insira um numero inteiro positivo')  
    def soma_quadrados_aux(n,soma):
        if n==1:
            return soma+1
        else:
            return soma_quadrados_aux(n-1,soma+n*n)
    return soma_quadrados_aux(n,0)