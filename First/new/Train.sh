#!/bin/bash
train=$1
#train='../data/NLSPARQL.train.data'
method=$2
#method='witten_bell'
order=$3
#order=3
treshold=$4
#treshold=0

echo "START Train"


echo "POS"
cat $train | cut -f 2 | sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$1}' > ../data/POS.counts

echo "TOK_POS"
cat $train| sed '/^ *$/d' | sort | uniq -c | sed 's/^ *//g' | awk '{OFS="\t" ; print $2,$3,$1}' > ../data/TOK_POS.counts

echo "Probabilities"
countUnk=0
total=$(cat ../data/POS.counts | wc -l | bc -l)
while read token pos count
do
	if [ "$count" -gt "$treshold" ]; then	
	    # get pos counts
	    #echo grep "^$pos[[:space:]]" POS.counts
	    poscount=$(grep "^$pos[[:space:]]" ../data/POS.counts | cut -f 2)
	    # calculate probability
	    prob=$(echo "-l($count / $poscount)" | bc -l)
	    # print token, pos-tag & probability
	    echo -e "$token\t$pos\t$prob"
	else
		countUnk=$((countUnk + $count))
	fi
done < ../data/TOK_POS.counts > ../data/TOK_POS.probs


while read token pos count
do
	if [ "$count" -gt "$treshold" ]; 
	then	
	    echo -e "$token\t$pos\t$count"
	fi
done < ../data/TOK_POS.counts > ../data/TOK_POSaux.counts

cat ../data/TOK_POSaux.counts > ../data/TOK_POS.counts
#rm -f ../data/TOK_POSaux.counts


echo "LEXICO"
echo '<epsilon> 0' > ../data/A.lex 
cat ../data/TOK_POS.counts | sed '/^ *$/d' | awk '{OFS="\t" ; print $1}' | tr [:space:] '\n' |sort -gr | uniq |cat -n | awk '{OFS="\t" ; print $2,$1}' >> ../data/A.lex
cat $train | sed '/^ *$/d' | awk '{OFS="\t" ; print $2}'  | tr [:space:] '\n' |sort -gr | uniq > ../data/concept.txt
count=$(cat ../data/A.lex | wc -l | bc -l)
while read token
do
	echo -e "$token\t$count"
	count=$((count+1))
done < ../data/concept.txt >> ../data/A.lex
echo -e "<unk>\t$count" >> ../data/A.lex 




echo "Transducer"
./transducer.sh  ../data/POS.counts  ../data/TOK_POS.counts >> ../data/transducerTOK_POS.txt


echo "Transducer UNK"
./transducer_UNK.sh  $treshold $countUnk  >> ../data/transducerTOK_POS_UNK.txt
cat ../data/transducerTOK_POS_UNK.txt  >> ../data/transducerTOK_POS.txt

echo "Second Term"
cat $train | cut -f 2 | sed 's/^ *$/#/g' | tr '\n' ' ' | tr '#' '\n' | sed 's/^ *//g;s/ *$//g'  > ../data/secondTerm.txt


echo "FST Transducer"

fstcompile --isymbols=../data/A.lex  --osymbols=../data/A.lex ../data/transducerTOK_POS.txt  > ../data/transducer.fst

echo "Train Language model"
farcompilestrings --symbols=../data/A.lex --unknown_symbol="<unk>" $train > ../data/data.far
ngramcount --order=$order --require_symbols=false ../data/data.far > ../data/pos.cnt
ngrammake --method=$method ../data/pos.cnt > ../data/pos.lm

echo "END Train"
