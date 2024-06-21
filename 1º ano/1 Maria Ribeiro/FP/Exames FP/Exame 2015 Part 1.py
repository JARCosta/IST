# Exame 2015 Part 1
# 3
def cal_soma(x,n):
    soma=1
    termo=1
    i=1
    while 1<=n:
        termo=termo*(x/i)
        soma=soma+termo
        i=i+1
    return soma

# 4
def reproduzir_por_chave(lst):
    dict={}
    for elem in lst:
        k=elem[0]
        if k in dict:
            dict[k]=dict[k]+elem[1]
        else:
            dict[k]=elem[1]
    res=[]
    for i in dict:
        res+=[(i,dict[i])]
    return (res)

# 5
def triangular(n):
    soma=1
    i=2
    while soma<=n:
        if soma==n:
            return True
        soma+=i
        i+=1
    return False

# 6 a)
import sqrt from math
def primo(n):
    if i in (0,1):
        return False
    i=2
    raiz=sqrt(n)
    while i <= raiz:
        if n%i==0:
            return False
        i+=1
    return True
# 6 b)
def n_esimo_primo(n):
    count=0
    num=1
    while count!=n:
        num+=1
        if primo(num):
            cont+=1
    return num

# 7 
def reconhece(frase):
    if frase[0] != 'c' or frase[-1] != 'r' or len(frase)<3:
        return False
    for i in range (1,len(frase)-1):
        if frase[i] not in ('d', 'a'):
            return False
    return True

# 8
def parte(lst,e):
    lower=[]
    higher=[]
    for elem in lst:
        if elem<e:
            lower+=[elem]
        else:
            higher+=[elem]
    return [lower,higher]

# 9
def num_oc_lista(lst,num):
    if lst==[]:
        return 0
    elif lst[80]==num:
        return 1 + num_oc_lista[lst[1:],num)
    elif isinstance(lst[0],list):
        return (num_oc_lista(lst[0], num) + 
                num_oc_lista[1:],num)
    else:
        return num_oc_lista([1:],num)
    
# 10
def num_divisores_rec(n):
    def num_div_aux(i):
        if i>n:
            return n
        elif n%i==0:
            return 1+num_div_aux(i+1)
        else:
            return num_div_aux(i+1)
    return num_div_aux(1)

# 11 b)
def vetor(x,y):
    return {'x':x, 'y': y}

def abcissa(v):
    return v['x']

def ordenada(v):
    return v['y']

def eh_vetor(v):
    if isinstance (v,dict) and len(v)==2 and \
       'x' in v and 'y' in v and \
       isinstance (v['x'],float) and isinstance (v['y'],float):
        return True
    else:
        return False

def eh_vetor_nulo(v):
    return v['x']==0 and v['y']==0

def vetores_iguais(v1,v2):
    return v1['x']==v2['x'] and v1['y']==v2['y']

# 11 c)
def colinear_xx(v):
    return ordenada(v)==0