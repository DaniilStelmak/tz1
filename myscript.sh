#!/bin/bash

input_dir="$1"
output_dir="$2"

# Создаём выходную директорию, если она не существует
mkdir -p "$output_dir"

function copy_files {
    # Перебор всех элементов в текущей директории (включая скрытые)
    for file in "$1"/* "$1"/.*; do
        # Исключить текущую и родительскую директории
        if [[ "$file" != "$1/." && "$file" != "$1/.." ]]; then
            if [[ -d "$file" && -r "$file" ]]; then
                # Рекурсивно копировать если это директория и доступна для чтения
                copy_files "$file"
            elif [[ -f "$file" || -L "$file" && -r "$file" ]]; then
                base=$(basename "$file")
                ext=""

                if [[ "$base" == *.* ]]; then
                    ext=".${base##*.}"
                    base="${base%.*}"
                fi

                new_file="$output_dir/${base}${ext}"

                # Решение конфликта одинаковых имен файлов
                if [[ -e "$new_file" ]]; then
                    i=1
                    while [[ -e "$output_dir/${base}_${i}${ext}" ]]; do
                        let i++
                    done
                    new_file="$output_dir/${base}_${i}${ext}"
                fi

                # Копировать файл или ссылку
                if [[ -L "$file" ]]; then
                    # Копировать ссылку
                    cp -d "$file" "$new_file"
                else
                    # Копировать файл
                    cp "$file" "$new_file"
                fi
            fi
        fi
    done
}

# Начальный вызов функции
copy_files "$input_dir"
