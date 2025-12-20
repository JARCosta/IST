import numpy as np

class GreedyAgent:

    def __init__(self, n_agents, agent_id, n_actions: int):
        self.n_actions = n_actions
        self.n_agents = n_agents
        self.agent_id = agent_id
        self.observation = None
        self.position = None
        self.goal = None

    def action(self) -> int:

        vert = self.goal[0] - self.position[0]
        hor = self.goal[1] - self.position[1]
        down = vert/abs(vert) if vert != 0 else 0
        right = hor/abs(hor) if hor != 0 else 0
        action = [down, right]
        if 0 not in action:
            action[np.random.randint(0, 2)] = 0
        
        return action
    
    def communicate(self, action, agent_list):
        # Not a communicative agent
        return action
    
    def see(self, observation):
        self.observation = observation
        self.position = [observation[0][self.agent_id * 2], observation[0][self.agent_id * 2 + 1]]
        self.goal = [observation[1][self.agent_id * 2], observation[1][self.agent_id * 2 + 1 ]]

    def next(self, observation, action, next_observation, reward, terminal, info):
        # Not a learning agent
        pass