def bissexto(a):
    if (a % 4 == 0 and a % 100 != 0) or (a % 4 == 0 and a % 400 == 0):
        return True
    return False