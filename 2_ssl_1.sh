sudo apt install socat
cd 
git clone https://github.com/Neilpang/acme.sh.git
cd acme.sh
./acme.sh --install

FQDN=znode.gpumine.club
echo $FQDN
sudo ~/.acme.sh/acme.sh --issue --standalone -d $FQDN 

echo "sudo crontab -e"
echo "6 0 * * * "/home/jord903/.acme.sh"/acme.sh --cron --home "/home/jord903/.acme.sh" > /dev/null"

cd
