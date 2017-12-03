echo "Welcome to Use Quick ZenCash Secure Node Build!"
case $1 in
  "zen") 
cd
sudo apt-get update && sudo apt-get -y upgrade
sudo apt -y install pwgen
sudo apt-get install apt-transport-https lsb-release
echo 'deb https://zencashofficial.github.io/repo/ '$(lsb_release -cs)' main' | sudo tee --append /etc/apt/sources.list.d/zen.list
gpg --keyserver ha.pool.sks-keyservers.net --recv 219F55740BBF7A1CE368BA45FB7053CE4991B669
gpg --export 219F55740BBF7A1CE368BA45FB7053CE4991B669 | sudo apt-key add -
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo apt-get update
sudo apt-get -y install zen
zen-fetch-params
zend
USERNAME=$(pwgen -s 16 1)
PASSWORD=$(pwgen -s 64 1)
cat <<EOF > ~/.zen/zen.conf
rpcuser=$USERNAME
rpcpassword=$PASSWORD
rpcport=18231
rpcallowip=127.0.0.1
server=1
daemon=1
listen=1
txindex=1
logtimestamps=1
EOF
zend
        ;;
  "ssl")
cd
read -p "Domain Name: " domain
FQDN=$domain
echo "<FQDN> is $FQDN"
sudo apt install socat
git clone https://github.com/Neilpang/acme.sh.git
cd acme.sh
./acme.sh --install
sudo ~/.acme.sh/acme.sh --issue --standalone -d $FQDN 
echo "crontab -e"
echo "6 0 * * * "/home/jord903/.acme.sh"/acme.sh --cron --home "/home/jord903/.acme.sh" > /dev/null"
sudo cp /home/jord903/.acme.sh/$FQDN/ca.cer /usr/share/ca-certificates/ca.crt
		;;
  "sslinst")
cd
sudo dpkg-reconfigure ca-certificates
zen-cli stop
sleep 25
cat <<EOF >> ~/.zen/zen.conf
tlscertpath=/home/jord903/.acme.sh/$FQDN/$FQDN.cer 
tlskeypath=/home/jord903/.acme.sh/$FQDN/$FQDN.key
EOF
zend
sleep 30
zen-cli getnetworkinfo
zen-cli z_getnewaddress
        ;;
  "secnode")
sudo apt -y install npm
sudo npm install -g n
sudo n 9
mkdir ~/zencash
cd ~/zencash
git clone https://github.com/ZencashOfficial/secnodetracker.git
cd secnodetracker
npm install
        ;;
  "setup")
cd ~/zencash/secnodetracker
node setup
		;;
  "runboot")
cd ~/zencash/secnodetracker/
sudo npm install pm2 -g
pm2 start app.js --name secnode
pm2 startup
sudo env PATH=$PATH:/usr/local/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u jord903 --hp /home/jord903
sudo apt install monit
cd ~/qzsnb
sudo cp zen_node.sh ~/
sudo chmod u+x ~/zen_node.sh
echo '### added on setup for zend' | sudo tee -a /etc/monit/monitrc
echo 'set httpd port 2812' | sudo tee -a /etc/monit/monitrc
echo 'use address localhost # only accept connection from localhost' | sudo tee -a /etc/monit/monitrc
echo 'allow localhost # allow localhost to connect to the server' | sudo tee -a /etc/monit/monitrc
echo '### zend process control' | sudo tee -a /etc/monit/monitrc
echo 'check process zend with pidfile /home/jord903/.zen/zen_node.pid' | sudo tee -a /etc/monit/monitrc
echo 'start program = "/home/jord903/zen_node.sh start" with timeout 60 seconds' | sudo tee -a /etc/monit/monitrc
echo 'stop program = "/home/jord903/zen_node.sh stop"' | sudo tee -a /etc/monit/monitrc
sudo monit reload
sudo monit start zend
        ;;
  "secure")
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow http/tcp
sudo ufw allow https/tcp
sudo ufw allow 9033/tcp
sudo ufw allow 19033/tcp
sudo ufw logging on
sudo ufw enable
sudo apt -y install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo apt -y install rkhunter
cat <<EOF > ~/upgrade.sh
#!/bin/bash
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y autoremove
sudo rkhunter --propupd
EOF
chmod u+x ~/upgrade.sh
sudo ~/upgrade.sh
echo "#update system -> sudo ~/upgrade.sh"
        ;;
  *)
echo "Usage {zen|ssl|sslinst|secnode|setup|runboot|secure}"
echo "zen #Build ZenCash Wallet"
echo "ssl #Create SSL Cert"
echo "sslinst #Install SSL Cert on Zend"
echo "secnode #Install SecnodeTracker"
echo "setup #Setup SecnodeTracker"
echo "runboot #Zend and SecnodeTracker Running on Boot"
echo "secure #Enable Firewall and Fail2Ban ; Create Upgrade.sh"
        ;;
esac