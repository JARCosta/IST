import pygame
import numpy as np

from pettingzoo_env import PettingZooEnv
from pettingzoo_env import ACTIONS

import agents
import graphs

import atexit
import signal
import pickle
import matplotlib.pyplot as plt
import pandas as pd


STATISTICS = {
    "reward": [],
    "reward_collision_as_none": [],
    "steps": [],
    "time_up": [],
}

# Define colors
COLORS = {
    "black": (0, 0, 0),
    "white": (255, 255, 255),
    "red": (255, 0, 0),
    "green": (0, 255, 0),
    "blue": (0, 0, 255)
}

def run(gui:bool, env:PettingZooEnv, agent_list:list, episodes:int):

    if gui:
        pygame.init()

        BLOCK_SIZE = 80
        WINDOW_SIZE = (GRID_SIZE * BLOCK_SIZE, GRID_SIZE * BLOCK_SIZE)
        screen = pygame.display.set_mode(WINDOW_SIZE)
        pygame.display.set_caption("Petting Zoo")

        font = pygame.font.Font(None, 36)

    for ep in range(episodes):
        # print("Episode: ", ep+1)

        obs = env.reset()
        dones = [False for _ in range(env.num_agents)]
        ep_rewards = np.zeros(env.num_agents)

        while not all(dones):

            if gui:
                screen.fill(COLORS["white"])

                for i in range(GRID_SIZE):
                    for j in range(GRID_SIZE):
                        pygame.draw.rect(screen, COLORS["black"], [j * BLOCK_SIZE, i * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE], 1)

                # Draw agents and final positions
                for i, (agent_pos, final_pos) in enumerate(zip(env.agents_positions, env.final_positions)):
                    final_x, final_y = final_pos
                    pygame.draw.rect(screen, COLORS["red"], [final_y * BLOCK_SIZE, final_x * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE])
                    text = font.render("G" + str(i + 1), True, COLORS["black"])
                    text_rect = text.get_rect(center=(final_y * BLOCK_SIZE + BLOCK_SIZE // 2, final_x * BLOCK_SIZE + BLOCK_SIZE // 2))
                    screen.blit(text, text_rect)
                    
                for i, (agent_pos, final_pos) in enumerate(zip(env.agents_positions, env.final_positions)):
                    agent_x, agent_y = agent_pos
                    pygame.draw.rect(screen, COLORS["green"], [agent_y * BLOCK_SIZE, agent_x * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE])
                    text = font.render("A" + str(i + 1), True, COLORS["black"])
                    text_rect = text.get_rect(center=(agent_y * BLOCK_SIZE + BLOCK_SIZE // 2, agent_x * BLOCK_SIZE + BLOCK_SIZE // 2))
                    screen.blit(text, text_rect)

                pygame.display.flip()

            [agent.see(obs) for agent in agent_list]
            actions = [agent.communicate(agent.action(), agent_list) for agent in agent_list]

            obs, rewards, dones, _, collided, time_up = env.step(actions)
            for i, agent in enumerate(agent_list): 
                if isinstance(agent, agents.LearningAgent) and agent.training:

                    agent_poss = obs[0].copy()
                    final_poss = obs[1].copy()

                    for x in range(0, len(agent_poss), 2):
                        if x//2 != i:
                            distance_vector = np.array(agent.position) - np.array(agent_poss[x:x+2])
                            distance = distance_vector[0] + distance_vector[1]
                            # print(i, x//2, distance)
                            if distance > 2:
                                agent_poss[x] = 0
                                agent_poss[x+1] = 0
                                final_poss[x] = 0
                                final_poss[x+1] = 0

                    agent.next(actions[i], tuple(agent_poss) + tuple(final_poss), rewards)
            ep_rewards += rewards

            if gui:
                pygame.time.delay(250)  # Delay to see the movements
                # input()


        print("Episode", ep+1, "finished, rewards:", ep_rewards.sum())
        STATISTICS["reward"].append(ep_rewards.sum())
        STATISTICS["reward_collision_as_none"].append(ep_rewards.sum() if not collided else None)
        STATISTICS["steps"].append(env.steps)
        STATISTICS["time_up"].append(time_up)
    if not isinstance(agent_list[0], agents.LearningAgent):
        save(agent_list, STATISTICS)
        # graphs.average(STATISTICS, "full", False)

def load():
    global agent_list
    agent_list = []
    for i in range(N_AGENTS):
        with open("loads/data" + str(i) + ".pkl", "rb") as f:
            agent_list.append(pickle.load(f))
        print("Agent", i, "loaded.")
    with open("loads/statistics.pkl", "rb") as f:
        global STATISTICS
        STATISTICS = pickle.load(f)
    return agent_list, STATISTICS

def save(agent_list, STATISTICS):
    print("Saving data...")

    for i in range(N_AGENTS):
        with open('loads/data' + str(i) + '.pkl', 'wb') as file:
            pickle.dump(agent_list[i], file)
        print("Agent", i, "saved.")
    with open('loads/statistics.pkl', 'wb') as file:
        pickle.dump(STATISTICS, file)

def train_and_eval(train_environment, eval_environment, agents, n_evals = 50, n_training_episodes=100, n_eval_episodes=100):

    results = np.zeros((n_evals, n_eval_episodes))
    for evaluation in range(n_evals):
        # Train
        for agent in agents: agent.train()
        run(False, train_environment, agents, n_training_episodes)

        # Eval
        for agent in agents: agent.eval()

        gui_temp = True if n_eval_episodes != 0 else False
        results[evaluation]= run(gui_temp, eval_environment, agents, n_eval_episodes)

        if n_eval_episodes%5 == 0:
            save(agents, STATISTICS)

        # graphs.graph(STATISTICS, "full", False)
    return results

GRID_SIZE = 5
N_AGENTS = 2
N_ACTIONS = len(ACTIONS)

import os
ERROR_CHECK = "error.json" in os.listdir()
GUI = ERROR_CHECK
GUI = True

positions = [
    [[0, 0], [1, 0], [3, 2], [4, 4]],
    [[2, 3], [1, 4], [3, 0], [4, 1]]
]

env = PettingZooEnv(grid_size=GRID_SIZE, num_agents=N_AGENTS)
env.reset()
if ERROR_CHECK:
    env.load()


agent_list = [agents.RandomAgent(N_AGENTS, agent_id, N_ACTIONS) for agent_id in range(N_AGENTS)]

if isinstance(agent_list[0], agents.LearningAgent):
    train_env = PettingZooEnv(grid_size=GRID_SIZE, num_agents=N_AGENTS)
    # try:
    train_and_eval(train_env, env, agent_list, n_evals=30, n_training_episodes=10000, n_eval_episodes=0)
    # except KeyboardInterrupt:
    #     graphs.graph(STATISTICS, "full", False)
else:
    run(GUI, env, agent_list, 100000)

# def handle_exit():
#     graphs.graph(STATISTICS, "full", False)
    

# atexit.register(handle_exit)
# signal.signal(signal.SIGTERM, handle_exit)
# signal.signal(signal.SIGINT, handle_exit)
