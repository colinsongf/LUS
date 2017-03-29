#!/bin/bash
#WORD TAG COUNT
echo "TOK_POS Positional Parameters"
echo '$1 = ' $1
cat $1 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$3,$1}' > ../data/TOK_POS.counts