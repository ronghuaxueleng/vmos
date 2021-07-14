#!/bin/bash

for file in $(ls ca/* | grep -v tmp.pem)
do
  echo $file
  if [[ $file =~ ".crt" ]]
  then
      openssl x509 -in $file -out ca/tmp.pem
      caName=`openssl x509 -subject_hash_old -in ca/tmp.pem -noout`
  else
      caName=`openssl x509 -subject_hash_old -in $file -noout`
  fi
  echo $caName
done