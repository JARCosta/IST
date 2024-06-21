def soma_digitos_pares(n):
    if n==0:
        return 0
    elif n%2==0:
        return n%10+soma_digitos_pares(n//10)
    else:
        return soma_digitos_pares(n//10)