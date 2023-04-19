export DEPLOY_DIR=build/deploy
sshpass -p "1024" scp ${DEPLOY_DIR}.tar.gz fleet@10.13.112.101:/home/fleet/fish
sshpass -p "1024" ssh -o StrictHostKeyChecking=no fleet@10.13.112.101 
sshpass -p "Ww044628094811" scp fish@10.8.106.94:${DEPLOY_DIR}.tar.gz /home/fleet/fish
sshpass -p "123@byd" scp /home/fleet/fish/$(shell basename ${DEPLOY_DIR}) idc@192.168.30.42:/home/idc
sshpass -p "123@byd" ssh idc@192.168.30.42
tar xzvf $(shell basename ${DEPLOY_DIR}).tar.gz
bash /userdata/momenta/deploy/modules/startup_config/script/boot/stop_all.sh
cp -rf /home/idc/$(shell basename ${DEPLOY_DIR})/modules /userdata/momenta/deploy/
bash /userdata/momenta/deploy/modules/startup_config/script/boot/start_all.sh
