#!/bin/bash
echo "Second term START"
cat $1 | cut -f 2 | sed 's/^ *$/#/g' | tr '\n' ' ' | tr '#' '\n' | sed 's/^ *//g;s/ *$//g'  > ../data/secondoterm.txt
echo "Second term END"


