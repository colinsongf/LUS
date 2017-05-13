#!/bin/bash
config=$1
rnn=$2


echo "START"

part_1="../result/"
part_3=".txt"
part_4="_"

part_5="../rnn_slu/data/"
part_6='../rnn_slu/config_'
part_7='.cfg'





rnnfile=""

train='../rnn_slu/data/NLSPARQL.train.data'
test='../rnn_slu/data/NLSPARQL.test.data'
lex='../rnn_slu/data/A.lex'
label='../rnn_slu/data/POS.count'
elmatrain='../rnn_slu/lus/rnn_elman_train.py'
 elmatest='../rnn_slu/lus/rnn_elman_test.py'
jordantrain='../rnn_slu/lus/rnn_jordan_train.py'
 jordantest='../rnn_slu/lus/rnn_jordan_test.py'
configfile=$part_6$config$part_7

case $rnn in
	   1) rnnfile="elman"	;;
	   2) rnnfile="jordan"	;;
	*)
esac

filemodel-elman='../rnn_slu/data/model_elman'$config
filemodel-jordan='../rnn_slu/data/model_jordan'$config
test_out-elman='../rnn_slu/data/test_out_elaman_'$config$part_3
test_out-jordan='../rnn_slu/data/test_out_elaman_'$config$par

fileresult-elman=$part_1$rnntype$part_4$config$part_7$part_3


if [ $config -ge 0 ]; 
then
	echo $fileaux
	echo $file

	echo "Training"

	python ../rnn_slu/lus/rnn_elman_train.py <training_data> <validation_data> <word_dictionary> <label_dictionary> <config_file> <model_directory>
	
	python ../rnn_slu/lus/rnn_jordan_train.py <training_data> <validation_data> <word_dictionary> <label_dictionary> <config_file> <model_directory>


	echo "Test"

	python ../rnn_slu/lus/rnn_elman_test.py <model_directory> <test_file> <word_dictionary> <label_dictionary> <config_file> <output_file>

	python ../rnn_slu/lus/rnn_jordan_test.py <model_directory> <test_file> <word_dictionary> <label_dictionary> <config_file> <output_file>



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
		
		case $rnn in
			   1) rnnfile="elman"	;;
			   2) rnnfile="jordan"	;;
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

