def valor(q,j,n): #q quantia depositada, j taxa de juros [0,1], n anos a render
    if (j > 0 and j < 1):
        x=(q*(1+j)**n)
        return x
    else:
        raise ValueError('Impossível') 

    
    
    