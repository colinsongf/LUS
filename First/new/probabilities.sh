#!/bin/bash
while read token pos count
do
    # get pos counts
    #echo grep "^$pos[[:space:]]" POS.counts
    poscount=$(grep "^$pos[[:space:]]" $1 | cut -f 2)
    # calculate probability
    prob=$(echo "-l($count / $poscount)" | bc -l)
    # print token, pos-tag & probability
    echo -e "$token\t$pos\t$prob"
done < $2