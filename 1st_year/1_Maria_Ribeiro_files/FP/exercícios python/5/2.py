def substitui(lst,velho,novo):
    lst_n=[]
    for i in range(len(lst)):
        if lst[i]==velho:
            lst_n+=[novo]
        else:
            lst_n+=[lst[i]]
    return lst_n