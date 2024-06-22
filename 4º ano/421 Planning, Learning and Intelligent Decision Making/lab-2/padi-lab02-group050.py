import numpy as np

def load_mdp(file_name, gamma):
    data = np.load(file_name, allow_pickle=True)

    X = tuple(data['X'])
    A = tuple(data['A'])
    P = tuple(data['P'])
    c = data['c']
    g = gamma

    return (X, A, P, c, g)



def noisy_policy(mdp:tuple, a:int, eps:float) -> np.ndarray:
    X, A, P, _, _ = mdp

    policy = np.full((len(X), len(A)), eps / (len(A) - 1))
    
    # policy[:, a] = 1 - eps
    for i in policy:
        i[a] = 1 - eps

    return policy


def evaluate_pol(mdp: tuple, policy: np.ndarray) -> np.ndarray:
    X, A, P, c, g = mdp

    cpi = np.sum(c * policy, axis=1, keepdims=True)
    Ppi = policy[:, 0, None] * P[0]
    
    for a in range(1, len(A)):
        Ppi += policy[:, a, None] * P[a]

    J = np.dot(np.linalg.inv(np.eye(len(X)) - g * Ppi), cpi)
    num_states = len(X)
    return J.reshape((num_states, 1))

import numpy as np
from numpy.linalg import norm
import time

def value_iteration(mdp):
    X, A, P, c, gamma = mdp

    start_time = time.time()

    J = np.zeros((len(X), 1))
    err = 1
    niter = 0

    while err > 1e-8:
        Q = np.zeros((len(X), len(A)))

        for a in range(len(A)):

            temp = gamma * P[a].dot(J)
            Q[:, a, None] = c[:, a, None] + temp
        
        Jnew = np.min(Q, axis=1, keepdims=True)

        err = np.linalg.norm(Jnew - J)

        J = Jnew
        niter += 1

    execution_time = round(time.time() - start_time, 3)
    print(f"Execution time: {execution_time} seconds")
    print(f"N. iterations: {niter}")

    return J

import time
def policy_iteration(mdp:tuple):
    beg = time.time()
    X, A, P, c, g = mdp
    pol = np.ones( (len(X), len(A))) / len(A)
    quit = False
    niter = 0
    while not quit:
        # Auxiliary array to store intermediate values
        Q = np.zeros((len(X), len(A)))

        # Policy evaluation
        cpi = np.sum(c * pol, axis=1, keepdims=True)
        Ppi = pol[:, 0, None] * P[0]
        
        for a in range(1, len(A)):
            Ppi += pol[:, a, None] * P[a]
        
        J = np.linalg.inv(np.eye(len(X)) - g * Ppi).dot(cpi)
        
        # Compute 0-values
        for a in range(len (A)):
            Q[:, a, None] = c[:, a, None] + g * P[a].dot(J)
        
        # Compute greedy policy
        Qmin = np.min(Q, axis=1, keepdims=True)

        pnew = np.isclose (Q, Qmin, atol=1e-8, rtol=1e-8).astype (int)
        pnew = pnew / pnew.sum(axis = 1, keepdims = True)

        # Compute stopping condition
        quit = (pol == pnew).all()

        # Update
        pol = pnew
        niter += 1

    end = time.time()
    print(f"Execution time: {end-beg} seconds")
    print(f"N. iterations: {niter}")
    return pol

NRUNS = 100 # Do not delete this

def simulate(mdp, policy, x0, length):
    X, A, P, c, gamma = mdp
    num_actions = len(A)

    NRUNS = 100
    total_cost = 0.0

    for _ in range(NRUNS):
        current_state = x0
        trajectory_cost = 0.0
        discount = 1.0

        for _ in range(length):
            action_probabilities = policy[current_state]
            chosen_action = np.random.choice(num_actions, p=action_probabilities)
            
            # Simulate the next state based on the chosen action
            next_state = np.random.choice(len(X), p=P[chosen_action][current_state])

            # Accumulate the cost
            trajectory_cost += discount * c[current_state, chosen_action]

            current_state = next_state
            discount *= gamma

        total_cost += trajectory_cost

    # Compute the average cost over the 100 trajectories
    average_cost = total_cost / NRUNS

    return average_cost


