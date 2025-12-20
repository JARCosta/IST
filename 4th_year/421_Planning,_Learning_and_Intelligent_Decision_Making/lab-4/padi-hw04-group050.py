import numpy as np

mdp_info = np.load('taxi.npz', allow_pickle=True)

# The MDP is a tuple (X, A, P, c, gamma)
M = tuple(mdp_info['M'])

# We also load the optimal Q-function for the MDP
Qopt = mdp_info['Q']





import numpy as np

def sample_transition(mdp:tuple, x:int, a:int):
    X, A, P, c, gamma = mdp 
    cost = c[x][a]
    x_new = rnd.choice(np.where(P[a][x] == np.max(P[a][x]))[0])
    return x, a, cost, x_new



import numpy as np

def egreedy(Q, eps: float=0.1):
    if rnd.random() < eps:
        return rnd.choice(range(len(Q)))
    else:
        return rnd.choice(np.where(Q == np.min(Q))[0])
    



import numpy as np
import numpy.random as rnd
def mb_learning(mdp:tuple, n:int, qinit:np.array, Pinit:tuple, cinit:np.array):
    X, A, P_mdp, c_mdp, gamma = mdp
    x = rnd.randint(len(X))
    N = len(A)
    Q = qinit
    P = Pinit
    c = cinit
    N_t = np.zeros((len(X), N))
    for _ in range(n):
        a = egreedy(Q[x], 0.15)
        _, _, cost, x_new= sample_transition(mdp, x, a)

        alpha = 1 / (N_t[x][a] + 1)
        P += alpha * (np.eye(len(X))[x_new] - P)
        c += alpha * (cost - c) 

        N_t[x][a] += 1

        Q_next_min = np.min(Q, axis=1)
        Q_next = np.dot(P[a][x], Q_next_min)
        
        # Update Q-values using the provided equation
        Q[x][a] = c[x][a] + gamma * np.sum(Q_next)
        x = x_new
    return Q, tuple(P), c



def qlearning(mdp: tuple, n: int, qinit: np.ndarray):
    X, A, _, _, gamma = mdp

    Q = qinit.copy()
    
    x = rnd.randint(len(X))
    
    for _ in range(n):
        
        a = egreedy(Q[x], eps=0.15)
        
        x, a, cost, x_prime = sample_transition(mdp, x, a)
        
        alpha = 0.3
        Q[x, a] = Q[x, a] + alpha * (cost + gamma * np.max(Q[x_prime]) - Q[x, a])
        
        x = x_prime
    
    return Q


def sarsa(mdp:tuple, n:int, qinit:np.array):
    X, A, P, c, gamma = mdp
    n_states = len(X)
    x = rnd.randint(n_states)
    Q = qinit
    a = egreedy(Q[x], 0.15)

    for _ in range(n):
        _, _, cost, x_new = sample_transition(mdp, x, a)
        a_new = egreedy(Q[x_new], 0.15)
        Q[x][a] = Q[x][a] + 0.3 * (cost + gamma * Q[x_new][a_new] - Q[x][a])
        x = x_new
        a = a_new
    return Q



"""

SARSA (on-policy)
Obtém menores erros mais rapidamente, mas não converge exatamente para a politica optima.
Toma uma rota mais segura devido à probablididade, epsilon, de escolher um movimento aleatório, que o pode levar a cair do penhasco, como representado no caso do cliff walking.

Pode convergir para politica otima se o valor de epsilon for diminuindo ao longo das iterações (faz de cada vez menos random moves)

Q-learning (off-policy)
Necessita de mais iteracoes para convergir, mas converge para a politica otima diretamente.


"""



