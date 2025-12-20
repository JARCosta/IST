import numpy as np

def load_pomdp(filename:str, gamma:float):
    file = np.load(filename, allow_pickle=True)
    X = file['X']
    A = file['A']
    Z = file['Z']
    P = file['P']
    O = file['O']
    c = file['c']
    return (X, A, Z, tuple(P), tuple(O), c, gamma)
 
import numpy as np

def gen_trajectory(pomdp: tuple, x0: int, n: int) -> tuple:
    X, A, Z, P, O, c, gamma = pomdp

    states = np.zeros(n + 1, dtype=int)
    actions = np.zeros(n, dtype=int)
    observations = np.zeros(n, dtype=int)

    states[0] = x0

    x = x0
    for i in range(n):

        action_idx = np.random.randint(len(A))
        action = A[action_idx]
        actions[i] = action_idx
        
        next_state_probs = P[action_idx][x]
        next_state_idx = np.random.choice(len(X), p=next_state_probs)
        states[i+1] = next_state_idx
        
        observation_probs = O[action_idx][next_state_idx]
        observation_idx = np.random.choice(len(Z), p=observation_probs)
        observations[i] = observation_idx
        
        x = next_state_idx
        
    return states, actions, observations




import numpy.random as rand
import numpy as np

def belief_update(pomdp, belief, action, observation):
    X, A, Z, P, O, c, gamma = pomdp
    belief_updated = []
    
    b= np.dot(belief, P[action])
    b= np.dot(b, np.diag(O[action][:, observation]))
    belief_updated = b

    belief_updated /= np.sum(belief_updated)
    
    return belief_updated

def sample_beliefs(pomdp, n):
    X, A, Z, P, O, c, gamma = pomdp
    num_states = len(X) 

    beliefs = []
    traj_states, traj_actions, traj_observations = gen_trajectory(pomdp, np.random.randint(len(pomdp[0])), n)

    belief = np.ones(len(X),dtype=float) / len(X)
    beliefs.append(belief)
    
    for action, observation in zip(traj_actions, traj_observations):
        belief = belief_update(pomdp, belief, action, observation)
        unique = True
        for b in beliefs:
            if np.linalg.norm(b - belief) < 1e-3:
                unique = False
                break
        if unique:
            beliefs.append(belief)
    new_beliefs=[]
    for b in beliefs:
        new = b.reshape((1, num_states))
        new_beliefs.append(new)
    return tuple(new_beliefs)




import numpy as np

def solve_mdp(pomdp):
    X, A, Z, P, O, c, gamma = pomdp
    num_states = len(X)
    num_actions = len(A)
    
    Q = np.zeros((num_states, num_actions))
    
    T = np.zeros((num_states, num_states, num_actions))
    for a in range(num_actions):
        for x in range(num_states):
            for xp in range(num_states):
                for zp in range(len(Z)):
                    T[x, xp, a] += P[a][x, xp] * O[a][xp, zp]

    R = np.zeros((num_states, num_actions))
    for a in range(num_actions):
        R[:, a] = -c[:, a]
    
    error = 1
    while error > 1e-8:
        Q_new = np.zeros_like(Q)
        for a in range(num_actions):
            Q_new[:, a] = R[:, a] + gamma * np.max(np.sum(T * Q, axis=1), axis=1)
        
        error = np.max(np.abs(Q_new - Q))
        Q = Q_new
    
    return Q




def get_heuristic_action(belief:np.array, Q_function, param:str):
    num_states, num_actions = Q_function.shape
    policy = np.zeros(num_states, dtype=int)  
    
    for s in range(num_states):
        best_action = np.argmax(Q_function[s])
        policy[s] = best_action

    possibilities = np.zeros(num_actions)
    if param == "mls":
        return policy[rand.choice(np.where(belief == np.max(belief))[0])]
        return policy[np.argmax(belief)]
    
    elif param == "av":
        for a in range(num_actions):
            for x in range(num_states):
                if a == policy[x]:
                    possibilities[a] += belief[0, x]
        return rand.choice(np.where(possibilities == np.max(possibilities))[0])
        
    elif param == "q-mdp":  
        for a in range(num_actions):
            for x in range(len(belief)):
                possibilities[a] += belief[0,x] * Q_function[x, a]
        return rand.choice(np.where(possibilities == np.min(possibilities))[0])





def solve_fib(pomdp):
    X, A, Z, P, O, c, gamma = pomdp
    num_states = len(X)
    num_actions = len(A)

    Q = np.zeros((num_states, num_actions))

    error = 1
    while error > 1e-1:
        Q_new = np.zeros_like(Q)

        for a in range(num_actions):
            # Q_new[:, a] = c[:, a] + gamma * (P[a] * np.min(Q))

            for x in range(num_states):
                Q_new[x, a] = c[x, a]
                for z in range(len(Z)):
                    Q_new[x, a] += gamma * np.sum(P[a][x] * O[a][:, z] * np.min(Q, axis=1))

        error = np.max(np.abs(Q_new - Q))
        Q = Q_new
    
    return Q

