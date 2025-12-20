#                                 CAPITULO 8                                  #
#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------------------#
#                                DICIONARIOS                                  #
#-----------------------------------------------------------------------------#
# 2.
def agrupa_por_chave(l):
    d={}
    for par in l:
        if par[0] in d:
            d[par[0]]+=[par[1]]
        else:
            d[par[0]]=[par[1]]
    return d 
# 5.
s='a aranha arranha a ra a ra arranha a aranha'
def conta_palavras(s):
    d={}
    i=0
    while i<len(s):
        while i<len(s) and s[i]=='':    # encontra incio
            i=i+1
        inicio=i
        while i<len(s) and s[i]!='':    # encontra fim
            i=i+1
        if i!=inicio:
            palavra=s[inicio:i]
            if palavra in d:
                d[palavra]=p[palavra]+1
            else:
                d[palavra]=1
    return d

# 7.
def valor(m,l,c):
    if (l,c) in m:
        return m[(l,c)]
    else:
        return 0
def add_esp(s):
    return ''*(4-len(s))+s
def escreve_esparsa(m):
    d=dimensoes(m)
    for l in range (d[0]+1):
        for c in range(d[1]+1):
            linha+=add_esp(str(valor(m,l,s)))

#Aula
#c1={'preal':a,'pimag':b}
#ac-bd+(ad+bc)i
c1={'preal':1,'pimag':2}
c2={'preal':3,'pimag':4}
def mul_complex(c1,c2):
    real=c1['preal']*c2['preal']-c1['pimag']*c2['pimag']
    imag=c1['preal']*c2['pimag']+c1['pimag']*c2['preal']
    mul={'pimag':imag,'preal':real}
    return mul
print(mul_complex(c1,c2))