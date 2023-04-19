#prepare
#command usage
#transshipment local ip

#remote shell
#start connect to 
#!/bin/bash

# 解析脚本参数
if [ "$1" == "local" ]; then
    local_mode=true
elif [ "$1" == "remote" ]; then
    local_mode=false
else
    echo "Usage: $0 [local|remote] [ip]"
    exit 1
fi

if [ "$local_mode" == false ] && [ -z "$2" ]; then
    echo "Usage: $0 remote [ip]"
    exit 1
fi

# 设置变量
ipc_vpn_ip="10.0.0.1"
ipc_local_ip="192.168.30.200"
idc_ip="192.168.30.42"
idc_user="idc"
idc_password="123@byd"

starthmilog_script="starthmilog.sh"
startmfflog_script="startmfflog.sh"
remote_dir="/root"

# 根据模式设置连接 IP
if [ "$local_mode" == true ]; then
    dest_ip="$idc_ip"
else
    dest_ip="$2"
fi

# 将脚本文件发送到目标服务器
if [ "$local_mode" == true ]; then
    # 发送到 IDC
    sshpass -p "$idc_password" ssh "$idc_user@$idc_ip" << EOF
        # 登录 IDC
        sshpass -p "$idc_password" ssh "$idc_user@$idc_ip" "echo \"$idc_password\" | sudo -S whoami > /dev/null"

        # 复制脚本文件到 IDC
        scp "$starthmilog_script" "$startmfflog_script" "$idc_user@$idc_ip:$remote_dir"

        # 启动脚本
        sshpass -p "$idc_password" ssh "$idc_user@$idc_ip" << EOSSH
            echo "$idc_password" | sudo -S $remote_dir/$starthmilog_script &
            echo "$idc_password" | sudo -S $remote_dir/$startmfflog_script &
EOSSH
EOF
else
    # 发送到远程服务器
    ssh "mm@$dest_ip" << EOF
        # 登录远程服务器
        ssh "$idc_user@$idc_ip" "echo \"$idc_password\" | sudo -S whoami > /dev/null"

        # 登录 IDC
        sshpass -p "$idc_password" ssh "$idc_user@$idc_ip" << EOSSH
            echo "$idc_password" | sudo -S ssh mm@"$dest_ip" "echo \"$idc_password\" | sudo -S whoami > /dev/null"

            # 复制脚本文件到 IDC
            echo "$idc_password" | sudo -S scp "$starthmilog_script" "$startmfflog_script" "$idc_user@$idc_ip:$remote_dir"

            # 启动脚本
            echo "$idc_password" | sudo -S ssh "$idc_user@$idc_ip" << EOSSH2
                echo "$idc_password" | sudo -S ssh mm@"$dest_ip" "echo \"$idc_password\" | sudo -S whoami > /dev/null && \
                    echo \"$idc_password\" | sudo -S $remote_dir/$starthmilog_script & \
                    echo \"$idc_password\" | sudo -S $remote_dir/$startmfflog_script &"
EOSSH2
EOSSH
EOF
fi

echo "Done."


#local shell

# sshpass -p 123@byd sudo -i
# cd /optdata/log/dimw/log/file/mlog/logs/
# tail -f mff_main_node.log.2023-* | grep -E "APA T|hmi node"

# sshpass -p 123@byd sudo -i
# cd /optdata/log/dimw/log/file/mlog/logs/
# tail -f mff_hmi_node.log.2023-* | grep -E "hmi output|hmi input|send ros to mff"

# scp fish@10.8.106.94:/media/data0/fish/mf_system_lianhuashan/mff/libhmi_core.tgz e:\
# scp E:\libhmi_core.tgz idc@192.168.30.42:/userdata/momenta/pp/modules/mff/lib/
