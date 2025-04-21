def juntos(t):
    res=0
    for i in range(len(t)):
        if t[i-1]==t[i]:
            res+=1
    return res