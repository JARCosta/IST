# Capitulo 10 - Ficheiro 
def ficheiro_ordenado(f_in):
    f=open(f_in,'r')
    l1=f.readline()
    while l1:
        l2=f.readline()
        if l2 and len(l1)>=len(l2):
            f.close()
            return False
        l1=l2
    f.close()
    return True