# Capitulo 9 - Abstracao de Dados

# a)
# cria_tempo:int * int -> tempo
# tempo_h: tempo -> int
# tempo_m: tempo -> int
# e_tempo: tempo -> bool
# tempo_iguais: tempo * tempo -> string
# escreve_tempo: tempo -> string

# b)
# (horas,minutos)

#c)
def cria_tempo(h,m):
    if not (isinstance(h,int) and h >=0):
        raise ValueError ('Horas tem de ser inteiro >=0')
    if not (isinstance (m,int) and 0<= m <=59):
        raise ValueError ('Minutos tem de ser inteiro 0<=m<=59')
    return (h,m)

def tempo_h(t):
    return t[0]

def tempo_m(t):
    return t[1]

def e_tempo(t):
    return isinstance(t,tuple) and len(a)==2 and \
           isinstance(tempo_h(t),int) and tempo_h(t)>=0 and \
           isinstance (tempo_m(t), int) and 0<=tempo_m(t)<=59

def tempo_iguais(t1,t2):
    return tempo(t1) == tempo_h(t2) and \
           tempo_m(t1) == tempo_m(t2)

def escrever_tempo(t):
    print(str(tenoi_h(t) + ':' + str(tempo_m(t))

# d)
def depois(t1,t2):
    if tempo_h(t1) > tempo_h(t2):
        return True
    elif tempo_h(t1) == tempo_ h(t2) and tempo_m (t1) > tempo m(t2):
        return True
    return False