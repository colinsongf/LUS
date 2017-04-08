#!/bin/bash
train=$1
#train='../data/NLSPARQL.train.data'
test=$2
#test='../data/NLSPARQL.test.data'
output=$3
#../result/.....aux.txt
method=$4
#method='witten_bell'
order=$5
#order=3
treshold=$6
#treshold=0

echo "START Train"

echo "POS"
#Create count file for C(ti), from 2 column tab-separated token-per-line format: 1st column - tokens, 2nd column-Concept
cat $train | cut -f 2 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$1}' > ../data/POS.counts

echo "TOK_POS"
#Create count file for C(ti,wi), from 2 column tab-separated token-per-line format: 1st column-tokens, 2nd column-Concept, 3th Counts
cat $train| sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$3,$1}' > ../data/TOK_POS.counts

echo "Probabilities"
#Calculate probabilities P(wi|ti)
countUnk=0
total=$(cat ../data/POS.counts | wc -l | bc -l)
while read token pos count
do
	#analising the treshold Cut-off
	if [ "$count" -gt "$treshold" ]; then	
	    # get pos counts
	    poscount=$(grep "^$pos[[:space:]]" ../data/POS.counts | cut -f 2)
	    # calculate probability −ln(x)
	    prob=$(echo "-l($count / $poscount)" | bc -l)
	    # print token, pos-tag & probability
	    echo -e "$token\t$pos\t$prob"
	else
		#count tokens removed by cut-off
		countUnk=$((countUnk + $count))
	fi
done < ../data/TOK_POS.counts > ../data/TOK_POS.probs


#Update the TOK_POS.counts with only the lines do not removed by the cut-off.
#It's necessary to remove thesi tokens from the Lexico File A.lex
while read token pos count
do
	if [ "$count" -gt "$treshold" ]; 
	then	
	    echo -e "$token\t$pos\t$count"
	fi
done < ../data/TOK_POS.counts > ../data/TOK_POSaux.counts
cat ../data/TOK_POSaux.counts > ../data/TOK_POS.counts


echo "create LEXICO  remove cut-off"
#Creating the Lexico File
echo '<epsilon> 0' > ../data/A.lex 
cat ../data/TOK_POS.counts | sed '/^ *$/d' | awk '{OFS="\t" ; print $1}' | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../data/A.lex
cat $train | sed '/^ *$/d' | awk '{OFS="\t" ; print $2}'  | tr [:space:] '\n' |sort -gr | uniq > ../data/concept.txt
count=$(cat ../data/A.lex  | wc -l | bc -l)
while read token
do
	echo -e "$token\t$count"
	count=$((count+1))
done < ../data/concept.txt >> ../data/A.lex
echo -e "<unk>\t$count" >> ../data/A.lex 


echo "Transducer"
#Create the Transducer WFST  file
./transducer.sh  ../data/POS.counts  ../data/TOK_POS.counts >> ../data/transducerTOK_POS.txt

echo "Transducer UNK"
# another transducer WFST file for unknown words
# if treshold cut-off = 0 then the unknown word has equal probability for all concept P(<unk> |ti)
./transducer_UNK.sh  $treshold $countUnk  >> ../data/transducerTOK_POS_UNK.txt
cat ../data/transducerTOK_POS_UNK.txt  >> ../data/transducerTOK_POS.txt

echo "Second Term"
# Convert token-per-line format into Concept sentence-per-line format
cat $train | cut -f 2 | sed 's/^ *$/#/g' | tr '\n' ' ' | tr '#' '\n' | sed 's/^ *//g;s/ *$//g'  > ../data/secondTerm.txt

echo "FST Transducer"
#compile the WFST text to file
fstcompile --isymbols=../data/A.lex  --osymbols=../data/A.lex ../data/transducerTOK_POS.txt  > ../data/transducer.fst

echo "Train Language model"
#text to FAR
farcompilestrings --symbols=../data/A.lex --unknown_symbol='<unk>' ../data/secondTerm.txt > ../data/data.far
#represent counts of n-grams
ngramcount --order=$order --require_symbols=false ../data/data.far > ../data/pos.cnt
#represent a n-gram back-off stochastic LM
ngrammake  --method=$method ../data/pos.cnt > ../data/pos.lm



echo "START Test"

#represents the the actual conpect
cat $test | cut -f 2  > ../data/tok_actual.txt
#represents the sentences token-per-line
cat $test | cut -f 1  > ../data/sentences.txt
#represents the sentences by-line
cat $test | cut -f 1  | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > ../data/sentences_line.txt

#for each sentence into test file
while read line
do

	echo "$line"
	#Intersect the string with the FSM
	echo $line | farcompilestrings --symbols=../data/A.lex --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'
	#Compose sentence, concept FST and the POS-LM in a sequence
	fstcompose 1.fst ../data/transducer.fst | fstcompose - ../data/pos.lm  | fstrmepsilon | fstshortestpath > ../data/line.fst
	#print the result and get the predict concepts
	fstprint --isymbols=../data/A.lex --osymbols=../data/A.lex --fst_align ../data/line.fst |  sort -r  -g  | cut -f  4        >> ../data/tok_predicted.txt
	
done < ../data/sentences_line.txt

#create a result file:  (token - actual - predict) 
paste ../data/sentences.txt ../data/tok_actual.txt ../data/tok_predicted.txt | sed '/^ *$/d' > $output
