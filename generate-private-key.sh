#!/bin/sh

temp=$(mktemp -d)
echo temp=$temp

# Generate CircleCI-compatible ssh key
# Ref: https://circleci.com/docs/2.0/add-ssh-key/
ssh-keygen -m PEM -t rsa -C "your_email@example.com" -f $temp/id_rsa -N ''

cat $temp/id_rsa*
rm -r $temp
