def troca_occ_lista(l,a,b):
    if l==[]:
        return '[]'
    elif l[0]==a:
        return ([b]+troca_occ_lista(l[1:],a,b))
    else:
        return ([l[0]]+troca_occ_lista(l[1:],a,b))