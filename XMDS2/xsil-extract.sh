#!/bin/bash

################################################################################
# Extract the data from an ACSII .xsil file produced by XMDS                   # 
# Brad Mommers 2020                                                            # 
#                                                                              # 
# Usage: ./xsil-extract.sh <filename.xsil>                                     # 
#                                                                              # 
# NOTE: be sure to execute this file in the folder where the original          # 
#       .xsil file is located!                                                 # 
################################################################################

# Get our data file name from first argument
xsilfile="$1"

# Make a directory by stripping the data file's extension
outputdir=${xsilfile%.xsil}
outputdirname="$outputdir-data"
mkdir -p "$outputdirname"
cp "$xsilfile" "$outputdirname/"
cd "$outputdirname"

# Split the .xsil file on the incidence of 'moment_group'
# i.e. make a new file for each moment group (the first file will contain
# most of the metadata such as the generating xmds script etc and can be
# safely ignored)
# Each of the output files (except the first) will need to be stripped
# of the few xml tags that remain
csplit "$xsilfile" '/moment_group/' '{*}'

# We now have N files labelled xx00,xx01,xx02,...,xxN
# It's safe to ignore xx00, since it doesn't hold any output data
# We want to loop over these files (xx01 through xxN) and extract only the
# data (leave all the xml crap behind)
for j in xx*
do
    # Pull the data columns from the .xsil file and drop them in a new file
    # This depends on the data having entries of the form 
    # (nums).(nums)e(+ or -)(nums)
    echo "Processing $j"
    egrep '[0-9]{1,4}\.[0-9]{9,12}e[+-][0-9]{2}' "$j" > "moment_group_$j.dat"
    rm $j
done

# Clean up
rm "$xsilfile"
cd ..

# done
