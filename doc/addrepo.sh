# This script adds the mirrors of the official SaltStack debian repository to minions that run Wheezy
echo "deb http://mirror.selfnet.de/apt-mirror/debian.saltstack.com/debian wheezy-saltstack main" > /etc/apt/sources.list.d/salt.list
wget -q -O- "http://mirror.selfnet.de/apt-mirror/debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
apt-get update
