def explode(x):
	if x!=int(x) or x<=0:
		raise ValueError ("O n�mero que inseriu n�o � inteiro, insira um n�mero inteiro, por favor.")
	else:
		y = ()
		while x > 0:
			y = (x%10,) + y 
			x = x//10
		return y