import numpy as np
from pettingzoo_env import ACTIONS

class ConventionAgent:

    def __init__(self, n_agents, agent_id, n_actions: int):
        self.n_actions = n_actions
        self.n_agents = n_agents
        self.agent_id = agent_id
        self.observation = None
        self.position = None
        self.goal = None
        self.occupied_positions = []

    def action(self) -> int:
        # Greedy action selection
        vert = self.goal[0] - self.position[0]
        hor = self.goal[1] - self.position[1]
        down = vert/abs(vert) if vert != 0 else 0
        right = hor/abs(hor) if hor != 0 else 0
        action = [down, right]
        if 0 not in action:
            action[np.random.randint(0, 2)] = 0
        
        # Check if the action would cause a collision (another agent already took that position [in-cell])
        possible_actions = []
        for t_action in ACTIONS.values():
            sum = [self.position[0] + t_action[0], self.position[1] + t_action[1]]
            if sum not in self.occupied_positions:
                possible_actions.append(t_action)
        
        # If the Greedy action is not possible, pick a random possible action
        if action not in possible_actions:
            action = possible_actions[np.random.randint(0, len(possible_actions))]
        
        return action

    def communicate(self, action, agent_list):
        self.occupied_positions = []
        for agent in agent_list[self.agent_id+1:]:
            man_dist = abs(agent.position[0] - self.position[0]) + abs(agent.position[1] - self.position[1])
            if man_dist <= 2:
                future_pos = [self.position[0] + action[0], self.position[1] + action[1]]
                agent.occupied_positions.append(future_pos)
        
        return action
        
    def see(self, observation):
        self.observation = observation
        self.position = [observation[0][self.agent_id * 2], observation[0][self.agent_id * 2 + 1]]
        self.goal = [observation[1][self.agent_id * 2], observation[1][self.agent_id * 2 + 1 ]]

    def next(self, observation, action, next_observation, reward, terminal, info):
        # Not a learning agent
        pass