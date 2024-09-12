#!/bin/bash

# FA_Repacker.sh
Output=""
Clean=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            Output="$2"
            shift
            shift
            ;;
        -c|--clean)
            Clean=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

Path=$(pwd)
if [[ -z "$Output" ]]; then
    Output="$Path"
fi

startTime=$(date)

areas=("Assets") # Uncomment if needed
#areas=("Assets" "Textures_Natural" "Textures_Artificial" "Legacy" "Roof_Patterns" "Roofs")

for currentFocus in "${areas[@]}"; do
    packPrefix="FA_${currentFocus}_REPACK_"
    packName="${packPrefix}$(date +%m-%d-%y)"
    joinedPath="$Path/$currentFocus/joined"

    for file in *"$currentFocus"*; do
        if [[ -f "$file" ]]; then
            ./dungeondraft-unpack -O -vv "$file" "$currentFocus/unpacked"
        fi
    done

    cd "$currentFocus" || exit
    mkdir -p 'joined'

    cd "unpacked" || exit
    firstDir=$(ls -d */ | head -n 1 | cut -f1 -d'/')
    cd "$firstDir" || exit

    manifest=$(cat 'pack.json')
    # Uncomment and modify the following lines if needed
    # manifest=$(echo "$manifest" | jq --arg name "$packName" --arg version "$(date +%m%d%y)" --arg id "FA$manifest" '.name=$name | .version=$version | .id=$id')
    # echo "$manifest" | jq . > "$joinedPath/pack.json"

    mv "preview.png" "$joinedPath" 2>/dev/null

    cd .. || exit

    for dir in */; do
        ogName="${dir%/}"
        cd "$ogName" || exit
        for subDir in */; do
            sourcePath="$Path/$currentFocus/unpacked/$ogName/$subDir"
            destinationFolder="$joinedPath"

            # Move files from sourcePath to destinationFolder
            mv "$sourcePath"/* "$destinationFolder"/ 2>/dev/null
        done
        cd .. || exit
    done

    cd .. || exit

    rm -rf "unpacked"

    cd .. || exit
    # Remove older repacks:
    rm -f "$packPrefix"* 2>/dev/null
    ./dungeondraft-pack -O -E -A "$manifest.author" -N "$packName" -V "$(date +%m%d%y)" "$joinedPath" "$Output"

    rm -rf "$currentFocus" 2>/dev/null
    if $Clean; then
        rm -f *"$currentFocus"* 2>/dev/null
    fi

    echo "Start Time: $startTime"
    echo "End Time: $(date)"
done
