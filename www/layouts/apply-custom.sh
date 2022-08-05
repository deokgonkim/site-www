#!/bin/bash

# read file and substitude environment variables

#export THEME_PATH=../themes/geekblog

export ENVS='$GOOGLE_ADS_ID'
echo "Using $GOOGLE_ADS_ID"

export FILES="./partials/head/custom.html.tpl"

for FILE in $FILES
do
  cat $FILE | envsubst "$ENVS" | tee ./${FILE%.tpl}
done
