def inverte(lst):
    lst_n=[]
    for i in range(len(lst)-1,-1,-1):
        lst_n+=[lst[i]]
    return lst_n