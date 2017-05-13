#!/bin/bash
train=$1
#train='../rnn_slu/data/NLSPARQL.train.data'
test=$2
#test='../rnn_slu/data/NLSPARQL.test.data'
percent=$3
#75

echo "creating files"


#Create count file for C(ti), from 2 column tab-separated token-per-line format: 1st column - tokens, 2nd column-Concept
cat $train | cut -f 2 | sed '/^ *$/d'  | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' > ../rnn_slu/data/POS.counts

echo '<unk> 0' > ../rnn_slu/data/A.lex 
cat $train  |cut -f 1 | sed '/^ *$/d'  | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../rnn_slu/data/A.lex



cat $test  | tr '\t' '#'  > ../rnn_slu/data/sentences.txt


cat ../rnn_slu/data/sentences.txt | cut -f 1  | sed 's/^ *$/$/g' | tr "\n" " "  | tr "$" "\n" > ../rnn_slu/data/sentences_line.txt

awk 'BEGIN{srand()}{print rand(),$0}' ../rnn_slu/data/sentences_line.txt | sort -n | cut -d ' ' -f2- >  ../rnn_slu/data/sentences_Shuffle.txt


lines=$(cat ../rnn_slu/data/sentences_Shuffle.txt | wc -l | bc -l)

 
trainlines=$(echo "(($lines/100)*$percent)" | bc)
count=0

while read line
do	
	if [ "$count"  -gt  "$trainlines" ]; then	
	   echo $line"$"  >> ../rnn_slu/data/valid_aux.txt 
	else
		echo $line"$" >> ../rnn_slu/data/train_aux.txt 
	fi
	count=$((1 + $count))
done <  ../rnn_slu/data/sentences_Shuffle.txt

cat ../rnn_slu/data/valid_aux.txt    | tr " " "\n" | tr "#" "\t" | tr "$" "\n"  > ../rnn_slu/data/valid.txt
cat ../rnn_slu/data/train_aux.txt    | tr " " "\n" | tr "#" "\t" | tr "$" "\n"  > ../rnn_slu/data/train.txt 
echo $count
echo $lines
echo $trainlines





