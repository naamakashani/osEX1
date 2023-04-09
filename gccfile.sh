#!/bin/bash

#Naama Kashani 312400476

 if [ $# -lt 2 ];then 

    echo "Not enough parameters" 

    exit 1

fi 

dirname=$1

word=$2

cd "$dirname"

rm -f *.out 

matching_files=$(find . -type f -name "*.c" -exec grep -lw -o "$word[!.]*" {} +)

if [ -n "$matching_files" ]; then 

	for file in "$matching_files"; do 

    	  gcc "$file" -o "${file%.*}"

	done 

fi 

if [ "$3" == "-r" ]; then 

    find . -type f -name "*.out" -exec -rm -f {} +

fi
