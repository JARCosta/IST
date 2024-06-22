# Joao Costa ist199088
"""
def cria_coords(pos):
    l = pos // 3 + 1
    c = pos % 3
    if c == 0:
        column = "a"
    elif c == 2:
        column = "b"
    elif c == 3:
        column = "c"
    return [column, l]
"""


def cria_posicao(col, lin):
    lin, c = int(lin), 0
    if not ((col == "a" or col == "b" or col == "c") and (lin == 1 or lin == 2 or lin == 3)):
        raise ValueError("cria_posicao: argumentos invalidos")
    if col == "a":
        c = 1
    elif col == "b":
        c = 2
    elif col == "c":
        c = 3
    lin = 3 * (lin - 1)
    return int(int(lin) + int(c))


def cria_copia_posicao(p):
    return p


def obter_pos_c(p):
    if type(p) == int:
        if p % 3 == 1:
            return "a"
        elif p % 3 == 2:
            return "b"
        elif p % 3 == 0:
            return "c"
    if type(p) == str and type(p[0]) == str:
        return p[0]


def obter_pos_l(p):
    pos = (1,)
    if type(p) == str:
        pos = tuple(p)
        if len(pos) == 2:
            return int(p[1])
    if type(p) == int or len(pos) == 1:
        if 1 <= p <= 3:
            return 1
        elif 4 <= p <= 6:
            return 2
        elif 7 <= p <= 9:
            return 3


"""

def obter_pos_l():
    def parteDecimal(v):
        return v % 1
    t = ()
    for i in range(1,10):
        v = i/3
        if parteDecimal(v) != 0:
            v += 1
        t += (int(v),)
    return t
"""


def eh_posicao(pos):
    if not (type(pos) == int and 1 <= pos <= 9):
        return False
    else:
        return True


def posicoes_iguais(p1, p2):
    if p1 == p2:
        return True
    else:
        return False


def posicao_para_str(pos):
    c = obter_pos_c(pos)
    line = obter_pos_l(pos)
    #    if c == 1:
    #        col = "a"
    #    elif c == 2:
    #        col = "b"
    #    elif c == 3:
    #        col = "c"
    return str(c) + str(line)


def obter_posicoes_adjacentes(pos):
    t = ()
    if pos == 2 or pos == 4 or pos == 5:
        t += 1,
    if pos == 1 or pos == 3 or pos == 5:
        t += 2,
    if pos == 2 or pos == 5 or pos == 6:
        t += 3,
    if pos == 1 or pos == 5 or pos == 7:
        t += 4,
    if pos == 1 or pos == 2 or pos == 3 or pos == 4 or pos == 6 or pos == 7 or pos == 8 or pos == 9:
        t += 5,
    if pos == 3 or pos == 5 or pos == 9:
        t += 6,
    if pos == 4 or pos == 5 or pos == 8:
        t += 7,
    if pos == 7 or pos == 5 or pos == 9:
        t += 8,
    if pos == 8 or pos == 5 or pos == 6:
        t += 9,
    return t


def obter_posicoes_adjacentes2(pos):
    t = ()
    if eh_posicao(pos - 3):
        t += (pos - 3,)
    if eh_posicao(pos - 1) and pos != 4 and pos != 7:
        t += (pos - 1,)
    if eh_posicao(pos + 1) and pos != 6 and pos != 3:
        t += (pos + 1,)
    if eh_posicao(pos + 3):
        t += (pos + 3,)
    return t


# TAD PECA

def cria_peca(str):
    if str == "X":
        return 1
    elif str == "O":
        return -1
    elif str == " " or str == ' ':
        return 0
    else:
        raise ValueError("cria_peca: argumento invalido")


def cria_copia_peca(peca):
    return peca


def eh_peca(uni):
    if not (str(uni) == str("X") or str(uni) == str("O") or str(uni) == str(' ')):
        return False
    else:
        return True


def pecas_iguais(p1, p2):
    if p1 == p2:
        return True
    else:
        return False


def peca_para_str(peca):
    if peca == -1 or peca == "O":
        return "[O]"
    if peca == 0:
        return "[ ]"
    if peca == 1 or peca == "X":
        return "[X]"


def peca_para_inteiro(peca):
    if peca == "X" or peca == 1:
        return 1
    if peca == "O" or peca == -1:
        return -1
    if peca == " " or peca == 0:
        return 0


