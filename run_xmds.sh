#!/bin/bash

# Wrapper to communicate between XMDS simulations and M-LOOP optimiser
# Brad Mommers 2020

# Use M-LOOP's shell interface to run this script, e.g. in your config:
#   interface_type = 'shell'
#   command='./run_xmds.sh'
# to run the sim name "mysim"

# M-LOOP generates parameters with their names and passes them to this
# script in the format:
#   ./run_xmds.sh --parameter1 value1 --parameter2 value2 ...
# Argument handling is the same as for BECring, but passing to XMDS
# uses the same format as above, so we just directly pass the arg list
#
# NOTE: XMDS simulation must be pre-compiled!
#       (this saves needlessly re-compiling each optimisation iteration)

# Change this variable to the name of your sim
# Make sure the .xmds file is located in a directory with the same name,
# i.e. XMDS2/simname/simname.xmds
simname="mloop"

# Run simulation (no compilation needed, we're only passing arguments)
cd "XMDS2/$simname"
./$simname "$@"

# After simulation, extract data
../xsil-extract.sh $simname.xsil     # creates groundstate-data/ dir
cd $simname-data

# Calculate cost from data, place it in file mloop_cost.txt
../../fisher-analysis.py moment_group_xx01.dat

# Return to directory from which M-LOOP is started
cd ../../..

# Analysis script must produce output of the form:
#
# cost = {value}
# uncer = {value}
# bad = {True/False}
#
# where only cost is mandatory. Don't forget a trailing newline!
echo "M-LOOP_start"
cat XMDS2/$simname/$simname-data/mloop_cost.txt
echo "M-LOOP_end"
