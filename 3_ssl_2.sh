cd
FQDN=znode.gpumine.club 
echo "<FQDN> is $FQDN"
sudo cp /home/jord903/.acme.sh/$FQDN/ca.cer /usr/share/ca-certificates/ca.crt
sudo dpkg-reconfigure ca-certificates

zen-cli stop
sleep 10
cat <<EOF >> ~/.zen/zen.conf
tlscertpath=/home/jord903/.acme.sh/$FQDN/$FQDN.cer 
tlskeypath=/home/jord903/.acme.sh/$FQDN/$FQDN.key
EOF
zend
sleep 20
zen-cli getnetworkinfo
zen-cli z_getnewaddress