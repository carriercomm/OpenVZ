#!/bin/bash
#v1.0
# par Dylan Leborgne http://dylanleborgne.ovh
clear

echo -e "\033[31mPartie 4 - Installation de OpenVZ Web Panel (OWP)\033[0m \n\n";

apt-get install ruby1.8

ln -fs /usr/bin/ruby1.8 /etc/alternatives/ruby

wget -O - http://ovz-web-panel.googlecode.com/svn/installer/ai.sh | sh

/etc/init.d/owp reload

apt-get install ruby1.8

ln -fs /usr/bin/ruby1.8 /etc/alternatives/ruby

wget -O - http://ovz-web-panel.googlecode.com/svn/installer/ai.sh | sh

/etc/init.d/owp reload

iptables=$(sed "49i\ \n## On autoriser la connexion à OpenVZ Web Panel (OWP) \niptables -A INPUT --protocol tcp --destination-port 3000 -j ACCEPT " /etc/init.d/iptables)

rm -rf /etc/init.d/iptables

echo "$iptables" >> /etc/init.d/iptables

chmod +x /etc/init.d/iptables /etc/init.d/iptables
update-rc.d iptables defaults

/etc/init.d/iptables reload

echo -e "
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# m   h  dom mon dow   command
  */5 *   *   *   *    /etc/init.d/owp reload" >> /var/spool/cron/crontabs/root
  
ip=`ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'` 
  
echo -e "\n\n\033[31mVotre interface OWP est accessible depuis votre navigateur à:
http://$ip:3000
login: admin
Mot de Passe : admin"

echo -e "\n\nL'installation de OpenVZ Web Panel est terminer, vous pourrez lancé la partie 5\033[0m \n"
read -p "Appuyer sur entrer pour continuer ..."