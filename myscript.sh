#!/bin/bash

# Принять обе директории как аргументы
input_dir="$1"
output_dir="$2"

# Создание выходной директорию, если она не существует
mkdir -p "$output_dir"

function copy_files {
    # Перебор всех элементов в текущей директории
    for file in "$1"/*; do
        if [[ -d "$file" ]]; then
            # Рекурсивно вызвать функцию если элемент является директорией
            copy_files "$file"
        elif [[ -f "$file" ]]; then
            # Определить базовое имя и расширение файла
            base=$(basename "$file")
            ext=""

            if [[ "$base" == *.* ]]; then
                ext=".${base##*.}"
                base="${base%.*}"
            fi

            new_file="$output_dir/${base}${ext}"

            # Решение проблемы одинаковых имен файлов в выходной директории
            if [[ -f "$new_file" ]]; then
                i=1
                while [[ -f "$output_dir/${base}_${i}${ext}" ]]; do
                    let i++
                done
                new_file="$output_dir/${base}_${i}${ext}"
            fi

            # Копирование файла из входной директории в выходную
            cp "$file" "$new_file"
        fi
    done
}

# Начальный вызов функции с входной директорией
copy_files "$input_dir"
