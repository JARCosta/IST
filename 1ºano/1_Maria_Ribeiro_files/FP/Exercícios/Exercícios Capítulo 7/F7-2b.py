def quadrado_rc(n):
    def quadrado_rcaux(res,n):
        if n==0:
            return res
        else:
            return quadrado_rcaux(res+n+n-1,n-1)
    return quadrado_rcaux(0,n)