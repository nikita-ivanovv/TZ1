#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Ошибка, верный ввод: $0 <input_directory> <output_directory>"
fi

input_dir=$1
output_dir=$2

files=$(find $input_dir -maxdepth 1 -type f)
dirs=$(find $input_dir -mindepth 1 -type d)

for file in $files; do
    cp $file $output_dir
done

for dir in $dirs; do
    internal_files=$(find $dir -type f)
    for file in $internal_files; do
        curr_filename=$(basename $file)
        new_filename="$output_dir/$curr_filename"
        cnt=1
        while [ -e "$new_filename" ]; do
            new_filename="$output_dir/${curr_filename%.*}_$cnt.${curr_filename##*.}"
            ((cnt++))
        done
        cp $file $new_filename
    done
done