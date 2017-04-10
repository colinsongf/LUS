#!/bin/bash
treshold=$1
countUnk=$2
total=$(cat ../data/POS.counts | wc -l | bc -l)
prob=$(echo "-l(1/$total)" | bc -l)
while read pos count
do	
	cost=$(echo "-l(1 / $total)" | bc -l)   
	echo -e "0\t0\t<unk>\t$pos\t$cost"
done < ../data/POS.counts
echo "0"
