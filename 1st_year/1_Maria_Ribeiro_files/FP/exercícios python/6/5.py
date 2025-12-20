def m_p(x,y):
    if y==0:
        return 1
    else:
        return m_p(x,y-1)*x