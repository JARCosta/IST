# Capitulo 4 - Tuplos e ciclos contados
def duplica(t):
    """
    Fucao que recebe um tuplo t e tem como valor um tuplo identico ao original, mas em que cada elemento esta repetido.
    """
    nova=()
    for i in range(len(t)):
        nova+=(t[i],)+(t[i],)
    return nova

# ou
def duplica(t):
    """
    Fucao que recebe um tuplo t e tem como valor um tuplo identico ao original, mas em que cada elemento esta repetido.
    """
    def duplica_aux(t,nova):
        if t==():
            return nova
        else:
            return duplica_aux(tuplo[1:],nova+(t[0],t[0]))
        return duplica_aux(t,())