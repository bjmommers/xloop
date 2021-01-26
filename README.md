# XLOOP
Scripts for connecting [XMDS2](http://www.xmds.org) simulations to online machine-learning package [M-LOOP](https://github.com/michaelhush/M-LOOP)

#### Overview
This repository hosts a series of scripts that allows simulations compiled by XMDS2 to be run in a reinforcement-learning style continuous loop with Gaussian process (or other) optimisation provided by M-LOOP.  
The idea is to allow M-LOOP to pass parameters and their names to XMDS, run a simulation with those parameters, then extract the output data in such a way that a simple Python (or other) script can determine a cost value, which is then returned to M-LOOP.  
This is now a fairly simple process as both XMDS and (the current version of) M-LOOP support named parameters using the same scheme.  


#### Getting started
- Install M-LOOP and XMDS2  
- Clone this repo  
- In the `XMDS2/` subdirectory, create a new directory with the same name as your simulation (`groundstate` is provided as an example)  
- Copy your .xmds file into this directory. Make sure you haven't included a `<name>` tag or a filename in your `<output>` tag.
- Compile your simulation with `xmds2 <.xmds filename>`  
- For single-threaded simulations: edit `XMDS2/xsil-analyse.py` to calculate the desired cost  
- For multi-threaded simulations: open `XMDS2/h5-analyse.py` and edit the `calculate_cost` function to your liking
- In the root directory of the repo, edit the `simname` variable in `run_xmds.sh` to whatever your .xmds file is named (don't include the extension)  
- Also ensure that the `num_threads`, `moment_group`, and `moment_name` variables in `run_xmds.sh` are configured according to your .xmds script
- Edit M-LOOP's `exp_config.txt` to include the parameters you're interested in (and their names, bounds, and other M-LOOP options as desired)  
- Run `M-LOOP`  
- Sit back and enjoy as your simulations are run, analysed, and optimised in a continuous loop  

#### Data analysis  
HDF5 output files are now supported, so multi-threaded simulations now work.  
Depending on your choice of cost function, you can have XMDS compute the cost directly and output it in a moment group, or use a separate script (such as the provided Python scripts) to calculate the cost based on other output quantities.
If XMDS is calculating the cost directly, you can simply replace `fisher-analysis.py` with a simple shell script that prints the correct details to stdout (see `run_xmds.sh` for details).  
ASCII output analysis assumes that only one quantity is defined in the moment group to be analysed.  
The shell script `timeseries-extract.sh` works in conjuction with the gnuplot script `1Dplot.gpi` (or a replacement of your own design) and ffmpeg to produce animated videos of your data.
