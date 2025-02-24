# takuzu.py: Template para implementação do projeto de Inteligencia Artificial 2021/2022.
# Devem alterar as classes e funções neste ficheiro de acordo com as instruções do enunciado.
# Além das funções e classes já definidas, podem acrescentar outras que considerem pertinentes.

# Grupo 33:
# 99071 Francisco Sanchez
# 99088 João Costa

import sys
import numpy as np
import time
from search import (
    Problem,
    Node,
    astar_search,
    breadth_first_tree_search,
    depth_first_tree_search,
    greedy_search,
    recursive_best_first_search,
)


class TakuzuState:
    state_id = 0

    def __init__(self, board):
        self.board = board
        self.id = TakuzuState.state_id
        TakuzuState.state_id += 1

    def __lt__(self, other):
        return self.id < other.id

    # TODO: outros metodos da classe


class Board:
    """Representação interna de um tabuleiro de Takuzu."""

    def __init__(self, size, list):
        self.size = size
        self.list = np.array(list)
        self.option = True

    def get_number(self, row: int, col: int) -> int:
        """Devolve o valor na respetiva posição do tabuleiro."""
        # TODO
        return self.list[row][col]

    def adjacent_vertical_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente abaixo e acima,
        respectivamente."""
        # TODO
        if row == self.size - 1:
            below = None
        else:
            below = self.list[row + 1][col]

        if row == 0:
            above = None
        else:
            above = self.list[row - 1][col]

        return below, above

    def adjacent_horizontal_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente à esquerda e à direita,
        respectivamente."""
        # TODO
        if col == self.size - 1:
            right = None
        else:
            right = self.list[row][col + 1]

        if col == 0:
            left = None
        else:
            left = self.list[row][col - 1]

        return left, right

    @staticmethod
    def parse_instance_from_stdin():
        """Lê o test do standard input (stdin) que é passado como argumento
        e retorna uma instância da classe Board.

        Por exemplo:
            $ python3 takuzu.py < input_T01

            > from sys import stdin
            > stdin.readline()
        """
        # TODO
        from sys import stdin
        list = []
        size = int(stdin.readline())
        for i in range(size):
            line = stdin.readline()
            sublist = []
            line_split = line.strip().split('\t')
            for num in line_split:
                sublist.append(int(num))
            list.append(sublist)
        board = Board(size, list)
        return board

    # TODO: outros metodos da classe

    def __repr__(self):
        rep = ""
        for i in range(self.size):
            for j in range(self.size):
                if j == self.size - 1:
                    rep += "{}\n" .format(self.list[i][j])
                else:
                    rep += "{}\t" .format(self.list[i][j])
        return rep


