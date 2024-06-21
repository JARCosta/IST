# Capitulo 11 - Objetos
class garrafa:
    def __init__(self,capacidade):
        if isinstance(capacidade(int,float)) and capacidade >= 0:
            self.max_volume=capacidade
            self.volume=0
        else:
            raise ValueError('garrada:capacidade...')
    
    def capacidade(self):
        return self.max_volume
    
    def nivel(self):
        return self.volume
    
    def despeja(self,quantidade):
        if self.volume>quantidade:
            self.volume=self.volume-quantidade
        else:
            self.volume=0
            
    def enche(self,quantidade):
        if self.max_volume-self.volume>quantidade:
            self.volume=self.volume+quantidade
        else:
            self.volume=self.max_volume