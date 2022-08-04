#!/bin/bash

echo "ACCOUNT_ID"; read ACCOUNT_ID; export ACCOUNT_ID
echo "USER_NAME"; read USER_NAME; export USER_NAME
echo "BUCKET_NAME"; read BUCKET_NAME; export BUCKET_NAME
echo "AWS_CLOUDFRONT_ID"; read AWS_CLOUDFRONT_ID; export AWS_CLOUDFRONT_ID

cat bucket-access-policy.json | envsubst '$ACCOUNT_ID,$USER_NAME,$BUCKET_NAME,$AWS_CLOUDFRONT_ID'
