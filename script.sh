#!/bin/bash

# Проверяем, что переданы два параметра
if [[ "$#" -ne 2 ]]; then
    echo "Ошибка, верный ввод: $0 <input_directory> <output_directory>"
fi

input_dir=$1
output_dir=$2

# Получение списка файлов, находящихся непосредственно во входной директории
files=$(find $input_dir -maxdepth 1 -type f)
# Получение списка всех директорий, находящихся во входной директории
dirs=$(find $input_dir -mindepth 1 -type d)

# Копирование найденных файлов в выходную директорию
for file in $files; do
    cp $file $output_dir
done

# Получение списка всех файлов, находящихся во вложенных во входную директориях
for dir in $dirs; do
    internal_files=$(find $dir -type f)
    for file in $internal_files; do
        # Решение проблемы с одноименными файлами
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
