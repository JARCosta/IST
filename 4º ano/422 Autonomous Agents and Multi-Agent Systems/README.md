# AASMA - Drone Routing optimization and collision avoidance


In order to run this project please open the pettingzoo folder in the terminal and run `python runner.py` to start a simulation.
The presence of a GUI is optional, and can be switched on or off in the 165th line of the runner script.

The selection of the agent model can be done in the 178th line of the runner script, setting all the agents to be of the same type.

The number of agents and the size of the grid can be set in the 158th and 159th lines of the runner script.

To build the output graphs, simply run the `python graph.py` script in the terminal. The graphs will be saved in the `loads` folder.

The output folder name for the Learning agent, in the loads.old directory can be read as LearningAgent.{limited|unlimited}.{number of episodes ran in thausands}.{collision reward}.{success reward}.{step reward (d = distance to goal)}

limited and unlimited refer to the observation sight of the agent, with limited being limited to 2 cells in radious and unlimited being able to see the whole grid.