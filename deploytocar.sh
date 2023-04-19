#!/bin/bash

# local file path
LOCAL_PATH=/media/data0/fish/mf_system_lianhuashan/mff/build/repo/lhs_orin/deploy/modules/mff/lib/

# remote IP and username/password
REMOTE_IP=172.24.10.117
REMOTE_USER=mm
REMOTE_PASS=mm

# remote file path
REMOTE_PATH=/userdata/momenta/fish/modules/mff/lib/
REMOTE_PATH=/userdata/momenta/fish/modules/mff/lib/

# final destination IP and username/password
DEST_IP=192.168.30.42
DEST_USER=idc
DEST_PASS=123@byd

# copy files to remote machine
expect << EOF >/dev/null 2>&1
spawn ssh $REMOTE_USER@$REMOTE_IP "sudo mkdir -p $REMOTE_PATH && scp $LOCAL_PATH/libhmi_core.so $LOCAL_PATH/libmff_main_node.so $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH" 
expect {
  "*password*" {
    send "$REMOTE_PASS\r"
    exp_continue
  }
  eof
}
EOF

if [ $? -eq 0 ]; then
  echo "Successfully copied files to remote machine"
else
  echo "Error copying files to remote machine"
  exit 1
fi

# copy files to final destination
expect << EOF >/dev/null 2>&1
spawn ssh $DEST_USER@$DEST_IP "mkdir -p $REMOTE_PATH && scp $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH/libhmi_core.so $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH/libmff_main_node.so $REMOTE_PATH" 
expect {
  "*password*" {
    send "$DEST_PASS\r"
    exp_continue
  }
  eof
}
EOF

if [ $? -eq 0 ]; then
  echo "Successfully copied files to final destination"
else
  echo "Error copying files to final destination"
  exit 1
fi

