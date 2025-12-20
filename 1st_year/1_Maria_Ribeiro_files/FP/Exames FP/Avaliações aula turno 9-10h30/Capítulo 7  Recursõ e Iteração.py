# Capitulo 7 - Resursao e iteracao
def num_divisores(n):
    def num_divisores_aux(div):
        if div>n:
            return 0
        elif n%div==0:
            return 1+num_divisores_aux(div+1)
        else:
            return num_divisores_aux(div+1)
    return num_divisores_aux(1)