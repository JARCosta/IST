# Add your code here.
import numpy as np

def load_chain(file_name, gamma):

    transition_matrix = np.load(file_name)


    num_states = transition_matrix.shape[0]

    transition_matrix_teleport = np.ones((num_states, num_states)) * (gamma / num_states) + transition_matrix * (1 - gamma)

    state_space = tuple(map(str, range(num_states)))
    
    return state_space, transition_matrix_teleport


def prob_trajectory(chain:tuple, traj):
    states, probs = chain
    prob = 1.0 #initial prob
    p =  int(traj[0])
    for state in traj[1:]:
        prob *= probs[p][int(state)]
        p = int(state)
    return prob

import numpy as np

def stationary_dist(markov_chain):

    transition_matrix = markov_chain[1]

    eigenvalues, eigenvectors = np.linalg.eig(transition_matrix.T)

    index_of_one = np.where(np.isclose(eigenvalues, 1))[0]

    stationary_distribution = eigenvectors[:, index_of_one].real
    stationary_distribution /= np.sum(stationary_distribution)
    
    return stationary_distribution.ravel()


def compute_dist(chain: tuple, vec:np.array, num:int):
    state, probs = chain
    return np.dot(vec, np.linalg.matrix_power(probs, num))


import numpy as np
import numpy.random as rand

def simulate(markov_chain, initial_distribution, N):

    state_space, transition_matrix = markov_chain
    
    trajectory = []
    current_state = rand.choice(state_space, p=np.squeeze(initial_distribution))
    trajectory.append(current_state)
    
    for _ in range(N - 1):
        next_state = rand.choice(state_space, p=transition_matrix[int(current_state)])
        trajectory.append(next_state)
        current_state = next_state
    
    return tuple(trajectory)





# Example usage:

print('- Small chain -')

Msmall = load_chain('example.npy', 0.11)
print('Number of states:', len(Msmall[0]))
print('Transition probabilities:')
print(Msmall[1])

import numpy.random as rand

rand.seed(42)

print('\n- Large chain -')

Mlarge = load_chain('citations.npy', 0.11)
print('Number of states:', len(Mlarge[0]))
x = rand.randint(len(Mlarge[0]))
print('Random state:', Mlarge[0][x])
print('Transition probabilities in random state:')
print(Mlarge[1][x, :])




# Add your code here.
from matplotlib.pyplot import hist, scatter, show
dist = np.ones(len(Msmall[1])) / len(Msmall[1])

traj = simulate(Msmall, dist,50000)
traj = [int(i) for i in traj]
hist(traj, bins=np.arange(len(Msmall[0])+2)-0.5, density=True, rwidth=0.5)

theo_dist = stationary_dist(Msmall)
print(theo_dist)
## add theo_dist to the plot
scatter(range(len(theo_dist)), theo_dist, color='black')

show()
