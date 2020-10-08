# XLOOP
Scripts for connecting [XMDS2](http://www.xmds.org) simulations to online machine-learning package [M-LOOP](https://github.com/michaelhush/M-LOOP)

#### Overview
This repository hosts a series of scripts that allows simulations compiled by XMDS2 to be run in a reinforcement-learning style continuous loop with Gaussian process (or other) optimisation provided by M-LOOP.  
The idea is to allow M-LOOP to pass parameters and their names to XMDS, run a simulation with those parameters, then extract the (plaintext) output data in such a way that a simple Python (or other) script can determine a cost value, which is then returned to M-LOOP.  
This is a fairly simple process as both XMDS and (the current version of) M-LOOP support named parameters using the same scheme.  


#### Getting started
- Install M-LOOP and XMDS2  
- Clone this repo  
- In the `XMDS2/` subdirectory, create a new directory with the same name as your simulation (`groundstate` is provided as an example)  
- Copy your .xmds file into this directory. Make sure you haven't included a `<name>` tag or a filename in your `<output>` tag.
- Compile your simulation with `xmds2 <.xmds filename>`  
- In the `XMDS2/` directory, replace `fisher-analysis.py` with the script you want to use for data analysis (if renaming, be sure to change the command in `run_xmds.sh` accordingly)  
- In the root directory of the repo, edit the `simname` variable in `run_xmds.sh` to whatever your .xmds file is named (don't include the extension)  
- Edit M-LOOP's `exp_config.txt` to include the parameters you're interested in (and their names, bounds, etc)  
- Run `M-LOOP`  
- Sit back and enjoy as your simulations are run, analysed, and optimised in a continuous loop  

#### Data analysis  
Data must be saved in ASCII format for `xsil-extract.sh` to properly separate each moment group into its own file.
Depending on your choice of cost function, you can have XMDS compute the cost directly and output it in a moment group, or use a separate script (`fisher-analysis.py` is provided as an example) to calculate the cost based on other output quantities.
If XMDS is calculating the cost directly, you can simply replace `fisher-analysis.py` with a simple shell script that prints the correct details to stdout (see `run_xmds.sh` for details).  
The defaults assume that moment group 1 contains the data required to calculate the cost.
This can be changed within `run_xmds.sh` if needed.  
The shell script `timeseries-extract.sh` works in conjuction with the gnuplot script `1Dplot.gpi` (or a replacement of your own design) and ffmpeg to produce animated videos of your data.
