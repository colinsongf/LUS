#!/bin/bash
while read token pos count
do
    # get pos counts
    #echo grep "^$pos[[:space:]]" POS.counts
    poscount=$(grep "^$pos[[:space:]]" ../data/POS.counts | cut -f 2)
    # calculate probability
    prcatob=$(echo "$count / $poscount" | bc -l)
    # print token, pos-tag & probability
    prob=$(echo "-l($count / $poscount)" | bc -l)
    echo -e "$token\t$pos\t$prob"
done < ../data/TOK_POS.counts
