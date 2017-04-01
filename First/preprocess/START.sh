#!/bin/bash
echo "START"
./Lexico.sh ../data/NLSPARQL.train.data 
./Pos.sh ../data/NLSPARQL.train.data
./Tok_pos.sh ../data/NLSPARQL.train.data
./Save_probabilities.sh
./Save_transducer.sh
./Save_transducer_UNK.sh
./Second_term.sh ../data/NLSPARQL.train.data

echo "END"