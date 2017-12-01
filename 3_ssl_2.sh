cd
FQDN=znode.gpumine.club
echo "<USER> is $USER" 
echo "<FQDN> is $FQDN"
sudo cp /home/$USER/.acme.sh/$FQDN/ca.cer /usr/share/ca-certificates/ca.crt
sudo dpkg-reconfigure ca-certificates

zen-cli stop
cat <<EOF >> ~/.zen/zen.conf
tlscertpath=/home/$USER/.acme.sh/$FQDN/$FQDN.cer 
tlskeypath=/home/$USER/.acme.sh/$FQDN/$FQDN.key
EOF
zend
zen-cli getnetworkinfo
zen-cli z_getnewaddress