n=eval(input('Insira um número \n'))
soma=''
k=0
while n!=-1:
    soma+=str(n)
    k+=1
    n=eval(input('Insira um número (-1 para terminar) \n'))
print('O numero inteiro é', soma)