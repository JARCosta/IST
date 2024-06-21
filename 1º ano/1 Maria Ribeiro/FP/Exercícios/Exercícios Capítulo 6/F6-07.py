def pertence(l,e):
    return l!=[] and (e==l[0] or pertence(l[1:],e))