def duplica(l):
    s=[]
    if l==list(l):
        for i in range(len(l)):
            s=s+[l[i]]+[l[i]]
        return s
    else:
        raise TypeError ("must be a list")