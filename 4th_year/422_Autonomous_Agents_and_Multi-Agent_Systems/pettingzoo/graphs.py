

import pickle
import pandas as pd
from matplotlib import pyplot as plt
import math
import numpy as np

FOLDER = "loads/"


def graph(statistics, filename:str="temp", graph:bool = False):
    
    # print(len(statistics["reward"]))

    # print(statistics.keys())

    BATCH_SIZE = 10000

    statistics_df = pd.DataFrame(statistics["reward_collision_as_none"])
    none_counts_per_batch = [statistics_df.iloc[i:i+BATCH_SIZE].isna().sum().sum() / BATCH_SIZE for i in range(0, len(statistics_df), BATCH_SIZE)]
    # print(none_counts_per_batch)
    plt.bar(np.arange(len(none_counts_per_batch)), none_counts_per_batch, color='skyblue')
    plt.title('Percentage of episodes that ended with collison')
    plt.savefig(FOLDER+filename+'_collision_percentage.png')
    plt.clf()
    
    time_up_df = pd.DataFrame(statistics["time_up"])
    time_up_counts_per_batch = [time_up_df.iloc[i:i+BATCH_SIZE].sum().sum() / BATCH_SIZE for i in range(0, len(time_up_df), BATCH_SIZE)]
    # print(time_up_counts_per_batch)
    plt.bar(np.arange(len(time_up_counts_per_batch)), time_up_counts_per_batch, color='skyblue')
    plt.title('Percentage of episodes that ended with time up')
    plt.savefig(FOLDER+filename+'_time_up_percentage.png')
    plt.clf()

    reward_df = pd.DataFrame(statistics["reward"])
    reward_df = reward_df.rolling(window = int(len(statistics["reward"]) * 0.02)).mean()
    reward_df.plot(title="Reward over episodes")
    plt.savefig(FOLDER+filename+'_reward.png')
    plt.clf()

    steps_df = pd.DataFrame(statistics["steps"])
    steps_df = steps_df.rolling(window = int(len(statistics["steps"]) * 0.02)).mean()
    steps_df.plot(title="Steps over episodes")
    plt.savefig(FOLDER+filename+'_steps.png')
    plt.clf()

    steps_where_didnt_collide = [statistics["steps"][i] if statistics["reward_collision_as_none"][i] != None else None for i in range(len(statistics["steps"]))]
    steps_df = pd.DataFrame(steps_where_didnt_collide).dropna()
    steps_df = steps_df.rolling(window = int(len(statistics["steps"]) * 0.02)).mean()
    steps_df.plot(title="Steps over episodes where didn't collide")
    plt.savefig(FOLDER+filename+'_steps_no_collisions.png')
    plt.clf()

    # reward_no_collisions_df = pd.DataFrame(statistics["reward_collision_as_none"]).dropna()
    # reward_no_collisions_df = reward_no_collisions_df.rolling(window = int(len(statistics["reward_collision_as_none"]) * 0.02)).mean()
    # reward_no_collisions_df.plot(title="Reward over episodes which didnt end up in collision")
    # plt.savefig('loads/'+filename+'_reward_no_collisions.png')

    if graph:
        plt.show()

