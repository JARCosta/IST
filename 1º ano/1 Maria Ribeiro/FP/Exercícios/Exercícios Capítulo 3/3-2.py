h=eval(input('Qual o número de horas?\n'))
def horas_dias(h):
    dias=h/24
    return dias
print('O número de dias correspondentes às horas recebidas é de', round(horas_dias(h)))
