import random
from drp_env.drp_env import DrpEnv
import pfrl


class RandomAgent:

    def __init__(self, agent_id:int, env:DrpEnv) -> None:
        self.agent_id = agent_id
        self.env = env
        pass

    def act(self, obs):
        _, avail_actions = self.env.get_avail_agent_actions(self.agent_id, self.env.n_actions)
        return random.choice(avail_actions)
    
    def observe(self, obs, reward: float, done: bool, reset: bool):
        self.obs = obs
        self.reward = reward
        self.done = done
        self.reset = reset
    

