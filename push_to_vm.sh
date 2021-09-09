#!/bin/bash

ADB_HOME=./platform-tools
export ADB_HOME #升级为环境变量

function push() {
    # adb 连接到 vmos 虚拟机
    adb connect $1

    # 拷贝文件
    adb push buildCa/$2 /system/etc/security/cacerts/

    # 修改文件权限
    adb shell <<EOF
    cd /system/etc/security/cacerts/
    chmod 644 $2
    exit
EOF
  adb disconnect $1
}

for file in $(ls buildCa/*)
do
  filename=$(basename $file)
  echo $filename
  push $1 $filename
done