# TAD TABULEIRO

def cria_tabuleiro():
    return [0, 0, 0, 0, 0, 0, 0, 0, 0]


def cria_copia_tabuleiro(tab):
    r = []
    for i in range(0, 9):
        r += [tab[i], ]
    return r


def obter_peca(tab, pos):
    return tab[pos - 1]


def obter_vetor(tab, str):
    t = ()
    if str == "1" or str == "2" or str == "3":
        str = int(str)
        for i in range((3 * str) - 3, 3 * str):
            t += (tab[i],)
        return t
    if str == "a" or str == "b" or str == "c":
        if str == "a":
            return tab[0], tab[3], tab[6]
        if str == "b":
            return tab[1], tab[4], tab[7]
        if str == "c":
            return tab[2], tab[5], tab[8]


def coloca_peca(tab, jog, pos):
    tab[pos - 1] = jog
    return tab


def remove_peca(tab, peca):
    return coloca_peca(tab, 0, peca)


def move_peca(tab, pospast, posfut):
    if not (type(pospast) == int and type(posfut) == int):
        pospast = cria_posicao(pospast[0], pospast[1])
        posfut = cria_posicao(posfut[0], posfut[1])
    tab = list(tab)
    pecaold = tab[pospast - 1]
    tab[pospast - 1] = 0
    tab[posfut - 1] = pecaold
    return tab


def eh_tabuleiro(uni):
    x, o, f = 0, 0, 0
    possiblewins = ["1", "2", "3", "a", "b", "c"]
    winners = []
    for i in uni:
        if i == -1:
            o += 1
        elif i == 1:
            x += 1
        elif i == 0:
            f += 1
    for e in possiblewins:
        winners += [obter_vetor(uni, e)[0] + obter_vetor(uni, e)[1] + obter_vetor(uni, e)[2], ]
    for w1 in winners:
        for w2 in winners:
            if w1 == 3 or w1 == -3 or w2 == 3 or w2 == -3:
                if w1 + w2 == 0:
                    return False
    if not (x < 4 and o < 4 and x - o <= 1 and o - x <= 1):
        return False
    else:
        return True


def eh_posicao_livre(tab, pos):
    if tab[pos - 1] == 0:
        return True
    else:
        return False


def tabuleiros_iguais(tab1, tab2):
    if eh_tabuleiro(tab1) and eh_tabuleiro(tab2) and tab1 == tab2:
        return True
    else:
        return False


def tabuleiro_para_str(tabi):
    tab = []
    for i in range(0, 9):
        if tabi[i] == 0:
            tab += " "
        if tabi[i] == -1:
            tab += "O"
        if tabi[i] == 1:
            tab += "X"

    p1, p2, p3, p4, p5, p6, p7, p8, p9 = tab[0], tab[1], tab[2], tab[3], tab[4], tab[5], tab[6], tab[7], tab[8]
    return "   a   b   c\n1 [" + p1 + "]-[" + p2 + "]-[" + p3 + "]\n   | \\ | / |\n" \
                                                                "2 [" + p4 + "]-[" + p5 + "]-[" + p6 + "]\n   | / | \\ |\n3 [" + p7 + "]-[" + p8 + "]-[" + p9 + "]"


def tuplo_para_tabuleiro(tuple):
    tab = []
    for i in range(0, 3):
        for j in range(0, 3):
            tab += [tuple[i][j], ]
    return tab


def obter_ganhador(tab):
    winstiles = ["1", "2", "3", "a", "b", "c"]
    for i in winstiles:
        w = peca_para_inteiro(obter_vetor(tab, i)[0]) + peca_para_inteiro(obter_vetor(tab, i)[1]) + peca_para_inteiro(obter_vetor(tab, i)[2])
        if w == 3:
            return cria_peca("X")
        elif w == -3:
            return cria_peca("O")
    return cria_peca(" ")

    #        if w == 3 or w == -3:
    #            if i == 1 or i == "a":
    #                return 1
    #            if i == 2 or i == "b":
    #                return 5
    #            if i == 3 or i == "c":
    #                return 9
    # return obter_posicoes_livres(tab)[0]


def obter_posicoes_livres(tab):
    f = []
    for i in range(0, 9):
        if tab[i] == 0:
            f += [i + 1, ]
    return f


