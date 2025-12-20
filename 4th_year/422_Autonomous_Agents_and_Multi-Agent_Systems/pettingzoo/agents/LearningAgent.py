import numpy as np
from collections import defaultdict
from pettingzoo_env import ACTIONS

class LearningAgent:

    def __init__(self, n_agents, agent_id, n_actions, learning_rate=0.3, discount_factor=0.99, exploration_rate=0.15, initial_q_values=0.0):
        self._default_value = np.ones(n_actions) * initial_q_values
        self._Q = {}
        self._learning_rate = learning_rate
        self._discount_factor = discount_factor
        self._exploration_rate = exploration_rate
        self.n_actions = n_actions
        self.agent_id = agent_id
        self.observation = None
        self.position = None
        self.goal = None

    def action(self):

        # x = tuple(np.array(self.observation).flatten())
        # x = tuple(self.position) + tuple(self.goal)
        x = tuple(self.observation[0]) + tuple(self.observation[1])
        # print("x:", x)
        # input()

        q_values = self._Q.get(x, self._default_value)

        

        if not self.training or (self.training and np.random.uniform(0, 1) > self._exploration_rate):
            # Exploit
            actions = np.argwhere(q_values == np.max(q_values)).reshape(-1)
            # print(x, q_values, actions)
            # input()
            # print("actions:", actions)
        else:
            # Explore
            actions = range(self.n_actions)
        action = list(ACTIONS.values())[np.random.choice(actions)]
        # print(action)
        return action

    def next(self, action, next_observation, reward):
        actions = list(ACTIONS.values())
        
        # print("action:", action, actions.index(action))

        # print("agent_id", self.agent_id)
        # print("curr",tuple(self.observation[0]) + tuple(self.observation[1]))
        # print("action", action)
        # print("next", next_observation)
        # input()

        x, a, r, y = tuple(self.observation[0]) + tuple(self.observation[1]), actions.index(action), reward, tuple(next_observation)
        
        # print(x, a, y)
        # print(self._Q.get(x, self._default_value)[a])
        # input()
        
        alpha, gamma = self._learning_rate, self._discount_factor

        Q_xa, Q_y = float(self._Q.get(x, self._default_value)[a]), self._Q.get(y, self._default_value)
        max_Q_ya = max(Q_y)
        # TODO - Update rule for Q-Learning
        if x not in self._Q:
            self._Q[x] = self._default_value.copy()
        self._Q[x][a] = self._Q[x][a] + alpha * (r[self.agent_id] + gamma * max_Q_ya - Q_xa)
        
    def train(self):
        self.training = True

    def eval(self):
        self.training = False

    def see(self, observation):
        self.observation = observation
        self.position = [observation[0][self.agent_id * 2], observation[0][self.agent_id * 2 + 1]]
        self.goal = [observation[1][self.agent_id * 2], observation[1][self.agent_id * 2 + 1 ]]        

    def communicate(self, action, agent_list):
        return action