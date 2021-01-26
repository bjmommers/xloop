#!/usr/bin/env python3

### Simple script to calculate a cost function from XMDS ASCII output

import sys
import math

args = str(sys.argv[1])
costfile = open("mloop_cost.txt","w")

### Calculate your cost here
cost = 1.0
uncertainty = 0.01*cost

### Output to file using M-LOOP spec
costfile.write("cost = {}\nuncertainty = {}\n".format(cost,uncertainty))
costfile.close()
