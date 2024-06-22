# Projeto Jogo do Galo, Fundamentos da Programacao, IST Taguspark
# 199088 Joao Costa

# Bem vindo, neste projeto o objetivo e criar um jogo do gajo, jogavel, onde o usuario escolhe entre "X" ou "O" e,
# tenta ganhar contra o computador, tendo uma linha, coluna ou diagonal do tabuleiro preenchida pelo simbulo escolhido.


def eh_tabuleiro(t):
    """input:  tuplo com 3 de tanhanho, onde cada elemento e um tuplo de 3 elementos
    se o input for da forma ((X, X, X), (X, X, X), (x, X, X)) onde X e igual a 0, -1 ou 1
    output: True, se a forma e o conteudo do input for compativel com o programa,
    False, se o input nao for compativel"""
    n = 0
    if type(t) == tuple:
        if type(t[0]) == tuple and type(t[1]) == tuple and type(t[2]) == tuple:
            if len(t) == 3 and len(t[0]) == 3 and len(t[1]) == 3 and len(t[2]) == 3:
                for i in range(0, 3):
                    for j in t[i]:
                        if type(j) == bool:
                            return False
                        if not (type(j) == int and (j == -1 or j == 0 or j == 1)):
                            n = 30
                        if type(j) == int and (j == -1 or j == 0 or j == 1):
                            n = n + 1
                        if n > 15:
                            return False
                        if n == 9:
                            return True
    return False


def eh_posicao(n):
    # Retorna True, se n(posicao) for um valor inteiro entre 1 a 9, inclusive
    if type(n) == int and 1 <= n <= 9:
        return True
    return False


def obter_coluna(tab, column):
    """ retorna um tuplo de 3 elementos onde o primeiro e o valor da linha de cima da coluna celecionala, o segundo , o
     valor da linha do meio, e o terceiro, da linha de baixo"""
    if not (eh_tabuleiro(tab) and 1 <= column <= 3 and type(column) == int):
        raise ValueError("obter_coluna: algum dos argumentos e invalido")
    else:
        return tab[0][column - 1], tab[1][column - 1], tab[2][column - 1]


def obter_linha(tab, line):
    """assim como a funcao obter coluna, esta da output de um tuplo de 3 elementos, com os 3 valores
    ,da linha selecionada, presentes no tabuleiro"""
    if not (eh_tabuleiro(tab) and 1 <= line <= 3 and type(line) == int and type(line) != bool):
        raise ValueError("obter_linha: algum dos argumentos e invalido")
    else:
        return tab[line - 1]


def obter_diagonal(tab, diag):
    if not (eh_tabuleiro(tab) and 1 <= diag <= 2 and type(diag) == int):
        raise ValueError("obter_diagonal: algum dos argumentos e invalido")
    elif diag == 1:
        return tab[0][0], tab[1][1], tab[2][2]
    elif diag == 2:
        return tab[2][0], tab[1][1], tab[0][2]


def tabuleiro_str(tab):
    t1 = ()
    if not (eh_tabuleiro(tab) and type(tab) == tuple and len(tab) == 3):
        raise ValueError("tabuleiro_str: o argumento e invalido")
    for i in range(0, len(tab)):
        for j in range(0, len(tab[i])):
            if tab[i][j] == 0:
                k = " "
            elif tab[i][j] == -1:
                k = "O"
            else:
                k = "X"
            t1 = t1 + (k,)
    return " " + str(t1[0]) + " | " + str(t1[1]) + " | " + str(t1[2]) + " " + "\n-----------\n" + " " + str(
        t1[3]) + " | " + str(t1[4]) + " | " + str(t1[5]) + " " + "\n-----------\n" + " " + str(t1[6]) + " | " + str(
        t1[7]) + " | " + str(t1[8]) + " "


def eh_posicao_livre(tab, pos):
    linha = 0
    if not (eh_tabuleiro(tab) and eh_posicao(pos)):
        raise ValueError("eh_posicao_livre: algum dos argumentos e invalido")
    elif 1 <= pos <= 3:
        linha = 0
        pos = pos
    elif 4 <= pos <= 6:
        linha = 1
        pos = pos - 3
    elif 7 <= pos <= 9:
        linha = 2
        pos = pos - 6
    if tab[linha][pos - 1] == 0:
        return True
    else:
        return False


def obter_posicoes_livres(tab):
    pos = 0
    p = ()
    if not eh_tabuleiro(tab):
        raise ValueError("obter_posicoes_livres: o argumento e invalido")
    for i in range(0, len(tab)):
        for j in range(0, len(tab[i])):
            pos = pos + 1
            if tab[i][j] == 0:
                p = p + (pos,)
    return p


