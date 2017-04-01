#!/bin/bash
total=$(cat $1 | wc -l | bc -l)
prob=$(echo "-l(1/$total)" | bc -l)
while read pos count
do
   echo -e "0\t0\t<unk>\t$pos\t$prob"
done < $1
echo "0"