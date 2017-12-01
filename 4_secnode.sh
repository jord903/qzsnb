cd
sudo apt -y install npm
sudo npm install -g n
sudo n 9

mkdir ~/zencash
cd ~/zencash
git clone https://github.com/ZencashOfficial/secnodetracker.git
cd secnodetracker
npm install

echo "node setup"