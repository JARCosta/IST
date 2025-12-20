

import numpy as np
import pfrl
import torch
from drp_env.drp_env import DrpEnv


class QFunction(torch.nn.Module):

    def __init__(self, obs_size, n_actions):
        super().__init__()
        hidden_layer_n = 100
        self.l1 = torch.nn.Linear(obs_size, hidden_layer_n)
        self.l2 = torch.nn.Linear(hidden_layer_n, hidden_layer_n)
        self.l3 = torch.nn.Linear(hidden_layer_n, n_actions)

    def forward(self, x):
        h = x
        h = torch.nn.functional.relu(self.l1(h))
        h = torch.nn.functional.relu(self.l2(h))
        h = self.l3(h)
        return pfrl.action_value.DiscreteActionValue(h)

class PfrlAgent(pfrl.agents.DQN):

    def __init__(self, agent_id:int, env:DrpEnv) -> None:


        # The OBS space in the Aoba map consists of 18 BoxSpaces, each with [0,100]×[0,100]
        obs_size = env.observation_space[0].shape[0] # map_aoba01 has 18 nodes, current-position(18dimensions)+current-goal(18dimensions)=36
        n_actions = env.action_space[0].n # map_aoba01 has 18 nodes and each node corresponds to one action
        q_func = QFunction(obs_size, n_actions)
        print(f"obs_size:{env.observation_space[0].shape[0]}")
        print(f"n_actions:{env.action_space[0].n}")
        optimizer = torch.optim.Adam(q_func.parameters(), eps=1e-2)
        # Set the discount factor that discounts future rewards.
        gamma = 0.9
        explorer = pfrl.explorers.ConstantEpsilonGreedy(
            epsilon=0.1, random_action_func=env.action_space[0].sample)

        # DQN uses Experience Replay.
        replay_buffer = pfrl.replay_buffers.ReplayBuffer(capacity=10 ** 6)
        phi = lambda x: np.array(x, dtype=np.float32)
        # Set the device id to use GPU. To use CPU only, set it to -1.
        gpu = -1

        super(PfrlAgent, self).__init__(
            q_func,
            optimizer,
            replay_buffer,
            gamma=gamma,
            explorer=explorer,
            replay_start_size=500,
            update_interval=1,
            target_update_interval=100,
            phi=phi,
            gpu=gpu,
        )
        
        pass

