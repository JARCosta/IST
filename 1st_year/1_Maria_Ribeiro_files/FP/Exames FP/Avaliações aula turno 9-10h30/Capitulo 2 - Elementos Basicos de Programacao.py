# Capitulo 2 - Elementos Basicos de Programacao
num=eval(input('Insira um numero inteiro positivo\n'))
prod=1
while num>0:
    dig=num%10
    num=num//10
    if dig%2 == 0:
        prod=prod*dig
print('Resultado:', prod)

# ou
num=eval(input('Insira um numero inteiro positivo\n'))
num=list(num)
prod=1
for i in range(len(num)):
    if num[i]%2==0:
        prod*=num[i]
print('Resultado=',prod)

# ou
def prod_pares(num):
    """
    Programa que le um numero inteiro positivo e calcula o produto dos seus digitos pares.
    """
    if not (isinstance(num, int) and num>0):
        raise ValueError('prod_pares: Insira um numero inteiro positivo')
    num=list(str(num))
    def prod_pares_aux(num,prod):
        if num==[]:
            return prod
        elif int(num[0])%2==0:
            return prod_pares_aux(num[1:],prod*int(num[0]))
        else:
            return prod_pares_aux(num[1:],prod)            
    return prod_pares_aux(num,1)