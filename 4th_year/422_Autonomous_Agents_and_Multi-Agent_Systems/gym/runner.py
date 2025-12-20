import gym
import numpy as np
import matplotlib.pyplot as plt

from drp_env.drp_env import DrpEnv

import agents


from problems import instances

# instance = instances[11]

for instance in instances:

    map_name = instance["map"]
    drone_num = instance["drone_num"]
    start_arr = instance["start"]
    goal_arr = instance["goal"]
    reward_list = {
        "goal": 100,
        "collision": -10,
        "wait": -10,
        "move": -1,
    }

    env:DrpEnv = gym.make(
        "drp_env:drp-" + str(drone_num) + "agent_" + map_name + "-v2",
        state_repre_flag="onehot_fov",
        goal_array=goal_arr,
        start_ori_array=start_arr,
        reward_list=reward_list,
    )


    agent_list = [agents.WaitingGreedyAgent(agent_id, env) for agent_id in range(env.n_agents)]


    EPISODES = 1
    reward_array,average_rewards=[],[]

    for ep in range(1, EPISODES + 1):
        observation = env.reset()
        reward = 0  # return (sum of rewards)
        t = 0  # time step
        done = False
        while not done:
            if ep == EPISODES: # if last episode, render
                env.render()
            actions = []
            for agent_id in range(env.n_agents):
                action = agent_list[agent_id].act(observation[agent_id])
                actions.append(action)
            #     print(agent_id, env.get_pos_list()[agent_id], action)
            # print(actions)
            # input()

            observation, r, done, info= env.step(actions) 
            print(f"obs:{observation},actions:{actions},r:{r},done:{done},info:{info}")              
            done = all(done)
            reward += sum(r)
            t += 1
            
            for agent_id in range(env.n_agents):
                agent_list[agent_id].observe(observation[agent_id],r[agent_id],done,False)

        reward_array.append(reward)
        batch_size=10
        if ep % batch_size == 0:
            #print('Episode:', i, 'Total Reward:', reward)
            average_reward = np.mean(reward_array[-batch_size:])
            average_rewards.append(average_reward)

    print('Finished.')
    print("this was environment:", instances.index(instance))
    input()
    plt.close()

#Show reward figure 
plt.plot(reward_array)
x = np.arange(batch_size, EPISODES + 1, batch_size)
plt.plot(x, average_rewards, marker='o')
plt.show()

#save model
for agent_id in range(drone_num):
    if isinstance(agent_list[agent_id], agents.PfrlAgent):
        agent_list[agent_id].save(f"./models/sample_model{agent_id}")
