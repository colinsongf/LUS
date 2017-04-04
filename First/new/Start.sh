#!/bin/bash

#train = '../data/NLSPARQL.train.data'
#test = '../data/NLSPARQL.test.data'

echo "START"
#./Start.sh $train 'witten_bell' 3
#./Test.sh  $test > result_witten_bell_3.txt
#perl test.pl -d " " < result_witten_bell_3.txt > val_witten_bell_3.txt
./clear.sh


train='../data/NLSPARQL.train.feats.txt'
test='../data/NLSPARQL.test.feats.txt'

cat $train | cut -f 2 > ../data/tok_actual.txt
#cat $train | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > ../data/tok_sentences_eactual_line.txt
cat $train | cut -f 1  > ../data/sentences.txt
cat $train | cut -f 1 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > ../data/sentences_line.txt
echo "START Lemma"
python lemma.py  '../data/NLSPARQL.train.tok' '../data/sentences_line.txt' '../data/NLSPARQL.train.feats.txt'
echo "END Lemma" 


echo "END"