def jogador_ganhador(tab):
    r = 0
    if not eh_tabuleiro(tab):
        raise ValueError("jogador_ganhador: o argumento e invalido")
    for i in range(1, len(tab) + 1):
        c = obter_coluna(tab, i)
        if c[0] == c[1] == c[2] == 1:
            r = c[0]
        elif c[0] == c[1] == c[2] == -1:
            r = c[0]
        v = obter_linha(tab, i)
        if v[0] == v[1] == v[2] == 1:
            r = v[0]
        elif v[0] == v[1] == v[2] == -1:
            r = v[0]
    for i in range(1, len(tab)):
        b = obter_diagonal(tab, i)
        if b[0] == b[1] == b[2] == 1:
            r = b[0]
        elif b[0] == b[1] == b[2] == -1:
            r = b[0]
    return r


def marcar_posicao(tab, p, j):
    if not (eh_tabuleiro(tab) and (j == -1 or j == 1) and eh_posicao(p) and eh_posicao_livre(tab,p)):
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")
    k = ()
    r = ()
    p = p - 1
    if eh_posicao_livre(tab, p):
        for m in range(0, len(tab)):
            for n in range(0, len(tab[m])):
                k = k + (tab[m][n],)  # cria a linha do taboleiro que tem o espaco que se quer alterar
        for i in range(0, len(k)):
            if i != p:
                r = r + (k[i],)
            elif i == p:
                r = r + (j,)
        a = (r[0], r[1], r[2])  # reformata o tabuleiro para um tuplo de 3 tuplos de 3 elementos
        b = (r[3], r[4], r[5])  #
        c = (r[6], r[7], r[8])  #
        r = (a, b, c)
    else:
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")
    return r


def escolher_posicao_manual(tab):
    p = eval(input("Turno do jogador. Escolha uma posicao livre: "))
    if not (eh_tabuleiro(tab) and eh_posicao(p) and eh_posicao_livre(tab, p)):
        raise ValueError("escolher_posicao_manual: a posicao introduzida e invalida")
    return p


def escolher_posicao_auto(tab, jog, dif):
    """ para simplificar a ordem das estrategias, decidi renomea-las pela ordem que devem ser executadas,
     logo, as estrategias mais importantes, vitoria e o boqueio da vitoria, sao as primeiras a seram processadoas,
     com o nome strat1 e strat2 respetivamente, quanto maior o valor da estrategia, mais alternativa sera,
     apenas e executada se todas as anteriores nao tiverem dado resultado"""
    player = jog
    enemy = jog * -1
    if dif == "basico":
        if strat5(tab) != 0:
            if eh_posicao_livre(tab, strat5(tab)):
                return strat5(tab)
        if strat7(tab) != 0:
            if eh_posicao_livre(tab, strat7(tab)):
                return strat7(tab)
        if strat8(tab) != 0:
            if eh_posicao_livre(tab, strat8(tab)):
                return strat8(tab)
    if dif == "normal":
        if strat1(tab, enemy) != 0:  # como desenvolvi uma strategia de vitoria, observa se o
            # computador esta quase a ganhar, com duas casas preenchidas e uma vazia em linha, apenas e necessario
            # observar os outros simbulos para saber se o enimigo esta quase a ganhar, por isso podemos utilisar a
            # estrategia da vitoria para a de derrota, invertendo o valor logico do simbulo do computador
            if eh_posicao_livre(tab, strat1(tab, enemy)):
                return strat1(tab, enemy)
        if strat1(tab, player) != 0:  # de acordo com o ultimo comentario, para a estrategia de derrota, inverti
            # o input do valor do simbulo usado pelo computador, para este se defender da derrota
            if eh_posicao_livre(tab, strat1(tab, player)):
                return strat1(tab, player)
        if strat5(tab) != 0:
            if eh_posicao_livre(tab, strat5(tab)):
                return strat5(tab)
        if strat6(tab, player) != 0:
            if eh_posicao_livre(tab, strat6(tab, player)):
                return strat6(tab, player)
        if strat7(tab) != 0:
            if eh_posicao_livre(tab, strat7(tab)):
                return strat7(tab)
        if strat8(tab) != 0:
            if eh_posicao_livre(tab, strat8(tab)):
                return strat8(tab)
    if dif == "perfeito":
        if strat1(tab, enemy) != 0:
            if eh_posicao_livre(tab, strat1(tab, enemy)):
                return strat1(tab, enemy)
        if strat1(tab, jog) != 0:
            if eh_posicao_livre(tab, strat1(tab, jog)):
                return strat1(tab, jog)
        if not (len(obter_posicoes_livres(tab)) == 8 or len(obter_posicoes_livres(tab)) == 7):
            if strat3(tab, player) != 0:
                if eh_posicao_livre(tab, strat3(tab, player)):
                    return strat3(tab, player)
        if not (len(obter_posicoes_livres(tab)) == 8 or len(obter_posicoes_livres(tab)) == 7):
            if strat3(tab, enemy) != 0:  # para bloquear a biforcacao, optei por,
                # ocupar a casa onde o inimigo pode fazer o bloqueio, pois assim fica a coluna,
                # linha e diagonal, inaptuas para fazer uma outra biforcacao para as proximas jogadas
                if eh_posicao_livre(tab, strat3(tab, enemy)):
                    return strat3(tab, enemy)
        if strat5(tab) != 0:
            if eh_posicao_livre(tab, strat5(tab)):
                return strat5(tab)
        if strat6(tab, player) != 0:
            if eh_posicao_livre(tab, strat6(tab, player)):
                return strat6(tab, player)
        if strat7(tab) != 0:
            if eh_posicao_livre(tab, strat7(tab)):
                return strat7(tab)
        if strat8(tab) != 0:
            if eh_posicao_livre(tab, strat8(tab)):
                return strat8(tab)


