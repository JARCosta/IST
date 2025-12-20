def duplica_elementos(l):
    if l==[]:
        return []
    else:
        return [l[0]]+[l[0]]+duplica_elementos(l[1:])
print(duplica_elementos(['a',['b','c'],5]))