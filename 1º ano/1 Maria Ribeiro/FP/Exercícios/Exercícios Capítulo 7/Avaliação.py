def soma_impares(l):
    def soma_impares_aux(res,l):
        if (len(l)==0):
            return res
        else:
            return soma_impares_aux(res+(l[0] if l[0]%2!=0 else 0),l[1:])
    return soma_impares_aux(0,l)