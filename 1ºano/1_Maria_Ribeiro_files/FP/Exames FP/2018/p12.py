# Exercicio 12

# 12a
# Escolho uma representação de vetor como tuplo de dois elementos, sendo o primeiro deles < abscissa e o segundo a ordenada -> (x,y)

# 12b
# Construtor
def vetor(x, y):
    if not (isinstance(x, (float, int)) and isinstance(y, (int, float))):
        raise ValueError('argumentos invalidos')
    else:
        return (x, y)


# Seletores
def abscissa(v):
    if eh_vetor(v):
        return v[0]
    else:
        raise ValueError('argumentos invalidos')


def ordenada(v):
    if eh_vetor(v):
        return v[1]
    else:
        raise ValueError('argumentos invalidos')


# Reconhecedor
def eh_vetor(v):
    return type(v) == tuple and len(v) == 2 and isinstance(v[0], (float, int)) and isinstance(v[1], (int, float))


def eh_vetor_nulo(v):
    return eh_vetor(v) and ordenada(v) == 0 and abscissa(v) == 0


# Teste
def vetores_iguais(v1, v2):
    if eh_vetor(v1) and eh_vetor(v2):
        return abscissa(v1) == abscissa(v2) and ordenada(v1) == ordenada(v2)
    return False


# 12c
def soma_vetores(v1, v2):
    if eh_vetor(v1) and eh_vetor(v2):
        return vetor(abscissa(v1) + abscissa(v2), ordenada(v1) + ordenada(v2))
    else:
        raise ValueError('argumentos invalidos')

from random import random
print(int(random()* 10 % 10))
