#!/bin/bash
smoothing=$1
grammar=$2
threshold=$3

# smoothing [| absolute || katz || kneser_ney || presmoothed || unsmoothed || witten_bell |]  <br />
#threshold for the cut-off frequency (0- No cut-off) <br />

echo "START"

part_1="../result/"
part_2="aux.txt"
part_3=".txt"
part_4="_"
smmothing=""
train='../data/NLSPARQL.train.data'
test='../data/NLSPARQL.test.data'


case $smoothing in
	   1) smmothing="absolute"	;;
	   2) smmothing="katz"	;;
	   3) smmothing="kneser_ney"	;;
	   4) smmothing="presmoothed"	;;
	   5) smmothing="unsmoothed"	;;
	   6) smmothing="witten_bell"	;;
	*)
esac
fileaux=$part_1$smmothing$part_4$grammar$part_4$threshold$part_2
file=$part_1$smmothing$part_4$grammar$part_4$threshold$part_3

if [ $smoothing -ge 0 ]; 
then
	echo $fileaux
	echo $file
	./clear.sh
	./Train.sh $train $smmothing $grammar $threshold
	./Test.sh $test $fileaux 0 ''
	perl conlleval.pl -d "\t" < $fileaux  >$file
	rm -f $fileaux
else
	for s in {1..6}
	do
		
		case $s in
		   1) smmothing="absolute"	;;
		   2) smmothing="katz"	;;
		   3) smmothing="kneser_ney"	;;
		   4) smmothing="presmoothed"	;;
		   5) smmothing="unsmoothed"	;;
		   6) smmothing="witten_bell"	;;

		*)
		esac

		for g in {1..5}
		do
			fileaux=$part_1$smmothing$part_4$g$part_2
			file=$part_1$smmothing$part_4$g$part_3
			echo $fileaux
			echo $file
			./clear.sh
			./Train.sh $train $smmothing $g 0
			./Test.sh $test $fileaux 0 ''
			perl conlleval.pl -d "\t" < $fileaux  >$file
			#rm -f $fileaux
		done
	done
fi

echo "END"

