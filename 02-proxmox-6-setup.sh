#!/bin/bash

## sample
###HOSTNAME=pvedesktop.domainname.com
###IPADDR=192.168.1.1

###HOSTNAME=pvedesktop.domainname.com
###IPADDR=192.168.1.1

##incase not disable ipv6 as most time not required
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1


hostname $HOSTNAME
echo "$IPADDR   $HOSTNAME" >> /etc/hosts
echo $HOSTNAME > /etc/hostname

#Disable vim automatic visual mode using mouse
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc


apt-get update
CFG_HOSTNAME_FQDN=`hostname`
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections

#### remove exim by installing postfix before upgrade used for proxmox
apt-get -y install postfix 
apt-get -y upgrade
/bin/rm -rf /etc/apt/sources.list.d/pve-enterprise.list

echo "deb [arch=amd64] http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg 
apt update && apt -y full-upgrade

apt -y install proxmox-ve open-iscsi 
apt remove os-prober
apt -y install ifupdown2
## incase only proxmox is installed without first package on a VM
apt -y install openssh-server vim iptraf screen mc net-tools sshfs telnet iputils-ping git psmisc apt-transport-https
apt -y install  curl elinks xfsprogs debconf-utils pwgen ca-certificates gnupg2 wget unzip zip

/bin/rm -rf /etc/apt/sources.list.d/pve-enterprise.list


## remove old kernel after reboot to proxmox kernel and update grub
## apt remove linux-image-amd64 'linux-image-4.19*'
## update-grub



