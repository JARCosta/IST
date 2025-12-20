def implode(t):
    soma=0
    for i in range(len(t)-1,-1,-1):
        soma=soma+(t[i]*10**(len(t)-1-i))
    print(soma)

