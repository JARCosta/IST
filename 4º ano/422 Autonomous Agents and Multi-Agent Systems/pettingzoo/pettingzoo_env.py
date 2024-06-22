import gym
from gym import spaces
import numpy as np
import json

ACTIONS = {
    "north":  [-1, 0],
    "west": [0, -1],
    "south": [1, 0],
    "east": [0, 1],
    "wait": [0, 0],
}

REWARDS = {
    "collision": -100,
    "success": 10,
    "step": -1,
}

class PettingZooEnv(gym.Env):
    def __init__(self, grid_size=5, num_agents=4):
        super(PettingZooEnv, self).__init__()
        self.grid_size = grid_size
        self.num_agents = num_agents
        self.max_steps = grid_size * grid_size  # Maximum number of steps, equivalent to the size of the grid
        self.steps = 0
        

        self.action_space = spaces.Discrete(5)  # Four discrete actions: 0 - up, 1 - down, 2 - left, 3 - right
        self.agents_starting_positions = {_: None for _ in range(num_agents)}
        self.agents_positions = {_: None for _ in range(num_agents)}
        self.final_positions = {_: None for _ in range(num_agents)}
        
        self.observation_space = spaces.MultiDiscrete([grid_size, grid_size] * num_agents)  # Observations for each agent's position

    def save(self, filename = "error.json"):
        with open(filename, "w") as f:
            json.dump({
                "grid_size": self.grid_size,
                "num_agents": self.num_agents,
                "agents_starting_positions": self.agents_starting_positions.tolist(),
                "final_positions": self.final_positions.tolist(),
            }, f, indent=4)


    def load(self, filename = "error.json"):
        with open(filename, "r") as f:
            data = json.load(f)
            self.grid_size = data["grid_size"]
            self.num_agents = data["num_agents"]
            self.agents_starting_positions = np.array(data["agents_starting_positions"])
            self.final_positions = np.array(data["final_positions"])
        self.agents_positions = self.agents_starting_positions.copy()

    def generate_agent_positions(self):
        positions = []
        for _ in range(self.num_agents):
            x = np.random.randint(0, self.grid_size)
            y = np.random.randint(0, self.grid_size)
            if [x, y] in positions:
                while [x, y] in positions:
                    x = np.random.randint(0, self.grid_size)
                    y = np.random.randint(0, self.grid_size)
            positions.append([x, y])
        return np.array(positions)

    def reset(self, positions = None):
        if positions is None:
            self.agents_positions = self.generate_agent_positions()
            self.agents_starting_positions = self.agents_positions.copy()
            self.final_positions = self.generate_agent_positions()
        else:
            self.agents_positions = np.array(positions[0])
            self.agents_starting_positions = self.agents_positions.copy()
            self.final_positions = np.array(positions[1])
        self.steps = 0
        return [self.agents_positions.flatten(), self.final_positions.flatten()]

    def step(self, actions):
        assert len(actions) == self.num_agents, "Number of actions should match number of agents."

        rewards = np.ones(self.num_agents) * REWARDS["step"]
        for i in range(self.num_agents):
            rewards[i] = rewards[i] * (3 + abs(self.agents_positions[i][0] - self.final_positions[i][0]) + abs(self.agents_positions[i][1] - self.final_positions[i][1]))

        dones = np.zeros(self.num_agents, dtype=bool)
        collided, time_up = False, False
        for i, i_position in enumerate(self.agents_positions):
            for j, j_position in enumerate(self.agents_positions):
                if i != j and (j_position == i_position + np.array(actions[i])).all() and (i_position == j_position+ np.array(actions[j])).all():
                    # print(i+1, i_position, actions[i], "<->", j+1, j_position, actions[j])
                    # print("Out-cell collision!!!")
                    # self.save()
                    # input()
                    rewards[i] = rewards[j] = REWARDS["collision"]
                    dones[:] = True
                    collided = True
                if i != j and (i_position + np.array(actions[i]) == j_position + np.array(actions[j])).all():
                    # print(i+1, i_position, actions[i], "==", j+1, j_position, actions[j])
                    # print("In-cell collision!!!")
                    # self.save()
                    # input()
                    rewards[i] = rewards[j] = REWARDS["collision"]
                    dones[:] = True
                    collided = True
                if i != j and (i_position == j_position).all():
                    # print(i+1, i_position, actions[i], "==", j+1, j_position, actions[j])
                    # print("Default collision!!!")
                    # self.save()
                    # input()
                    rewards[i] = rewards[j] = REWARDS["collision"]
                    dones[:] = True
                    collided = True

        for i, action in enumerate(actions):
            x, y = self.agents_positions[i]

            x = max(0, x + action[0])
            x = min(self.grid_size - 1, x)

            y = max(0, y + action[1])
            y = min(self.grid_size - 1, y)

            self.agents_positions[i] = [x, y]

            if all(self.agents_positions[i] == self.final_positions[i]):
                rewards[i] = REWARDS["success"]
                dones[i] = True

        self.steps += 1
        if self.steps >= self.max_steps:
            dones[:] = True
            time_up = True

        # success = [self.agents_positions[agent_id] == self.final_positions[agent_id] for agent_id in range(self.num_agents-1)]
        # print(sum(success) == self.num_agents, sum(success), sum([True,]))
        return [self.agents_positions.flatten(), self.final_positions.flatten()], rewards, dones, {}, collided, time_up #, sum(success) == self.num_agents
    

