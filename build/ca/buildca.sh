#!/bin/bash

for file in $(ls file/* | grep -v tmp.pem)
do
  echo $file
  if [[ $file =~ ".crt" ]]
  then
      openssl x509 -in $file -out file/tmp.pem
      caName=`openssl x509 -subject_hash_old -in file/tmp.pem -noout`
      rm -rf file/tmp.pem
  else
      caName=`openssl x509 -subject_hash_old -in $file -noout`
  fi
  echo $caName
  cp $file buildCa/$caName.0
done