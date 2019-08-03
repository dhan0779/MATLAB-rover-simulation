# MATLAB-rover-simulation
This application uses MATLAB to create a simulation of four rovers inside of a plot. There were many versions of various function, so some might not be necessary to run the application itself.

## How to run
### Running a single game with plot
You can run a single game with the file: DH_exerNNrovers8.m. This file is a function with inputs explained inside of the script. You can change the number of frames as well as other configurations such as the rover size and resolution. The frames might change speed depending on the length of the game, but it is possible to run a faster fps using movie.
### Running multiple games without plot
You can run multiple games with the file: Tourney18.m. This file can run many games without showing the actual plot. It gives other information such as the number of points accumulated by rovers.

## Other Updates
### Arena Size/Rover Size
I have tried to implement the arena size changing as the game moves on to try and make the game go faster. The game might not run as smoothly, but the functionality is there.
### Rover Energy
I added an energy aspect based on the rovers speed. The TailChase function changes the speed of the rovers as two approach. If the energy of a rover goes to 0, the rover stops moving and can only defend itself. However, energy can be added by killing another rover.
