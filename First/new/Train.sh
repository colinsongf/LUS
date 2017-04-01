#!/bin/bash

echo "START Train"

echo "LEXICO"
echo '<unk> 0' > ../data/A.lex 
cat ../data/NLSPARQL.train.data  | sed '/^ *$/d'  | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../data/A.lex

echo "POS"
cat ../data/NLSPARQL.train.data | cut -f 2 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$1}' > ../data/POS.counts

echo "TOK_POS"
cat ../data/NLSPARQL.train.data | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$3,$1}' > ../data/TOK_POS.counts

echo "Probabilities"
./probabilities.sh ../data/POS.counts ../data/TOK_POS.counts >> ../data/TOK_POS.probs

echo "Transducer"
./transducer.sh  ../data/POS.counts  ../data/TOK_POS.counts >> ../data/transducerTOK_POS.txt

echo "Transducer UNK"
./transducer_UNK.sh  ../data/POS.counts  >> ../data/transducerTOK_POS_UNK.txt

echo "Second Term"
cat ../data/NLSPARQL.train.data | cut -f 2 | sed 's/^ *$/#/g' | tr '\n' ' ' | tr '#' '\n' | sed 's/^ *//g;s/ *$//g'  > ../data/secondTerm.txt

echo "END Train"