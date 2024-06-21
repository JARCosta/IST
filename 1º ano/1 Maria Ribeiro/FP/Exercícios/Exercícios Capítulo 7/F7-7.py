def num_divisores(n):
    def num_divisores_rcaux(res,d):
        if d>n:
            return res
        else:
            return num_divisores_rcaux(res+(1 if n%d==0 else 0), d+1)
        return num_divisores_rcaux(0,1)