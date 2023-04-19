#!/usr/bin/env bash
#2号台架
# IPC2_IP=10.13.112.101
# IPD2_IP=192.168.30.42
# IPC2_USERNAME=10.13.112.
# IPC2_PASSWD=10.13.112.
# IPD2_USERNAME=10.13.112.
# IPD2_PASSWD=10.13.112.

# #3号台架
# IPC3_IP=10.13.112.101
# IPD3_IP=192.168.30.42
# IPC3_USERNAME=fleet
# IPC3_PASSWD=1024
# IPD3_USERNAME=10.13.112.
# IPD3_PASSWD=10.13.112.

# #the end
# if [ $1 ]; then
#      # if body
# elif [ condition ]; then
#      # else if body
# else
#      # else body
# fi

# IPC_IP=IPC
# IPD_IP=192.168.30.42
# IPC_USERNAME=10.13.112.
# IPC_PASSWD=10.13.112.
# IPD_USERNAME=10.13.112.
# IPD_PASSWD=10.13.112.

# nohup sshpass -p IPC3_PASSWD scp build/deploy/modules/mff/lib/libhmi_core.so fleet@IPC_IP:/dev/shm &
# sleep 5
# nohup sshpass -p "123@byd" scp /dev/shm/libhmi_core.so idc@192.168.30.42:/dev/shm &
# sleep 5
# nohup sshpass -p "1024" ssh -o StrictHostKeyChecking=no fleet@10.13.112.101 'bash /userdata/momenta/deploy/modules/startup_config/script/boot/stop_all.sh && cp -f /dev/shm/libhmi_core.so /userdata/momenta/deploy/modules/mff/lib/ && bash /userdata/momenta/deploy/modules/startup_config/script/boot/start_all.sh' &
# sleep 5
# nohup sshpass -p "123@byd" ssh idc@192.168.30.42 'bash /userdata/momenta/deploy/modules/startup_config/script/boot/stop_all.sh && cp -f /dev/shm/libhmi_core.so /userdata/momenta/deploy/modules/mff/lib/ && bash /userdata/momenta/deploy/modules/startup_config/script/boot/start_all.sh' &


#!/bin/bash

# 获取要连接的台架编号，输入参数 2 或 3
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <rack_number>"
  exit 1
fi

RACK_NUMBER=$1

# 根据不同的台架编号设置相应的用户名、密码和主机IP地址
case $RACK_NUMBER in
  2)
    IPC_USER="mm"
    IPC_PASSWD="mm"
    USER="idc"
    PASSWD="123@byd"
    IDC_HOST="192.168.30.42"
    ORIN_HOST="10.13.112.100"
    ;;
  3)
    IPC_USER="fleet"
    IPC_PASSWD="1024"
    USER="idc"
    PASSWD="123@byd"
    IDC_HOST="192.168.30.42"
    ORIN_HOST="10.13.112.101"
    ;;
  *)
    echo "Invalid rack number: $RACK_NUMBER"
    exit 1
    ;;
esac

echo "copy to ipc libhmi_core"
nohup sshpass -p IPC_PASSWD scp build/deploy/modules/mff/lib/libhmi_core.so IPC_USER@IPC_IP:/dev/shm &
sleep 5

echo "login ipc"
sshpass -p $PASSWD ssh $IPC_USER@$IPC_PASSWD 

# 将 libhmi_core.so 文件从本地复制到 IDC-B-03 的目录下
echo "copy libhmi_core from ipc to idc "
nohup sshpass -p $PASSWD scp /dev/shm/libhmi_core.so $USER@$IDC_HOST:/dev/shm/deploy/modules/mff/lib/ &

# 远程登录IDC并获取版本信息
sshpass -p $PASSWD ssh $USER@$IDC_HOST cat /etc/bsp-version


# 向 Fleet 上的 IPC 或 IDC 发送命令，停止所有应用程序，并启动新的应用程序
nohup sshpass -p $PASSWD ssh $USER@$IDC_HOST 'bash /dev/shm/deploy/modules/startup_config/script/boot/stop_all.sh && cp -f /dev/shm/libhmi_core.so /dev/shm/deploy/modules/mff/lib/ && bash /dev/shm/deploy/modules/startup_config/script/boot/start_all.sh' &
