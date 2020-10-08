#!/usr/bin/python3

import sys
import math

args = str(sys.argv[1])

costfile = open("mloop_cost.txt","w")

cost = 1.0

costfile.write("cost = {}\n".format(cost))

costfile.close()
