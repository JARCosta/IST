def apenas_digitos_impares(n):
    if n==0:
        return 0
    elif n%2 == 0:
        return apenas_digitos_impares(n//10)
    else:
        return n%10+10*apenas_digitos_impares(n//10)
        