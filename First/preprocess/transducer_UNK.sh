#!/bin/bash
total=$(cat ../data/POS.counts | wc -l | bc -l)
prob=$(echo "-l(1/$total)" | bc -l)
while read pos count
do
   echo -e "0\t0\t<unk>\t$pos\t$prob"
done < ../data/POS.counts
echo "0"