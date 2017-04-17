# Spoken Language Understanding (SLU) Module for Movie Domain using NL-SPARQL Data Set


**name**: Rodrigo Joni Sestari 

**number**: 179020

**email**:rodrigo.sestari@studenti.unitn.it

**/First/code/start.sh**: Used to start the Train/Test process, contains 3 parameters, smoothing, grammar and threshold. The parameter smoothing represents the smoothing method that can be ( 1=Absolute, 2=Katz, 3=Kneser Ney, 4=Pre-smoothed, 5=unsmoothed, 6=Witten bell). The grammar parameter represents the n-gram order the in- terval is between 1-5, the last parame- ter represents the Cut-off threshold, with 0 without cut-off. if smoothing method is negative,the script run all possible combination of method n-grammar and threshold.

**/First/code/trainTest.sh**: Script used to train and test the ML.

**/First/code/transducer_UNK.sh**: Create the Transducer files for known tokens. 

**/First/code/transducer.sh**: Create the Transducer files for Unknown tokens.

**/First/result/** output evaluation result

**/First/data/**: Train e Test files

**Example:**  

**./Start.sh 1 3 0** run smoothing method Absolute. grammar order 3.  cut-off No.

**./Start.sh -1** run all combinations smoothing method [1-6] / grammar order  [1-5] / cut-off threshold [0-2]
