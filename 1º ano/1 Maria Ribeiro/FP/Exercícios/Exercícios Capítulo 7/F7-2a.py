def quadrado_num(n):
    if n==0:
        return 0
    else:
        return n+n-1+quadrado_num(n-1)