def obter_posicoes_jogador(tab, j):
    pos = ()
    for i in range(0, 9):
        if tab[i] == j:
            pos += (i + 1,)
    return pos


# 2.2 Funcoes adicionais

def obter_movimento_manual(tab, peca):
    if len(obter_posicoes_jogador(tab, peca)) < 3:
        a = (input("Turno do jogador. Escolha uma posicao: "),)
        a = tuple(a[0])
        if not (a[0], a[0], a[0] == "a", "b", "c" and a[1], a[1], a[1] == "1", "2", "3"):
            raise ValueError("obter_movimento_manual: escolha invalida")
        a = cria_posicao(a[0], a[1])
        if not eh_posicao(a):
            raise ValueError("obter_movimento_manual: escolha invalida")
    else:
        a = input("Turno do jogador. Escolha um movimento: ")
        if a[0] == a[2] and a[1] == a[3]:
            return (str(a[0]) + str(a[1]), str(a[2]) + str(a[3]),)
        if not (a[0], a[0], a[0] == "a", "b", "c" and a[1], a[1], a[1] == "1", "2", "3"):
            raise ValueError("obter_movimento_manual: escolha invalida")
        if not (a[2], a[2], a[2] == "a", "b", "c" and a[3], a[3], a[3] == "1", "2", "3"):
            raise ValueError("obter_movimento_manual: escolha invalida")
        if cria_posicao(str(a[2]), str(a[3])) not in obter_posicoes_adjacentes(cria_posicao(str(a[0]), str(a[1]))):
            raise ValueError("obter_movimento_manual: escolha invalida")
        a = (str(a[0]) + str(a[1]), str(a[2]) + str(a[3]),)
    return a


# 1.3.1 Fase de colocacao

def vitoria_bloqueio(tab, peca):
    possiblewins = ["1", "2", "3", "a", "b", "c"]
    for i in possiblewins:
        w = obter_vetor(tab, i)[0] + obter_vetor(tab, i)[1] + obter_vetor(tab, i)[2]
        if w == 2 or w == -2:
            for n in range(0, 3):
                if obter_vetor(tab, i)[n] == 0:
                    if i == "1" or i == "2" or i == "3":
                        return 3 * (int(i) - 1) + n + 1
                    elif i == "a":
                        return (3 * n) + 1
                    elif i == "b":
                        return (3 * n) + 2
                    elif i == "c":
                        return (3 * n) + 3


def centro(tab):
    if tab[4] == 0:
        return 5


def cantos(tab):
    canto = [1, 3, 7, 9]
    for i in canto:
        if tab[i - 1] == 0:
            return i


def laterais(tab):
    laterals = [2, 4, 6, 8]
    for i in laterals:
        if tab[i - 1] == 0:
            return i


# 2.2.2 obter_movimento_auto

def obter_movimento_auto(tab, peca, dif):
    pos, pos2 = [], []
    if len(obter_posicoes_jogador(tab, peca)) < 3:
        if vitoria_bloqueio(tab, peca) is not None:
            return vitoria_bloqueio(tab, peca),
        if centro(tab) is not None:
            return centro(tab),
        if cantos(tab) is not None:
            return cantos(tab),
        if laterais(tab) is not None:
            return laterais(tab),
    else:
        if dif == "facil":
            for i in range(0, 9):
                if tab[i] == peca:
                    pos += [i + 1, ]
                    return pos[0], obter_posicoes_adjacentes(pos[0])[0]
        if dif == "normal":
            a = minimax(tab, peca, 1, ())
            a, b = a[1][0], a[1][1]
            a, b = posicao_para_str(a), posicao_para_str(b)
            return a, b
        if dif == "dificil":
            t = ()
            for i in minimax(tab, peca, 5, ())[1][:2]:
                t += (posicao_para_str(i), )
            return t


def opponent(peca):
    return peca * -1


# Algoritmo 1

def minimax(tab, peca, profund, seqmovs):
    adversario = cria_peca("X") if peca_para_inteiro(peca) == -1 else cria_peca("O")
    if peca_para_str(obter_ganhador(tab)) != "[ ]" or profund == 0:
        return peca_para_inteiro(obter_ganhador(tab)), seqmovs
    else:
        melhor_resultado, melhor_seq_movs = opponent(peca), ()
        for p in obter_posicoes_jogador(tab, peca):
            for a in obter_posicoes_adjacentes(p):
                if eh_posicao_livre(tab, a):
                    newtab = move_peca(cria_copia_tabuleiro(tab), p, a)
                    newres, newsecmov = minimax(newtab,adversario, profund -1, seqmovs + (p, a))
                    if not melhor_seq_movs or (peca == cria_peca("X") and newres > melhor_resultado) or (
                            peca == cria_peca("O") and newres < melhor_resultado):
                        melhor_resultado, melhor_seq_movs = newres, newsecmov
        return melhor_resultado, melhor_seq_movs


