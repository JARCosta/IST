def elemento_matriz(m,i,j):
    if (0<=i<len(m) and 0<=j<len(m[i])):
        return m[i][j]
    else:
        raise ValueError("Introduza novos valores")