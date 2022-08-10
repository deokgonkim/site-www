#!/bin/bash

# read file and substitude environment variables

#export THEME_PATH=../themes/geekblog

if [ -f .env.sh ]; then
  source .env.sh
fi

export ENVS='$GOOGLE_ADS_ID,$GOOGLE_TM_ID,$GOOGLE_GA_ID'

export FILES="./partials/head/custom.html.tpl"

for FILE in $FILES
do
  cat $FILE | envsubst "$ENVS" | tee ./${FILE%.tpl}
done