def conta_num_pecas(tab):
    r = 0
    for i in tab:
        if i != 0:
            r += 1
    return r


def pos_em_str_para_num(pos):
    r = 3 * (int(pos[1]) - 1)
    if pos[0] == "a":
        r += 1
    elif pos[0] == "b":
        r += 2
    elif pos[0] == "c":
        r += 3
    return r


def jogada(jogador, tab, peca, dif):
    if jogador == "player":  # vez do player
        if len(obter_posicoes_livres(tab)) > 3:
            coloca = obter_movimento_manual(tab, peca)
            tab = coloca_peca(tab, peca, coloca)
            print(tabuleiro_para_str(tab))
            return tab
        if len(obter_posicoes_livres(tab)) <= 3:
            move = obter_movimento_manual(tab, peca)
            tab = move_peca(tab, pos_em_str_para_num(move[0]), pos_em_str_para_num(move[1]))
            print(tabuleiro_para_str(tab))
            return tab
    if jogador == "computer":  # vez do pc
        if len(obter_posicoes_livres(tab)) > 3:
            print("Turno do computador (" + dif + "):")
            coloca = obter_movimento_auto(tab, peca, dif)
            tab = coloca_peca(tab, peca, coloca[0])
            print(tabuleiro_para_str(tab))
            return tab
        if len(obter_posicoes_livres(tab)) <= 3:
            print("Turno do computador (" + dif + "):")
            move = obter_movimento_auto(tab, peca, dif)
            tab = move_peca(tab, move[0], move[1])
            print(tabuleiro_para_str(tab))
            return tab


def moinho(jog, dif):
    if not ((jog == "X" or jog == "O" or jog == '[X]' or jog == '[O]') and (
            dif == "facil" or dif == "normal" or dif == "dificil")):
        raise ValueError("moinho: argumentos invalidos")
    if jog == "O":
        jog = -1
    elif jog == "X":
        jog = 1
    pc = jog * -1
    print("Bem-vindo ao JOGO DO MOINHO. Nivel de dificuldade " + dif + ".")
    tab = cria_tabuleiro()  # garante que o tabuleiro comeca vazio
    print(tabuleiro_para_str(tab))
    num_pecas = conta_num_pecas(tab)

    if jog == 1:
        tab = jogada("player", tab, jog, dif)
    while num_pecas < 6:
        # vez_do_pc
        if obter_ganhador(tab) != 0:
            return obter_ganhador(tab)
        tab = jogada("computer", tab, pc, dif)

        if conta_num_pecas(tab) >= 6:
            break

        # vez_do_player
        if obter_ganhador(tab) != 0:
            return obter_ganhador(tab)
        tab = jogada("player", tab, jog, dif)

    if conta_num_pecas(tab) >= 6:
        if peca_para_str(obter_ganhador(tab)) == "[ ]":
            if jog == -1:
                # vez_do_pc
                if obter_ganhador(tab) != 0:
                    return print(obter_ganhador(tab))
                tab = jogada("computer", tab, pc, dif)

                if peca_para_str(obter_ganhador(tab)) != "[ ]":
                    return print(obter_ganhador(tab))
            while peca_para_str(obter_ganhador(tab)) == "[ ]":
                # vez_do_player
                if obter_ganhador(tab) != 0:
                    return print(obter_ganhador(tab))
                tab = jogada("player", tab, jog, dif)

                # vez_do_pc
                if obter_ganhador(tab) != 0:
                    return print(obter_ganhador(tab))
                tab = jogada("computer", tab, pc, dif)

    return print(peca_para_str(obter_ganhador(tab)))

t = tuplo_para_tabuleiro(((1,0,-1),(0,1,-1),(1,-1,0)))
m = obter_movimento_auto(t, cria_peca('X'), 'normal')
m = posicao_para_str(m[0]), posicao_para_str(m[1])
print(m)