from drp_env.drp_env import DrpEnv

class WaitingGreedyAgent:

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

            pos_list = self.env.get_pos_list()
            for agent_id in range(len(pos_list)):
                # there is another agent occupying the next node
                if pos_list[agent_id]["pos"] == action:
                    input()
                    action = self.env.get_actions_to_goal(self.env.get_pos_list()[self.agent_id]["pos"], self.env.goal_array[self.agent_id], action)[1]
                # there is another agent doing the reverse action
                if pos_list[agent_id]["type"] == "e" and pos_list[agent_id]["current_start"] == action and pos_list[agent_id]["current_goal"] == pos_list[self.agent_id]["pos"]:
                    input()
                    action = self.env.get_actions_to_goal(self.env.get_pos_list()[self.agent_id]["pos"], self.env.goal_array[self.agent_id], action)[1]

        # in edge, can only move forward or backward
        else:
            action = self.env.get_pos_list()[self.agent_id]["current_goal"]
        
        # pos_list = self.env.get_pos_list()
        # print(f"pos:{pos_list[self.agent_id]["pos"]},action:{action}")
        # print(f"pos_list:{pos_list}")

        # for agent_id in range(len(pos_list)):
        #     if agent_id != self.agent_id:
        #         agent = pos_list[agent_id]
        #         if agent["type"] == "n": # if there is another agent in the next node
        #             if agent["pos"] == action:
        #                 # input()
        #                 return -1
        #         if agent["type"] == "e" and agent["current_goal"] == pos_list[self.agent_id]["pos"]: # if another node is comming
        #             action = 

        return action
    
    def observe(self, obs, reward: float, done: bool, reset: bool):
        self.obs = obs
        self.reward = reward
        self.done = done
        self.reset = reset



