import numpy as np
from pettingzoo_env import ACTIONS

class CollisionAvoiderAgent:

    def __init__(self, n_agents, agent_id, n_actions: int):
        self.n_actions = n_actions
        self.n_agents = n_agents
        self.agent_id = agent_id
        self.observation = None
        self.position = None
        self.goal = None
        self.occupied_positions = {}

    def action(self) -> int:
        # Greedy action selection
        vert, hor = np.array(self.goal) - self.position
        down = vert/abs(vert) if vert != 0 else 0
        right = hor/abs(hor) if hor != 0 else 0
        action = [down, right]
        if 0 not in action:
            action[np.random.randint(0, 2)] = 0

        # Check if the action would cause a collision (another agent already took that position [in-cell] or is switching positions with this agent [out-cell])
        possible_actions = []
        for t_action in ACTIONS.values():

            id_pos = "" + str(int(list(self.position)[0])) + str(int(list(self.position)[1]))
            id_t = "" + str(int(list(self.position + t_action)[0])) + str(int(list(self.position + t_action)[1]))

            # Check out-cell collisions
            if id_pos in self.occupied_positions.keys():
                if (self.occupied_positions[id_pos][1] == -1 * np.array(t_action)).all():
                    continue

            # Check in-cell collisions
            if id_t not in self.occupied_positions.keys():
                possible_actions.append(t_action)

        # If the Greedy action is not possible, pick a random possible action
        if action not in possible_actions:
            action = possible_actions[np.random.randint(0, len(possible_actions))]
        # print(self.agent_id+1, self.occupied_positions, self.position, action, id_t, len(possible_actions), id_t not in self.occupied_positions.keys())
        # print(self.agent_id+1, action, possible_actions)
        return action

    def communicate(self, action, agent_list):
        self.occupied_positions = {}
        for agent in agent_list[self.agent_id+1:]:
            man_dist = sum(np.absolute(agent.position - self.position))
            if man_dist <= 2:
                id = "" + str(int(list(self.position + action)[0])) + str(int(list(self.position + action)[1]))
                agent.occupied_positions[id] = [self.position, action]
        return action
        
    def see(self, observation):
        self.observation = observation
        self.position = np.array([observation[0][self.agent_id * 2], observation[0][self.agent_id * 2 + 1]])
        self.goal = np.array([observation[1][self.agent_id * 2], observation[1][self.agent_id * 2 + 1 ]])

    def next(self, observation, action, next_observation, reward, terminal, info):
        # Not a learning agent
        pass