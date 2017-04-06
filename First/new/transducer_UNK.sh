#!/bin/bash
treshold=$1
countUnk=$2
total=$(cat ../data/POS.counts | wc -l | bc -l)
prob=$(echo "-l(1/$total)" | bc -l)
while read pos count
do	
	if [ $treshold -eq 0 ]
	then
		cost=$(echo "-l(1 / $total)" | bc -l)   
	else
		countUnk=$((countUnk / $total))      
 	     #total =41  count=x countUnk=1790  =  count/countUNk
	    cost=$(echo "-l($countUnk / $count)" | bc -l)
	    #cost=$(echo "-l(($countUnk / $total) / $count)" | bc -l)
	fi
	echo -e "0\t0\t<unk>\t$pos\t$cost"
done < ../data/POS.counts
echo "0"
