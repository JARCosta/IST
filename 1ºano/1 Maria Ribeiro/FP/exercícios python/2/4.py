n=eval(input('Insira um n�mero \n'))
soma=''
k=0
while n!=-1:
    soma+=str(n)
    k+=1
    n=eval(input('Insira um n�mero (-1 para terminar) \n'))
print('O numero inteiro �', soma)