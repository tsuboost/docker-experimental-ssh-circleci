#!/bin/sh

temp=$(mktemp -d)

# Generate CircleCI-compatible ssh key
# Ref: https://circleci.com/docs/2.0/add-ssh-key/
ssh-keygen -E md5 -m PEM -t rsa -C "your_email@example.com" -f $temp/id_rsa -N ''

echo 'Private key:'
cat $temp/id_rsa

echo 'Public key:'
cat $temp/id_rsa.pub

echo 'CircleCI private key name:'
fingerprint=$(ssh-keygen -E md5 -lf $temp/id_rsa.pub | awk '{ print $2 }' | cut -c 5-)
echo id_rsa_${fingerprint//:/}

rm -r $temp
