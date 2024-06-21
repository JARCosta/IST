def triangular(n):
    if n==0:
        return False
    else:
        soma=0
        termo_ant=0
        while soma<n:
            soma+=termo_ant+1
            termo_ant+=1
        if soma==n:
            return True
        else:
            return False
            
    