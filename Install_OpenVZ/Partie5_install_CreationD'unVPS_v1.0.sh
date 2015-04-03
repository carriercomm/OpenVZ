#!/bin/bash
#v1.0
# par Dylan Leborgne http://dylanleborgne.ovh
clear

echo -e "\033[31mPartie5 - Creation D'un VPS\033[0m";

echo -e "
\n\033[31mTelechargement d'un templates\n
Liste des templates disponible\n\033[0m";
vztmpl-dl --list-remote
echo -e "\n\033[31mEntrer le nom d'un template (ex: debian-7.0-x86_64-minimal):\033[0m"; read template;
vztmpl-dl $template


#-------------------------------------------------------------------------
# Déclaration des variables
#-------------------------------------------------------------------------

echo -e "\n\033[31mEntrer le numéro du conteneur (ex: '101',102')\033[0m:"; read CTID;
echo -e "\033[31mEntrer l'IP de conteneur (ex: '192.168.0.1') :\033[0m"; read ip_address;
echo -e "\033[31mEntrer le nom du conteneur :\033[0m"; read name;
echo -e "\033[31mEntrer le hostname du conteneur (FQDN) :\033[0m"; read FQDN;
echo -e "\033[31mListe des volumes disponibles:\033[0m";
lvdisplay
echo -e "\n\033[31mEntrer le nom du volume (LV Name) ou le conteneur sera stocker :\033[0m"; read Volume;

#-------------------------------------------------------------------------
# Création
#-------------------------------------------------------------------------

vzctl create $CTID --ostemplate $template --config basic --private=/var/lib/vz/private/$Volume/102


#-------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------

# Affectation d’une IP
vzctl set $CTID --ipadd $ip_address --save


# Affectation d’un nom plus facile à retenir que le CTID (MvWeb1 au lieu de « 101 »)!
vzctl set $CTID --name $name --save


# Affectation d’un nom d’host (FQDN)
vzctl set $CTID --hostname $FQDN --save


# Affectation d’un nom serveur DNS
vzctl set $CTID --nameserver 8.8.8.8 --save


# Démarrage  du container
vzctl start $CTID


# Démarage au boot du server OpenVZ
vzctl set $CTID --onboot yes —save

# Reload OWP
/etc/init.d/owp reload

echo -e "\n\n\033[31mVotre conteneur est cree:\033[0m";
# Affichage VPS actifes
vzlist

echo -e "\n\n\033[31mLa creation Du VPS est terminer, ainsi que l'installation de OpenVZ\033[0m \n"
read -p "Appuyer sur entrer pour continuer ..."