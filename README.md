# Spoken Language Understanding (SLU) Module for Movie Domain using NL-SPARQL Data Set

# Second Project

**/Second/start.sh**: This script call Theano tool in order to execute all models, its requires one parameter, if negative number, run all models, if positive between 1..7, run a specific configuration file.

**/Second/files.sh**: Create the label and word dic- tionary, using the initial training dataset, split it in a training dataset with the 75% of the sentences and in a validation dataset with the remaining 25%.

**/Second/result/** output evaluation result

**/Second/rnn_slu/data/**: Train e Test files

**Example:**  

**./Start.sh -1** run all models

**./Start.sh 2** run model: config_2.cfg



# First Project

**/First/code/start.sh**: Used to start the Train/Test process, contains 3 parameters, smoothing, grammar and threshold. The parameter smoothing represents the smoothing method that can be ( 1=Absolute, 2=Katz, 3=Kneser Ney, 4=Pre-smoothed, 5=unsmoothed, 6=Witten bell). The grammar parameter represents the n-gram order the in- terval is between 1-5, the last parame- ter represents the Cut-off threshold, with 0 without cut-off. if smoothing method is negative,the script run all possible combination of method n-grammar and threshold.

**/First/code/trainTest.sh**: Script used to train and test the ML.

**/First/code/transducer_UNK.sh**: Create the Transducer files for known tokens. 

**/First/code/transducer.sh**: Create the Transducer files for Unknown tokens.

**/First/result/** output evaluation result

**/First/data/**: Train e Test files

**Example:**  

**./Start.sh 1 3 0** run smoothing method Absolute. grammar order 3.  cut-off No.

**./Start.sh -1** run all combinations smoothing method [1-6] / grammar order  [1-5] / cut-off threshold [0-2]