def strat1(tab, jogador):
    """ caso uma linha/coluna/diagonal tenha uma casa vazia e duas casas preenchidas por 2 simbulos iguais
     retorna a posicao livre, desta forma, o jogador ou faz a jogada para a vitoria, ou caso nao consiga ganhar faz
     a jogada para se defender da derrota"""
    line = 1
    col = 1
    diag = 1
    for i in obter_posicoes_livres(tab):

        if 1 <= i <= 3:
            col = i
            line = 1
        elif 4 <= i <= 6:
            col = i - 3
            line = 2
        elif 7 <= i <= 9:
            col = i - 6
            line = 3
        if i == 1 or i == 3 or i == 5 or i == 7 or i == 9:
            if i == 1 or i == 5 or i == 9:
                diag = 1
            elif i == 3 or i == 5 or i == 7:
                diag = 2
            if obter_diagonal(tab, diag)[0] + obter_diagonal(tab, diag)[1] + obter_diagonal(tab, diag)[
                2] == 2 * jogador:
                return i
        if obter_linha(tab, line)[0] + obter_linha(tab, line)[1] + obter_linha(tab, line)[2] == 2 * jogador:
            return i
        if obter_coluna(tab, col)[0] + obter_coluna(tab, col)[1] + obter_coluna(tab, col)[2] == 2 * jogador:
            return i
    return 0


# biforcacao
def strat3(tab, jog):
    """ input: tabuleiro e jogador. Para processar a possibilidade de uma biforcacao, decidi somar todos os valores
    dos simbulos presentes na coluna, linha ou diagonal de uma posicao livre,e se duas destas somas der o mesmo que o
    valor de um simbulo, significa que ha duas linhas que se interssetam nesta casa livre, por isso se o computador
    preencher a casa, na proxima jogada, tera dois casos de vitoria possivel """
    line = 1
    col = 1
    diag = 1
    for i in obter_posicoes_livres(tab):
        if i == 1 or i == 5 or i == 9:
            diag = 1
        elif i == 3 or i == 5 or i == 7:
            diag = 2
        if 1 <= i <= 3:
            col = i
            line = 1
        elif 4 <= i <= 6:
            col = i - 3
            line = 2
        elif 7 <= i <= 9:
            col = i - 6
            line = 3
        if jog == obter_linha(tab, line)[0] + obter_linha(tab, line)[1] + obter_linha(tab, line)[2]:
            if jog == obter_coluna(tab, col)[0] + obter_coluna(tab, col)[1] + obter_coluna(tab, col)[2]:
                return i
            elif jog == obter_diagonal(tab, diag)[0] + obter_diagonal(tab, diag)[1] + obter_diagonal(tab, diag)[2]:
                return i
        if obter_coluna(tab, col)[0] + obter_coluna(tab, col)[1] + obter_coluna(tab, col)[2] == jog:
            if jog == obter_linha(tab, line)[0] + obter_linha(tab, line)[1] + obter_linha(tab, line)[2]:
                return i
            elif jog == obter_diagonal(tab, diag)[0] + obter_diagonal(tab, diag)[1] + obter_diagonal(tab, diag)[2]:
                return i

        if obter_diagonal(tab, diag)[0] + obter_diagonal(tab, diag)[1] + obter_diagonal(tab, diag)[2] == jog:
            if obter_linha(tab, line)[0] + obter_linha(tab, line)[1] + obter_linha(tab, line)[2] == jog:
                return i
            elif obter_coluna(tab, col)[0] + obter_coluna(tab, col)[1] + obter_coluna(tab, col)[2] == jog:
                return i
    return 0


