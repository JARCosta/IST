def misterio_rc(x,n):
    def misterio_rcaux(res,n):
        if n==0:
            return res
        else:
            return misterio_rcaux(res+x*n,n-1)
    return misterio_rcaux(0,n)