#!/bin/bash

train='../data/NLSPARQL.train.data'
test='../data/NLSPARQL.test.data'

echo "START"

./clear.sh

./Train.sh $train 'witten_bell' '3'

./Test.sh $test 'result_witten_bell_3.txt' 0 ''

perl conlleval.pl -d " " < result_witten_bell_3.txt > val_witten_bell_3.txt


#./Train.sh $train 'witten_bell' '3'
#./Test.sh $test 'result_witten_bell_3_lemma.txt' 1 '../data/NLSPARQL.test.feats.txt' 



echo "END"