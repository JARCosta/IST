def teste211():
    total_score = 0
    fun_name = TAD_posicao_funcoes_public

    p1 = cria_posicao('a', '4')
    # ;cria_posicao: argumentos invalidos;

    p1 = cria_posicao('a', '2')
    p2 = cria_posicao('b', '3')
    posicoes_iguais(p1, p2)
    # ;False;

    p1 = cria_posicao('a', '2')
    posicao_para_str(p1)
    # ;a2;

    p2 = cria_posicao('b', '3')
    tuple(posicao_para_str(p) for p in obter_posicoes_adjacentes(p2))
    # ;('b2', 'a3', 'c3');

    return


def teste212():
    total_score = 0
    fun_name = TAD_peca_funcoes_public

    j1 = cria_peca('x')
    # ;cria_peca: argumento invalido;

    j1 = cria_peca('X')
    j2 = cria_peca('O')
    pecas_iguais(j1, j2)
    # ;False;

    j1 = cria_peca('X')
    peca_para_str(j1)
    # ;[X];

    peca_para_inteiro(cria_peca(' '))
    # ;0;

    return



def teste213():
    total_score = 0
    fun_name = TAD_tabuleiro_funcoes_public

    t = cria_tabuleiro()
    tabuleiro_para_str(coloca_peca(t, cria_peca('X'), cria_posicao('a','1')))
    # ;   a   b   c\\n1 [X]-[ ]-[ ]\\n   | \\ | / |\\n2 [ ]-[ ]-[ ]\\n   | / | \\ |\\n3 [ ]-[ ]-[ ];


    t = cria_tabuleiro()
    t1 = coloca_peca(t, cria_peca('X'), cria_posicao('a','1'))
    tabuleiro_para_str(coloca_peca(t, cria_peca('O'),cria_posicao('b','2')))
    # ;   a   b   c\\n1 [X]-[ ]-[ ]\\n   | \\ | / |\\n2 [ ]-[O]-[ ]\\n   | / | \\ |\\n3 [ ]-[ ]-[ ];

    t = cria_tabuleiro()
    t1 = coloca_peca(t, cria_peca('X'), cria_posicao('a','1'))
    t1 = coloca_peca(t, cria_peca('O'),cria_posicao('b','2'))
    tabuleiro_para_str(move_peca(t, cria_posicao('a','1'), cria_posicao('b','1')))
    # ;   a   b   c\\n1 [ ]-[X]-[ ]\\n   | \\ | / |\\n2 [ ]-[O]-[ ]\\n   | / | \\ |\\n3 [ ]-[ ]-[ ];

    t = tuplo_para_tabuleiro(((0,1,-1),(-0,1,-1),(1,0,-1)))
    tabuleiro_para_str(t)
    # ;   a   b   c\\n1 [ ]-[X]-[O]\\n   | \\ | / |\\n2 [ ]-[X]-[O]\\n   | / | \\ |\\n3 [X]-[ ]-[O];

    t = tuplo_para_tabuleiro(((0,1,-1),(-0,1,-1),(1,0,-1)))
    peca_para_str(obter_ganhador(t))
    # ;[O];

    t = tuplo_para_tabuleiro(((0,1,-1),(-0,1,-1),(1,0,-1)))
    tuple(posicao_para_str(p) for p in obter_posicoes_livres(t))
    # ;('a1', 'a2', 'b3');


    t = tuplo_para_tabuleiro(((0,1,-1),(-0,1,-1),(1,0,-1)))
    tuple(peca_para_str(peca) for peca in obter_vetor(t, 'a'))
    # ;('[ ]', '[ ]', '[X]');

    t = tuplo_para_tabuleiro(((0,1,-1),(-0,1,-1),(1,0,-1)))
    tuple(peca_para_str(peca) for peca in obter_vetor(t, '2'))
    # ;('[ ]', '[X]', '[O]');

    return


def teste221():
    total_score = 0
    fun_name = obter_movimento_manual_public


    t = cria_tabuleiro()
    m = obter_movimento_manual_mooshak(t, cria_peca('X'), 'a1')
    posicao_para_str(m[0])
    # ;Turno do jogador. Escolha uma posicao: a1;

    t = tuplo_para_tabuleiro(((0,1,-1),(1,-1,0),(1,-1,0)))
    m =  obter_movimento_manual_mooshak(t, cria_peca('X'), 'b1a1')
    posicao_para_str(m[0]), posicao_para_str(m[1])
    # ;Turno do jogador. Escolha um movimento: ('b1', 'a1');


    t = tuplo_para_tabuleiro(((0,1,-1),(1,-1,0),(1,-1,0)))
    m = obter_movimento_manual_mooshak(t, cria_peca('O'), 'a2a1')
    # ;Turno do jogador. Escolha um movimento: obter_movimento_manual: escolha invalida;

    return



