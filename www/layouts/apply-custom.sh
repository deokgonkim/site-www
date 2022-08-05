#!/bin/bash

export THEME_PATH=../themes/geekblog

export ENVS='$GOOGLE_ADS_ID'

cat ./partials/head/custom.html | envsubst "$ENVS" >> ${THEME_PATH}/layouts/partials/head/custom.html
