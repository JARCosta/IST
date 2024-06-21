def explode(x):
	if x!=int(x) or x<=0:
		raise ValueError ("O número que inseriu não é inteiro, insira um número inteiro, por favor.")
	else:
		y = ()
		while x > 0:
			y = (x%10,) + y 
			x = x//10
		return y