def teste222():
    total_score = 0
    fun_name = obter_movimento_auto_public

    
    t = cria_tabuleiro()
    m = obter_movimento_auto(t, cria_peca('X'), 'facil')
    posicao_para_str(m[0])
    # ;b2;

    t = tuplo_para_tabuleiro(((1,0,-1),(0,1,-1),(1,-1,0)))
    m = obter_movimento_auto(t, cria_peca('X'), 'facil')
    posicao_para_str(m[0]), posicao_para_str(m[1])
    # ;('a1', 'b1');

    t = tuplo_para_tabuleiro(((1,0,-1),(0,1,-1),(1,-1,0)))
    m = obter_movimento_auto(t, cria_peca('X'), 'normal')
    posicao_para_str(m[0]), posicao_para_str(m[1])
    # ;('b2', 'a2');

    t = tuplo_para_tabuleiro(((1,-1,-1),(-1,1,0),(0,0,1)))
    m = obter_movimento_auto(t, cria_peca('X'), 'normal')
    posicao_para_str(m[0]), posicao_para_str(m[1])
    # ;('b2', 'c2');

    t = tuplo_para_tabuleiro(((1,-1,-1),(-1,1,0),(0,0,1)))
    m = obter_movimento_auto(t, cria_peca('X'), 'dificil')
    posicao_para_str(m[0]), posicao_para_str(m[1])
    # ;('c3', 'c2');


    return



def teste223():
    total_score = 0
    fun_name = moinho_public

    moinho_mooshak('[X]', 'facil', 'a2\\na1\\nc1\\nc1c2\\na1b1\\nb1b2')
    # ;Bem-vindo ao JOGO DO MOINHO. Nivel de dificuldade facil.\n   a   b   c\n1 [ ]-[ ]-[ ]\n   | \\ | / |\n2 [ ]-[ ]-[ ]\n   | / | \\ |\n3 [ ]-[ ]-[ ]\nTurno do jogador. Escolha uma posicao:    a   b   c\n1 [ ]-[ ]-[ ]\n   | \\ | / |\n2 [X]-[ ]-[ ]\n   | / | \\ |\n3 [ ]-[ ]-[ ]\nTurno do computador (facil):\n   a   b   c\n1 [ ]-[ ]-[ ]\n   | \\ | / |\n2 [X]-[O]-[ ]\n   | / | \\ |\n3 [ ]-[ ]-[ ]\nTurno do jogador. Escolha uma posicao:    a   b   c\n1 [X]-[ ]-[ ]\n   | \\ | / |\n2 [X]-[O]-[ ]\n   | / | \\ |\n3 [ ]-[ ]-[ ]\nTurno do computador (facil):\n   a   b   c\n1 [X]-[ ]-[ ]\n   | \\ | / |\n2 [X]-[O]-[ ]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do jogador. Escolha uma posicao:    a   b   c\n1 [X]-[ ]-[X]\n   | \\ | / |\n2 [X]-[O]-[ ]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do computador (facil):\n   a   b   c\n1 [X]-[O]-[X]\n   | \\ | / |\n2 [X]-[O]-[ ]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do jogador. Escolha um movimento:    a   b   c\n1 [X]-[O]-[ ]\n   | \\ | / |\n2 [X]-[O]-[X]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do computador (facil):\n   a   b   c\n1 [X]-[ ]-[O]\n   | \\ | / |\n2 [X]-[O]-[X]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do jogador. Escolha um movimento:    a   b   c\n1 [ ]-[X]-[O]\n   | \\ | / |\n2 [X]-[O]-[X]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do computador (facil):\n   a   b   c\n1 [O]-[X]-[O]\n   | \\ | / |\n2 [X]-[ ]-[X]\n   | / | \\ |\n3 [O]-[ ]-[ ]\nTurno do jogador. Escolha um movimento:    a   b   c\n1 [O]-[ ]-[O]\n   | \\ | / |\n2 [X]-[X]-[X]\n   | / | \\ |\n3 [O]-[ ]-[ ]\n[X];

    return

