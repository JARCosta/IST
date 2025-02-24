def conta_menores(t,n):
    soma=0
    for i in range(len(t)):
            if n>t[i]:
                soma=soma+1
    return soma
