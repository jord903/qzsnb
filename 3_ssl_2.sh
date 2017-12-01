cd
FQDN=znode.gpumine.club 
echo "<FQDN> is $FQDN"
sudo cp /home/jord903/.acme.sh/$FQDN/ca.cer /usr/share/ca-certificates/ca.crt
sudo dpkg-reconfigure ca-certificates

zen-cli stop
sudo cat <<EOF >> ~/.zen/zen.conf
tlscertpath=/home/jord903/.acme.sh/$FQDN/$FQDN.cer 
tlskeypath=/home/jord903/.acme.sh/$FQDN/$FQDN.key
EOF
zend
zen-cli getnetworkinfo
zen-cli z_getnewaddress