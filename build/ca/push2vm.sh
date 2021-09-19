#!/bin/bash

ADB_HOME=$(cd ../../platform-tools;pwd)

function push() {
    # adb 连接到 vmos 虚拟机
    $ADB_HOME/adb connect $1

    # 拷贝文件
    $ADB_HOME/adb push buildCa/$2 /system/etc/security/cacerts/

    # 修改文件权限
    $ADB_HOME/adb shell <<EOF
    cd /system/etc/security/cacerts/
    chmod 644 $2
    exit
EOF
  $ADB_HOME/adb disconnect $1
}

for file in $(ls buildCa/*)
do
  filename=$(basename $file)
  echo $filename
  push $1 $filename
done