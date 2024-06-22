import numpy as np

class RandomAgent:

    def __init__(self, n_agents, agent_id, n_actions: int):
        self.n_actions = n_actions
        self.n_agents = n_agents
        self.agent_id = agent_id

    def action(self) -> int:
        actions = [[0, 1], [0, -1], [1, 0], [-1, 0], [0, 0]]
        return actions[np.random.randint(0, len(actions))]
    
    def communicate(self, action, agent_list):
        # Not a communicative agent
        return action

    def see(self, observation):
        # Not an observing agent
        pass

    def next(self, observation, action, next_observation, reward, terminal, info):
        # Not a learning agent
        pass