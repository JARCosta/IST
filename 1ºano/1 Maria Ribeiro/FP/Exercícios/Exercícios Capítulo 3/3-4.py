r1=eval(input('Qual � o raio menor da coroa?\n'))
r2=eval(input('Qual � o raio maior da coroa?\n'))
def area_circulo(r1,r2):
    If r1 < r2 : 
        area1=3.14*r1*r1
        area2=3.14*r2*r2
        ac=area2-area1
        return ac
    Else print('ValueError')
print('O valor da �rea correspondente ao raio dado � de', area_circulo(r) )