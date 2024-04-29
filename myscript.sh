#!/bin/bash

input_dir="$1"
output_dir="$2"

mkdir -p "$output_dir"

function copy_files {
    for file in "$1"/*; do
        if [[ -d "$file" ]]; then
            copy_files "$file"
        elif [[ -f "$file" ]]; then
            new_file="$output_dir/$(basename "$file")"
            if [[ -f "$new_file" ]]; then
                base="${file%.*}"
                ext="${file##*.}"
                i=1
                while [[ -f "$new_file" ]]; do
                    new_file="$output_dir/$(basename "$base")_$i.$ext"
                    let i++
                done
            fi
            cp "$file" "$new_file"
        fi
    done
}

copy_files "$input_dir"
