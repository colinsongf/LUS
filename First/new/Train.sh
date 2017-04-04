#!/bin/bash
train=$1
#train='../data/NLSPARQL.train.data'
method=$2
#method='witten_bell'
order=$3
#order=3

echo "START Train"

echo "LEXICO"
echo '<epsilon> 0' > ../data/A.lex 
cat $train  | sed '/^ *$/d'  | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../data/A.lex
count=$(cat ../data/A.lex | wc -l | bc -l)
echo -e "<unk>\t$count" >> ../data/A.lex 

echo "POS"
cat $train | cut -f 2 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$1}' > ../data/POS.counts

echo "TOK_POS"
cat $train| sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$3,$1}' > ../data/TOK_POS.counts

echo "Probabilities"
./probabilities.sh ../data/POS.counts ../data/TOK_POS.counts >> ../data/TOK_POS.probs

echo "Transducer"
./transducer.sh  ../data/POS.counts  ../data/TOK_POS.counts >> ../data/transducerTOK_POS.txt

echo "Transducer UNK"
./transducer_UNK.sh  ../data/POS.counts  >> ../data/transducerTOK_POS_UNK.txt

echo "Second Term"
cat $train | cut -f 2 | sed 's/^ *$/#/g' | tr '\n' ' ' | tr '#' '\n' | sed 's/^ *//g;s/ *$//g'  > ../data/secondTerm.txt

echo "FST Transducer"
cat ../data/transducerTOK_POS_UNK.txt  >> ../data/transducerTOK_POS.txt
fstcompile --isymbols=../data/A.lex --osymbols=../data/A.lex ../data/transducerTOK_POS.txt  > ../data/transducer.fst


echo "Train Language model"
farcompilestrings --symbols=../data/A.lex --unknown_symbol='<unk>' ../data/secondTerm.txt > ../data/data.far
ngramcount --order=$order --require_symbols=false ../data/data.far > ../data/pos.cnt
ngrammake --method=$method ../data/pos.cnt > ../data/pos.lm

echo "END Train"
