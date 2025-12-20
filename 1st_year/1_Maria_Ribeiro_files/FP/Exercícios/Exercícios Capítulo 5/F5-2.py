def remove_multiplos(l,n):
    s=[]
    for i in range (len(l)):
        if (l[i]%n != 0):
            s=s+[l[i]]
    return s