#!/bin/bash

mkdir workdir
unzip original7.1.zip -d workdir
cp -rf configs/build7.1.prop workdir/system/build.prop
chmod 644 workdir/system/build.prop

cp -rf configs/wpa_supplicant.conf workdir/system/etc/wifi/
cp -rf configs/wlanName workdir/data/netinfo/

rm -rf workdir/system/priv-app/Xposed
rm -rf workdir/data/data/de.robv.android.xposed.installer
rm -rf workdir/system/xposed.prop
rm -rf workdir/system/framework/XposedBridge.jar
rm -rf workdir/system/app/superuser

for file in $(ls ca/* | grep -v tmp.pem)
do
  echo $file
  if [[ $file =~ ".crt" ]]
  then
      openssl x509 -in $file -out ca/tmp.pem
      caName=`openssl x509 -subject_hash_old -in ca/tmp.pem -noout`
      cp ca/tmp.pem workdir/system/etc/security/cacerts/$caName.0
      rm -rf ca/tmp.pem
  else
      caName=`openssl x509 -subject_hash_old -in $file -noout`
      cp $file workdir/system/etc/security/cacerts/$caName.0
  fi
  echo $caName
  chmod 644 workdir/system/etc/security/cacerts/$caName.0
done

cd workdir
zip -r 安卓7.1纯净版64位.zip *
mv 安卓7.1纯净版64位.zip ../
cd .. && rm -rf workdir