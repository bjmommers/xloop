#!/usr/bin/env python3

### Calculate cost from hdf5 format data produced by XMDS

# Libraries
import h5py  # hdf5 format interpreter
import sys   # file and argument manipulation
import math  # for calculating cost

def calculate_cost(data):
    '''
    Calculates the cost with uncertainty based on data object supplied. Replace this function
    with your own.
    For now, just returns the inverse of the logarithm of the maximum CFI
    '''
    # strip 'nan' strings from data (not actual float NaN)
    cleaned_data = [x for x in data if str(x) != 'nan']
    # return the highest value and fixed uncertainty
    max_cfi = max(list(cleaned_data))
    cost = 1.0/(math.log(max_cfi))
    return cost,0.01*cost

### import first argument as hdf5 file object
datafile = h5py.File(sys.argv[1] + ".h5",'r')
moment_group = sys.argv[2]
data_member = sys.argv[3]

print(datafile[moment_group][data_member])

### pass data to function that calculates the cost
result,uncertainty = calculate_cost(datafile[moment_group][data_member])

### output cost and uncertainty per M-LOOP spec
outfile = open(sys.argv[1] + "-data/mloop_cost.txt",'w')
outfile.write(f"cost = {result}\n")
outfile.write(f"uncer = {uncertainty}\n")

