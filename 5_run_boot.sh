cd ~/zencash/secnodetracker/
sudo npm install pm2 -g
pm2 start app.js --name secnode

pm2 startup

sudo apt install monit
cd ~/qzsnb
sudo cp zen_node.sh ~/
chmod u+x ~/zen_node.sh
cd
echo "sudo vi /etc/monit/monitrc"
echo "### added on setup for zend"
echo "set httpd port 2812"
echo "use address localhost # only accept connection from localhost"
echo "allow localhost # allow localhost to connect to the server"
echo "### zend process control"
echo "check process zend with pidfile /home/<USER>/.zen/zen_node.pid"
echo "start program = "/home/jord903/zen_node.sh start" with timeout 60 seconds"
echo "stop program = "/home/jord903/zen_node.sh stop""

echo "sudo monit reload"
echo "sudo monit start zend"