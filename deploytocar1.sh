# 将文件从本地计算机拷贝到目标服务器172.24.10.117
echo "Copying libhmi_core.so to 172.24.10.117..."
sshpass -p "mm" scp /media/data0/fish/mf_system_lianhuashan/mff/build/deploy/modules/mff/lib/libhmi_core.so mm@172.24.10.117:/home/mm/
echo "Copying libmff_main_node.so to 172.24.10.117..."
sshpass -p "mm" scp /media/data0/fish/mf_system_lianhuashan/mff/build/deploy/modules/mff/lib/libmff_main_node.so mm@172.24.10.117:/home/mm/

# 将文件从172.24.10.117拷贝到192.168.30.42
echo "Creating directory /userdata/momenta/fish/modules/mff/lib on 192.168.30.42..."
sshpass -p "123@byd" ssh idc@192.168.30.42 "mkdir -p /userdata/momenta/fish/modules/mff/lib && exit"
echo "Copying libhmi_core.so from 172.24.10.117 to 192.168.30.42..."
sshpass -p "mm" scp mm@172.24.10.117:/home/mm/libhmi_core.so idc@192.168.30.42:/userdata/momenta/fish/modules/mff/lib/
echo "Copying libmff_main_node.so from 172.24.10.117 to 192.168.30.42..."
sshpass -p "mm" scp mm@172.24.10.117:/home/mm/libmff_main_node.so idc@192.168.30.42:/userdata/momenta/fish/modules/mff/lib/

