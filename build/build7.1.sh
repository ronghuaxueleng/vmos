#!/bin/bash

mkdir workdir
unzip rom/original7.1.zip -d workdir
cp -rf configs/build7.1.prop workdir/system/build.prop
chmod 644 workdir/system/build.prop

cp -rf configs/wpa_supplicant.conf workdir/system/etc/wifi/
cp -rf configs/wlanName workdir/data/netinfo/

rm -rf workdir/system/priv-app/Xposed
rm -rf workdir/data/data/de.robv.android.xposed.installer
rm -rf workdir/system/xposed.prop
rm -rf workdir/system/framework/XposedBridge.jar
rm -rf workdir/system/app/superuser
rm -rf workdir/system/app/via

cp -rf app workdir/system/

for file in $(ls ca/file/* | grep -v tmp.pem)
do
  echo $file
  if [[ $file =~ ".crt" ]]
  then
      openssl x509 -in $file -out ca/file/tmp.pem
      caName=`openssl x509 -subject_hash_old -in ca/file/tmp.pem -noout`
      cp ca/file/tmp.pem workdir/system/etc/security/cacerts/$caName.0
      rm -rf ca/file/tmp.pem
  else
      caName=`openssl x509 -subject_hash_old -in $file -noout`
      cp $file workdir/system/etc/security/cacerts/$caName.0
  fi
  echo $caName
  chmod 644 workdir/system/etc/security/cacerts/$caName.0
done

cd workdir
zip -9rq 安卓7.1纯净版64位.zip *
mv 安卓7.1纯净版64位.zip ../rom/
cd .. && rm -rf workdir