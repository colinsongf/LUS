#!/bin/bash
#WORD POS
echo "LEXICO START"
echo '$1 = ' $1
echo '<unk> 0' > ../data/A.lex 
cat $1  | sed '/^ *$/d'  | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../data/A.lex
echo "LEXICO END"