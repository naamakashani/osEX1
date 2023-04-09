#!/bin/bash

#Naama Kashani 312400476





 if [ $# -lt 2 ];then 

    echo "Not enough parameters" 

    exit 

fi 

echo $0

dirname=$1

word=$2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$script_dir/$dirname"



if [ "$3" == "-r" ]; then 

    find . -type f -name "*.out" -delete

    matching_files="$(find . -type f -name "*.c" -exec grep -lw -o "$word[!.]*" {} +)"

  

else

    rm -f *.out

    matching_files="$(find . -maxdepth 1 -type f -name "*.c" -exec grep -lw -o "$word[!.]*" {} +)"

fi



if [ -n "$matching_files" ]; then 

	for file in $matching_files; do 

    	  gcc -w -o "${file%.*}.out" "$file"

	done 

fi 

