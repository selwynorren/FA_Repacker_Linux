#!/bin/bash

# Define parameters
output=""
clean=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --output) output="$2"; shift ;;
        --clean) clean=true ;;
    esac
    shift
done

# Set path variables
path=$(pwd)
if [ -z "$output" ]; then
    output="$path"
fi

start_time=$(date)
cd "$path"

# Uncomment to process only "Legacy"
#areas=("Legacy")
areas=("Assets" "Textures_Natural" "Textures_Artificial" "Legacy" "Roof_Patterns" "Roofs")

for current_focus in "${areas[@]}"; do
    # Uncomment the line below to manually set the current focus
    # current_focus="Textures_Artificial"

    pack_prefix="FA_${current_focus}_REPACK_"
    # Uncomment to use MM-dd-yy format for pack name
    # pack_name="${pack_prefix}$(date +%m-%d-%y)"
    pack_name="${pack_prefix}$(date +%Y)"
    joined_path="${path}/${current_focus}/joined"

    # Create necessary directories
    mkdir -p "$joined_path"
    mkdir -p "${current_focus}/unpacked"

    # Unpack files using dungeondraft-unpack
    find . -maxdepth 1 -type f -name "*$current_focus*" -print0 | while IFS= read -r -d '' file; do
        ./dungeondraft-unpack -O -vv "$file" "${current_focus}/unpacked"
    done

    # Navigate to the current focus directory
    cd "$current_focus"
    mkdir -p "joined"

    # Process the unpacked directory
    cd "unpacked"
    first_dir=$(find . -maxdepth 1 -type d | sed -n '2p')
    cd "$first_dir"

    # Read and manipulate JSON manifest
    manifest_file="pack.json"
    manifest=$(jq '.' "$manifest_file")
    
    # Uncomment and modify the lines below if manifest fields need to be updated
    # manifest=$(echo "$manifest" | jq ".name=\"$pack_name\"")
    # manifest=$(echo "$manifest" | jq ".version=\"$(date +%m%d%y)\"")
    # manifest_id="FA$manifest"
    # manifest=$(echo "$manifest" | jq ".id=\"$manifest_id\"")
    echo "$manifest" | jq '.' > "$joined_path/pack.json"

    # Move preview.png to the joined directory
    find . -name "preview.png" -exec mv {} "$joined_path" \;

    cd ..

    # Move content from unpacked subdirectories to joined directory
    find . -maxdepth 1 -mindepth 1 -type d | while IFS= read -r subdir; do
        cd "$subdir"
        for folder in */; do
            source_path="${path}/${current_focus}/unpacked/${subdir}/${folder}"
            cp -r "$source_path"/* "$joined_path/"
        done
        cd ..
    done

    cd ..
    
    # Remove unpacked directory
    rm -rf "unpacked"

    cd ..
    
    # Remove older repacks
    find . -maxdepth 1 -type f -name "${pack_prefix}*" -exec rm -f {} +

    # Repack using dungeondraft-pack
    author=$(echo "$manifest" | jq -r '.author')
    ./dungeondraft-pack -O -E -A "$author" -N "$pack_name" -V "$(date +%m%d%y)" "$joined_path" "$output"
    
    # Clean up directories
    rm -rf "$current_focus"
    if [ "$clean" = true ]; then
        find . -maxdepth 1 -type f -name "*$current_focus*" -exec rm -f {} +
    fi

    echo "Start Time: $start_time"
    echo "End Time: $(date)"
done
