echo "deb http://debian.saltstack.com/debian wheezy-saltstack main" >> /etc/apt/sources.list.d/salt.list
wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
aptitude update
aptitude install -y salt-minion
#echo "master: your.ip.or.dns.here" > /etc/salt/minion
service salt-minion restart
