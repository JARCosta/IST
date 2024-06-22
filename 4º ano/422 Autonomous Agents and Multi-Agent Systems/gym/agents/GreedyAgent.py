import random
from drp_env.drp_env import DrpEnv
import pfrl


class GreedyAgent:

    def __init__(self, agent_id:int, env:DrpEnv) -> None:
        self.agent_id = agent_id
        self.env = env
        pass

    def act(self, obs):
        # in node, can chose direction
        if self.env.get_pos_list()[self.agent_id]["type"] == "n":
            # in goal, stop
            if self.env.goal_array[self.agent_id] == self.env.get_pos_list()[self.agent_id]["pos"]:
                return -1
            action = self.env.get_actions_to_goal(self.env.get_pos_list()[self.agent_id]["pos"], self.env.goal_array[self.agent_id])[1]
        # in edge, can only move forward or backward
        else:
            action = self.env.get_pos_list()[self.agent_id]["current_goal"]
        return action
    
    def observe(self, obs, reward: float, done: bool, reset: bool):
        self.obs = obs
        self.reward = reward
        self.done = done
        self.reset = reset
    

