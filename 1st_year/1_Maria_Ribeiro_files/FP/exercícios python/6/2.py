def inverte(n):
    if n<=1:
        return n 
    else:
        return int(str(n%10)+str(inverte(n//10)))