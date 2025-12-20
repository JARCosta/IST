def soma_rac(n1,n2):
    dic={}
    dic['num']=n1['num']*n2['den']+n1['den']*n2['num']
    dic['den']=n1['den']*n2['den']
    return dic