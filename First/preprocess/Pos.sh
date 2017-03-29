#!/bin/bash
#TAG COUNT
echo "POS START"
echo '$1 = ' $1
cat $1 | cut -f 2 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$1}' > ../data/POS.counts
echo "POS END"