class Takuzu(Problem):
    def __init__(self, board: Board):
        """O construtor especifica o estado inicial."""
        # TODO
        self.board = board
        tak_state = TakuzuState(board)
        super().__init__(tak_state)
        pass

    def ammount_in_line_column(self, state: TakuzuState, line: int, column: int):
        num = self.board.size // 2
        num += self.board.size % num
        res = []
        if np.count_nonzero(state.board.list == 0, axis=1)[line] >= num:
            res.append(0)
        if np.count_nonzero(state.board.list == 1, axis=1)[line] >= num:
            res.append(1)
        if np.count_nonzero(state.board.list == 0, axis=0)[column] >= num:
            res.append(0)
        if np.count_nonzero(state.board.list == 1, axis=0)[column] >= num:
            res.append(1)
        res_set = set(res)
        if len(res_set) == 1:
            return res[0]
        elif len(res_set) == 2:
            return -1
        else:
            return 2

    def adjacents_in_line_column(self, state: TakuzuState, line: int, column: int):
        res = []
        if column < state.board.size - 2:
            if state.board.list[line][column + 1] == state.board.list[line][column + 2] and \
                    state.board.list[line][column + 1] != 2:
                res.append(state.board.list[line][column + 1])
        if 0 < column < state.board.size - 1:
            if state.board.list[line][column - 1] == state.board.list[line][column + 1] and \
                    state.board.list[line][column + 1] != 2:
                res.append(state.board.list[line][column + 1])
        if column > 1:
            if state.board.list[line][column - 1] == state.board.list[line][column - 2] and \
                    state.board.list[line][column - 1] != 2:
                res.append(state.board.list[line][column - 1])
        if line < state.board.size - 2:
            if state.board.list[line + 1][column] == state.board.list[line + 2][column] and \
                    state.board.list[line + 1][column] != 2:
                res.append(state.board.list[line + 1][column])
        if 0 < line < state.board.size - 1:
            if state.board.list[line - 1][column] == state.board.list[line + 1][column] and \
                    state.board.list[line + 1][column] != 2:
                res.append(state.board.list[line + 1][column])
        if line > 1:
            if state.board.list[line - 1][column] == state.board.list[line - 2][column] and \
                    state.board.list[line - 1][column] != 2:
                res.append(state.board.list[line - 1][column])
        res_set = set(res)
        if len(res_set) == 1:
            return res[0]
        elif len(res_set) == 2:
            return -1
        else:
            return 2

    def actions(self, state: TakuzuState):
        """Retorna uma lista de ações que podem ser executadas a
        partir do estado passado como argumento."""
        # TODO
        action_list = []
        for i in range(state.board.size - 1, -1, -1):
            for j in range(state.board.size - 1, -1, -1):
                if state.board.list[i][j] == 2:
                    x = self.ammount_in_line_column(state, i, j)
                    if x == -1:
                        return []
                    if x == 2:
                        y = self.adjacents_in_line_column(state, i, j)
                        if y == -1:
                            return []
                        if y == 2:
                            action_list.append((i, j, 0))
                            action_list.append((i, j, 1))
                        elif y == 1:
                            return [(i, j, 0)]
                        elif y == 0:
                            return [(i, j, 1)]
                    elif x == 1:
                        return [(i, j, 0)]
                    elif x == 0:
                        return [(i, j, 1)]
        if len(action_list) == 0:
            return []
        return [action_list[0], action_list[1]]

    def result(self, state: TakuzuState, action):
        """Retorna o estado resultante de executar a 'action' sobre
        'state' passado como argumento. A ação a executar deve ser uma
        das presentes na lista obtida pela execução de
        self.actions(state)."""
        # TODO
        line = action[0]
        column = action[1]
        res = action[2]
        new_list = np.copy(state.board.list)
        new_list[line][column] = res
        new_board = Board(state.board.size, new_list)
        res_state = TakuzuState(new_board)
        return res_state

    def adjacent_check(self, state: TakuzuState):
        for i in range(state.board.size):
            for j in range(state.board.size):
                if j < state.board.size - 2:
                    if state.board.list[i][j] == state.board.list[i][j + 1] == state.board.list[i][j + 2]:
                        return False
                if i < state.board.size - 2:
                    if state.board.list[i][j] == state.board.list[i + 1][j] == state.board.list[i + 2][j]:
                        return False
        return True

    def goal_test(self, state: TakuzuState):
        """Retorna True se e só se o estado passado como argumento é
        um estado objetivo. Deve verificar se todas as posições do tabuleiro
        estão preenchidas com uma sequência de números adjacentes."""
        # TODO
        if 2 in state.board.list:
            return False

        if len(np.unique(state.board.list, axis=0)) != state.board.size or\
                len(np.unique(np.rot90(state.board.list), axis=0)) != state.board.size:
            return False
        return self.adjacent_check(state)


    def h(self, node: Node):
        """Função heuristica utilizada para a procura A*."""
        # TODO
        pass

    # TODO: outros metodos da classe



if __name__ == "__main__":
    # TODO:
    # Ler o ficheiro do standard input,
    #start = time.time()
    board = Board.parse_instance_from_stdin()
    problem = Takuzu(board)
    # Obter o nó solução usando a procura em profundidade:
    goal_node = depth_first_tree_search(problem)


    # Verificar se foi atingida a solução

    print(goal_node.state.board, end="")
    with open('readme.txt', 'w') as f:
        f.write(goal_node.state.board.__repr__())
    #end = time.time()
    #print(end - start)
    # Usar uma técnica de procura para resolver a instância,
    # Retirar a solução a partir do nó resultante,
    # Imprimir para o standard output no formato indicado.
    #board.__repr__()
    pass