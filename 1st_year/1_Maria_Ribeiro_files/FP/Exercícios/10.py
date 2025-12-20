#Programaco com Objetos

# Exercicio 1
class estacionamento:
  def __init__(self, cap):
    self.capacidade=cap #capacidade e' a parte de estado
    self.ocupados=0
  def entra(self):
    if self.ocupados<self.ocupados:
      self.ocupados+=1
    else:
      return ('estacionamento cheio')
  def sai(self):
    if self.ocupados>0:
      sel.ocupados-=1
    else:
      return ('estacionamento vazio')
  def lugares(self):
    return (self.capacidade-self.ocupados)
    
# Exercicio 2
def mdc(a,b):
  if b==0:
    return a
  else:
    return mdc(b,a%b)
class racional:
  def __init__(self,num,dem):
    if isinstance(num,int) and isinstance(dem,int) and dem!=0:
      div=mdc(num,dem)
      self.num=num//div
      self.dem=dem//div
  def numerador(self):
    return self.num
  def denominador(self):
    return self.dem
  def __repr__(self):# vai buscar um nome
    return str(self.num) +'/'+ str(self.dem)
  def __mul__(self,outro):
    return racional(self.numerador*outro.numerador, self.denominador*outro.denominador)
  
#AULA
class garrafa:
  def __init__(self,cap):
    self.capacidade=cap
    self.nivel=0
    def capacidade(self):
      return self.capacidade
  def nivel(self):
    return self.nivel
  def despeja(self,desp):
    self.despeja=desp
    if self.nivel<self.despeja:
      self.nivel=0
      return self.nivel
    else:
      self.nivel-=self.despeja
      return self.nivel
  def enche(self,ench):
    self.enche=ench
    if self.enche==self.capacidade:
      self.nivel=self.capacidade
      return self.nivel
    else:
      self.nivel+=self.enche
      return self.nivel