# jogar no centro, se este estiver livre
def strat5(tab):
    pos = 5
    if eh_posicao_livre(tab, pos):
        return 5
    else:
        return 0


def strat6(tab, jog):
    for i in range(0, 2, 2):
        for m in range(0, 2, 2):
            if tab[i][m] == jog * -1:
                if i == 2 and m == 2:
                    return 1
                if i == 2 and m == 0:
                    return 3
                else:
                    if m == 0:
                        return 9
                    if m == 2:
                        return 7
            else:
                return 0


def strat7(tab):
    pos = 1
    if eh_posicao_livre(tab, pos):
        return pos
    pos = 3
    if eh_posicao_livre(tab, pos):
        return pos
    pos = 7
    if eh_posicao_livre(tab, pos):
        return pos
    pos = 9
    if eh_posicao_livre(tab, pos):
        return pos
    else:
        return 0


def strat8(tab):
    for pos in range(2, 8, 2):
        if eh_posicao_livre(tab, pos):
            return pos
        else:
            return 0


def preencher_casa(tab, casa, jogador):
    """funcao equivalente a marcar_posicao, porem escrita de uma maneira dierente,para ser compativel com a funcao jogo_do_galo
    input: tabuleiro a editar , posicao a editar , indice do simbulo do jogador (1 ou -1)
    output: tabuleiro com a posicao "casa" editada"""
    i = 0
    tabfinal = ()
    linhatemp = ()
    if 1 <= casa <= 3:
        i, casa = 0, casa
    if 4 <= casa <= 6:
        i, casa = 1, casa - 3
    if 7 <= casa <= 9:
        i, casa = 2, casa - 6
    for j in range(0, 3):
        if j == casa - 1:
            linhatemp = linhatemp + (jogador,)
        else:
            linhatemp = linhatemp + (tab[i][j],)
    if i == 0:
        tabfinal = (linhatemp, tab[1], tab[2])
    if i == 1:
        tabfinal = (tab[0], linhatemp, tab[2])
    if i == 2:
        tabfinal = (tab[0], tab[1], linhatemp)
    return tabfinal


def analisa_vitoria(tab):
    if jogador_ganhador(tab) == 1:
        return "X"
    elif jogador_ganhador(tab) == -1:
        return "O"
    else:
        return 0


def jogo_do_galo(jog, dif):
    simb = 0
    if not (jog == "O" or jog == "X"):
        raise ValueError("jogo do galo: algum dos argumentos e invalido")
    if jog == "O":
        jog = -1
        simb = "O"
    elif jog == "X":
        jog = 1
        simb = "X"
    print("Bem-vindo ao JOGO DO GALO.")
    print("O jogador joga com '" + simb + "'.")
    dif = dif
    pc = jog * -1
    tab = ((0, 0, 0), (0, 0, 0), (0, 0, 0))  # garante que o tabuleiro comeca vazio

    if jog == 1:
        # vez_do_player
        move = escolher_posicao_manual(tab)
        tab = preencher_casa(tab, move, jog)
        print(tabuleiro_str(tab))
    # vez_do_pc
    if analisa_vitoria(tab) != 0:
        return analisa_vitoria(tab)
    print("Turno do computador (" + dif + "):")
    move = escolher_posicao_auto(tab, pc, dif)
    tab = preencher_casa(tab, move, pc)  # (tab, move) --> (tab com a casa "move" nova)
    print(tabuleiro_str(tab))
    for jogadas_left in range(5, 0, -1):
        # vez_do_player
        if analisa_vitoria(tab) != 0:
            return analisa_vitoria(tab)
        move = escolher_posicao_manual(tab)
        tab = preencher_casa(tab, move, jog)
        print(tabuleiro_str(tab))
        if verifica_empate(tab) != 0:
            return verifica_empate(tab)
        # vez_do_pc
        if analisa_vitoria(tab) != 0:
            return analisa_vitoria(tab)
        print("Turno do computador (" + dif + "):")
        move = escolher_posicao_auto(tab, pc, dif)
        if len(obter_posicoes_livres(tab)) != 0:
            tab = preencher_casa(tab, move, pc)  # (tab, move) --> (tab com a casa "move" nova)
        print(tabuleiro_str(tab))
        if verifica_empate(tab) != 0:
            return verifica_empate(tab)


def verifica_empate(tab):
    if len(obter_posicoes_livres(tab)) == 0:
        analisa_vitoria(tab)
        if analisa_vitoria(tab) == 0:
            return "EMPATE"
    return 0