#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage:"
    echo "./resize.sh [directory_name] [size]"
    echo "Example:"
    echo "./resize.sh 2024-3d-printer 1024x768"
    exit 1
fi

INPUT_PATH=$1
FILE_PATH="${INPUT_PATH%/}"

SIZE=$2
if [ -z "$SIZE" ]; then
    SIZE=1024x768
fi

for I in $FILE_PATH/*
do
    if [[ "$I" == *"_resized"* ]]; then
        echo "Skipping $I"
    else 
        echo "Converting $I"
        convert -resize $SIZE $I ${I%.*}_resized.jpg
    fi
done
