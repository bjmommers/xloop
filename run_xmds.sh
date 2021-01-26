#!/usr/bin/env bash

# Wrapper to communicate between XMDS simulations and M-LOOP optimiser
# Brad Mommers 2020

################################################################################
#                               REQUIREMENTS                                   #
################################################################################
#                                 M-LOOP:
# Use M-LOOP's shell interface to run this script, e.g. in your config:
#   interface_type = 'shell'
#   command='./run_xmds.sh'
# to run the sim name "mysim"
#
# M-LOOP generates parameters with their names and passes them to this
# script in the format:
#   ./run_xmds.sh --parameter1 value1 --parameter2 value2 ...
# Argument handling is the same as for BECring, but passing to XMDS
# uses the same format as above, so we just directly pass the arg list
#
#                                  XMDS:
# NOTE: XMDS simulation must be pre-compiled!
#       (this saves needlessly re-compiling each optimisation iteration)
#
# Change the $simname variable below to the name of your sim
# Make sure the .xmds file is located in a directory with the same name,
# i.e. XMDS2/simname/simname.xmds
# You must also ensure your output file is either simname.xsil (ASCII)
#       or simname.h5 (HDF5). This is specified in your XMDS script
# If using hdf5, the data used for the cost MUST be in the moment group 
#       specified by variable $moment_group and must be named
#       according to the variable $moment_name,
#   e.g. in your .xmds script:
#      <!-- Moment group $moment_group: Data for calculating cost function  -->
#      <sampling_group basis="" initial_sample="no">
#        <moments>cost_data</moments>
#        <dependencies> density </dependencies>
#        <![CDATA[
#          $moment_name = some_expression_here;
#        ]]>
#      </sampling_group>
#
# Finally, if using multithreading via MPI, specify the number of threads
# to simulate with by modifying the $num_threads variable below
################################################################################
simname="2Dgroundstate"
num_threads="2"
moment_group="4"
moment_name="out_CFI"

# Run simulation (no compilation needed, we're only passing arguments)
cd "XMDS2/$simname"
# Use bash OR to run single-threaded sim if MPI fails
# This will likely be removed later since single-threaded XMDS sims are uncommon
mpirun -np $num_threads ./$simname "$@" || ./$simname "$@"



## After simulation, extract data

# Extraction method depends on how XMDS generated output
if [[ -f $simname.h5 ]]
then
    # HDF5 output generated (multithreaded)
    echo "Analysing HDF5 output"
    mkdir -p $simname-data
    # The below assumes a cost_data quantity in moment group 1
    # edit the arguments to h5-analyse.py if your simulation differs
    ../h5-analyse.py $simname $moment_group $moment_name
    # Return to directory from which M-LOOP is started
    cd ../..
else
    # ASCII output generated (single-threaded only)
    echo "Analysing ASCII output"
    ../xsil-extract.sh $simname.xsil     # creates groundstate-data/ dir
    cd $simname-data

    # Calculate cost from data, place it in file mloop_cost.txt
    ../../xsil-analyse.py "moment_group_xx0$moment_group.dat"
    # Return to directory from which M-LOOP is started
    cd ../../..
fi


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
