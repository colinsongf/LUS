#!/bin/bash
smoothing=$1
grammar=$2
threshold=$3

# smoothing: absolute katz kneser_ney presmoothed unsmoothed witten_bell 
# threshold  cut-off frequency 0-No cut-off  

#####
#if threshold is negative a run all possibilities combianates smoothing(1-6)*gramar(1-5)*threshold(0-2)
#if threshold >= 0  then a runa a single task $smoothing-$grammar-$threshold
#####

echo "START"

part_1="../result/"
part_2="aux.txt"
part_3=".txt"
part_4="_"
smmothing=""

train='../data/NLSPARQL.train.data'
test='../data/NLSPARQL.test.data'

#method smoothing
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
	#clean previus data auxilar
	./clear.sh
	#train and test
	./TrainTest.sh $train $test $fileaux $smmothing $grammar $threshold 
	#evaluate
	perl conlleval.pl -d "\t" < $fileaux  >$file
	#remove auxfile
	rm -f $fileaux
else
	#method
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

		#grammar
		for g in {1..5}
		do

			#cutOff
			for c in {0..2}
			do
				fileaux=$part_1$smmothing$part_4$g$part_4$c$part_2
				file=$part_1$smmothing$part_4$g$part_4$c$part_3
				echo $fileaux
				echo $file
				#clean previus data auxilar
				./clear.sh
				#train and test
				./TrainTest.sh $train $test $fileaux $smmothing $g $c 
				#evaluate
				perl conlleval.pl -d "\t" < $fileaux  > $file
				#remove auxfile
				rm -f $fileaux
			done	
		done
	done
fi

echo "END"

