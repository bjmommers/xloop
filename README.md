# XLOOP
Scripts for connecting [XMDS2](http://www.xmds.org) simulations to online machine-learning package [M-LOOP](https://github.com/michaelhush/M-LOOP)

#### Overview
This repository hosts a series of scripts that allows simulations compiled by XMDS2 to be run in a reinforcement-learning style continuous loop with Gaussian process (or other) optimisation provided by M-LOOP.  
The idea is to allow M-LOOP to pass parameters and their names to XMDS, run a simulation with those parameters, then extract the (plaintext) output data in such a way that a simple Python (or other) script can determine a cost value, which is then returned to M-LOOP.  
This is a fairly simple process as both XMDS and (the current version of) M-LOOP support named parameters using the same scheme.  


#### Getting started
- Install M-LOOP and XMDS2  
- Clone this repo  
- In the `XMDS2/` directory, create a new directory with the same name as your simulation (`groundstate` is provided as an example)  
- Copy your .xmds file into this directory. Make sure you haven't included a <name> tag or a filename in your <output> tag.
- Compile your simulation with `xmds2 <.xmds filename>`  
- In the `XMDS2/` directory, replace `fisher-analysis.py` with the script you want to use for data analysis (if renaming, be sure to change the command in `run_xmds.sh` accordingly)  
- In the root directory of the repo, edit the `simname` variable in `run_xmds.sh` to whatever your .xmds file is named (don't include the extension)  
- Edit M-LOOP's `exp_config.txt` to include the parameters you're interested in (and their names, bounds, etc)  
- Run `M-LOOP`  
- Sit back and enjoy as your simulations are run, analysed, and optimised in a continuous loop