def average(statistics, filename:str="temp"):

    # print(len(statistics["reward"]))
    n_records = len(statistics["reward"])

    # print(statistics.keys())

    collisions = [i == None for i in statistics["reward_collision_as_none"]]
    if "LearningAgent" in FOLDER:

        reward = statistics["reward"]
        time_up = statistics["time_up"]
        steps = statistics["steps"]
        
        eps = 1000
        collisions_eps = [i == None for i in statistics["reward_collision_as_none"][-eps:]]
        average_reward = sum(reward[-eps:]) / eps
        percentage_of_episodes_that_ended_with_collison = 100 * sum(collisions_eps) / eps
        percentage_of_episodes_that_ended_with_time_up = 100 * sum(time_up[-eps:]) / eps
        average_steps_when_didnt_collide = sum([statistics["steps"][-eps:][i] for i in range(eps) if not collisions_eps[i]]) / (eps - sum(collisions_eps))
        average_steps = sum(steps[-eps:]) / eps

        print()
        print("Last episodes average: ")
        print("Average reward: ", round(average_reward, 2))
        print("Percentage of episodes that ended with collison: ", round(percentage_of_episodes_that_ended_with_collison, 2))
        print("Percentage of episodes that ended with time up: ", round(percentage_of_episodes_that_ended_with_time_up, 2))
        print("Average steps when didn't collide: ", round(average_steps_when_didnt_collide, 2))
        print("Average steps: ", round(average_steps, 2))

        if FOLDER == "loads.old/LearningAgent.limited.300.-100.100.-d/":

            eps_pos = 175000
            eps = 1000

            reward = statistics["reward"]
            time_up = statistics["time_up"]
            steps = statistics["steps"]
            collisions = [i == None for i in statistics["reward_collision_as_none"]]
        
            collisions_eps = [i == None for i in statistics["reward_collision_as_none"][eps_pos-500:eps_pos+500]]
            average_reward = sum(reward[eps_pos-500:eps_pos+500]) / eps
            percentage_of_episodes_that_ended_with_collison = 100 * sum(collisions_eps) / eps
            percentage_of_episodes_that_ended_with_time_up = 100 * sum(time_up[eps_pos-500:eps_pos+500]) / eps
            average_steps_when_didnt_collide = sum([statistics["steps"][eps_pos-500:eps_pos+500][i] for i in range(eps) if not collisions_eps[i]]) / (eps - sum(collisions_eps))
            average_steps = sum(steps[eps_pos-500:eps_pos+500]) / eps
        
            print()
            print("Values when best performing: ")
            print("Average reward: ", round(average_reward, 2))
            print("Percentage of episodes that ended with collison: ", round(percentage_of_episodes_that_ended_with_collison, 2))
            print("Percentage of episodes that ended with time up: ", round(percentage_of_episodes_that_ended_with_time_up, 2))
            print("Average steps when didn't collide: ", round(average_steps_when_didnt_collide, 2))
            print("Average steps: ", round(average_steps, 2))

    
    average_reward = sum(statistics["reward"]) / n_records
    percentage_of_episodes_that_ended_with_collison = 100 * sum(collisions) / n_records
    percentage_of_episodes_that_ended_with_time_up = 100 * sum(statistics["time_up"]) / n_records
    average_steps_when_didnt_collide = sum([statistics["steps"][i] for i in range(n_records) if not collisions[i]]) / (n_records - sum(collisions))
    average_steps = sum(statistics["steps"]) / n_records


    print()
    print("All time average:")
    print("Average reward: ", round(average_reward, 2))
    print("Percentage of episodes that ended with collison: ", round(percentage_of_episodes_that_ended_with_collison, 2))
    print("Percentage of episodes that ended with time up: ", round(percentage_of_episodes_that_ended_with_time_up, 2))
    print("Average steps when didn't collide: ", round(average_steps_when_didnt_collide, 2))
    print("Average steps: ", round(average_steps, 2))
    print()

    with open(FOLDER+filename+'_average.txt', 'w') as file:
        file.write("Average reward: "+str(round(average_reward, 2))+"\n")
        file.write("Percentage of episodes that ended with collison: "+str(round(percentage_of_episodes_that_ended_with_collison, 2))+"\n")
        file.write("Percentage of episodes that ended with time up: "+str(round(percentage_of_episodes_that_ended_with_time_up, 2))+"\n")
        file.write("Average steps when didn't collide: "+str(round(average_steps_when_didnt_collide, 2))+"\n")
        file.write("Average steps: "+str(round(average_steps, 2))+"\n")

if __name__ == "__main__":

    FOLDER_LIST = [
        "loads.old/LearningAgent.unlimited.300.-100.10.-d/", 
        "loads.old/LearningAgent.limited.300.-100.10.-d/", 
        "loads.old/LearningAgent.limited.300.-100.100.-d/", 
        "loads.old/CollisionAvoiderAgent/", 
        "loads.old/ConventionAgent/", 
        "loads.old/GreedyAgent/", 
        "loads.old/RandomAgent/"
        ]
    
    for i in FOLDER_LIST:
        FOLDER = i
        with open(FOLDER+'statistics.pkl', 'rb') as file:
            statistics = pickle.load(file)

        from contextlib import redirect_stdout
        with open(FOLDER+'temp_average.txt', 'w') as f:
            with redirect_stdout(f):
                graph(statistics, graph=False)
                average(statistics)
