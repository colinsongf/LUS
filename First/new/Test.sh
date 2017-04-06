#!/bin/bash
test=$1
#test='../data/NLSPARQL.test.data'
output=$2
lemma=$3
lemmadir=$4


echo "START Test"
cat $test | cut -f 2 > ../data/tok_actual.txt
#cat $test | cut -f 2 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > ../data/tok_sentences_eactual_line.txt
cat $test | cut -f 1  > ../data/sentences.txt
cat $test | cut -f 1 | sed 's/^ *$/#/g' | tr "\n" " "  | tr "#" "\n" > ../data/sentences_line.txt

echo "oi"
#cat ../data/TOK_POS.counts | sed '/^ *$/d' | awk '{OFS="\t" ; print $1}' | sort -gr  > a.txt
#cat ../data/NLSPARQL.train.data | sed '/^ *$/d' | awk '{OFS="\t" ; print $1}'  | tr [:space:] '\n' |sort -gr | uniq > b.txt
#grep -Fxvf a.txt b.txt > c.txt
#while read token
#do
#	sed -i "s/$token[[:space:]]/<unk>\t/g" ../data/sentences.txt 
#	sed -i "s/$[[:space:]]token[[:space:]]/ <unk> /g" ../data/sentences_line.txt 
	
#done < c.txt


#if [ $lemma -eq 1 ]
#then
#    echo "Lemma"
#	python lemma.py  '../data/sentences_line_aux.txt' '../data/sentences_line.txt' $lemmadir 
#	cat ../data/sentences_line_aux.txt > ../data/sentences_line.txt
#fi

while read line
do
	#python textToFst_unk.py $line > ../data/testFST.txt
	#cat ../data/testFST.txt	>> 	../data/testFSTCOPIA.txt
	#python textToFsa_unk.py $line > ../data/testFSA.txt
	#cat ../data/testFSA.txt	>> 	../data/testFSACOPIA.txt
	#cat ../data/testFSA.txt >> fsaww.txt
	echo "$line"
    #fstcompile --isymbols=../data/A.lex --osymbols=../data/A.lex ../data/testFST.txt > ../data/testFST.fst	
    #fstcompile --acceptor --isymbols=../data/A.lex ../data/testFSA.txt > ../data/testFSA.fsa	
	echo $line | farcompilestrings --symbols=../data/A.lex --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols | farextract --filename_suffix='.fst'

	#fstcompose ../data/testFST.fst ../data/transducer.fst | fstcompose - ../data/pos.lm | fstrmepsilon | fstshortestpath > ../data/line.fst
	#fstcompose ../data/testFSA.fsa ../data/transducer.fst | fstcompose - ../data/pos.lm | fstrmepsilon | fstshortestpath > ../data/line.fst
	fstcompose 1.fst ../data/transducer.fst | fstcompose - ../data/pos.lm | fstshortestpath | fstrmepsilon | fstshortestpath > ../data/line.fst

	#fstprint --isymbols=../data/A.lex --osymbols=../data/A.lex --fst_align ../data/line.fst | sort -r -g | cut -f 4 >> ../data/tok_predicted.txt
	fstprint --isymbols=../data/A.lex --osymbols=../data/A.lex --fst_align ../data/line.fst | sort -r -g | cut -f 4 >> ../data/tok_predicted.txt
	rm -f 1.fst
done < ../data/sentences_line.txt

paste ../data/sentences.txt ../data/tok_actual.txt ../data/tok_predicted.txt | sed '/^ *$/d' > $output
