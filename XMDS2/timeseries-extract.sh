#!/usr/bin/env bash

################################################################################
# Plot the time series of a moment group from XMDS output                      # 
# Brad Mommers 2020                                                            # 
#                                                                              # 
# Usage: ./timeseries-extract.sh <data filename> <plotting script>             #
#    eg: ./timeseries-extract.sh moment_group_xx01.dat frameplot.gpi           #
#                                                                              # 
# NOTE: Be sure to execute this file in the folder where the moment group data #
#       file is stored, and ensure no .datx files you want to keep are in there#
################################################################################

# Remove existing frames from directory
rm -f frame*
rm -f *.datx

# Split the data file into multiple .datx files based on first column value
#awk -F\  'BEGIN{n=0} {fname=sprintf("%05d.datx", n); print > fname ; n++}' "$1"
gawk -F\  '{CONVFMT = "%012.7f"; OFMT = "%012.7f"; print > ($1 + 0.00000001) ".datx"}' $1


# Loop over each file, running the plot script each time
counter=0
for datafile in *.datx
do
    # datafile filename accessible in script as ARG1
    gnuplot -c "$2" "$datafile" "$(printf "frame%04d" "$counter")"
    let counter=counter+1
done

# Clean up .datx files
rm *.datx

# Collate .pngs into animation
ffmpeg -y -loglevel quiet -r 30 -f image2 -s 1600x900 -i frame%04d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p "$3".mp4

# done
rm frame*
