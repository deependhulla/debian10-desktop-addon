#!/bin/sh
## sample
###HOSTNAME=pvedesktop.domainname.com
###IPADDR=192.168.1.1

HOSTNAME=mydesktop.domainname.com
IPADDR=127.0.0.1

hostname $HOSTNAME
echo "$IPADDR   $HOSTNAME" >> /etc/hosts
echo $HOSTNAME > /etc/hostname


##disable ipv6 as most time not required
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

#build rc.local as it not there by default in debian 9.x and 10.x
/bin/cp -pR /etc/rc.local /usr/local/old-rc.local-`date +%s` 2>/dev/null
touch /etc/rc.local 
printf '%s\n' '#!/bin/bash'  | tee -a /etc/rc.local
echo "sysctl -w net.ipv6.conf.all.disable_ipv6=1" >>/etc/rc.local
echo "sysctl -w net.ipv6.conf.default.disable_ipv6=1" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod 755 /etc/rc.local
## need like autoexe bat on startup
echo "[Unit]" > /etc/systemd/system/rc-local.service
echo " Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
echo " ConditionPathExists=/etc/rc.local" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Service]" >> /etc/systemd/system/rc-local.service
echo " Type=forking" >> /etc/systemd/system/rc-local.service
echo " ExecStart=/etc/rc.local start" >> /etc/systemd/system/rc-local.service
echo " TimeoutSec=0" >> /etc/systemd/system/rc-local.service
echo " StandardOutput=tty" >> /etc/systemd/system/rc-local.service
echo " RemainAfterExit=yes" >> /etc/systemd/system/rc-local.service
echo " SysVStartPriority=99" >> /etc/systemd/system/rc-local.service
echo "" >> /etc/systemd/system/rc-local.service
echo "[Install]" >> /etc/systemd/system/rc-local.service
echo " WantedBy=multi-user.target" >> /etc/systemd/system/rc-local.service

systemctl enable rc-local
systemctl start rc-local

## ssh Keep Alive
mkdir /root/.ssh 
echo "Host * " > /root/.ssh/config
echo "    ServerAliveInterval 300" >> /root/.ssh/config
echo "    ServerAliveCountMax 20" >> /root/.ssh/config

mkdir /home/mailadmin/.ssh 
echo "Host * " > /home/mailadmin/.ssh/config
echo "    ServerAliveInterval 300" >> /home/mailadmin/.ssh/config
echo "    ServerAliveCountMax 20" >> /home/mailadmin/.ssh/config
chown -R mailadmin:mailadmin /home/mailadmin/.ssh


## backup existing repo by copy
/bin/cp -pR /etc/apt/sources.list /usr/local/old-sources.list-`date +%s`
echo "" >  /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update

CFG_HOSTNAME_FQDN=`hostname`
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections

#### remove exim by installing postfix before upgrade used for proxmox
apt-get -y install postfix 

apt-get -y upgrade
apt-get -y install openssh-server vim iptraf screen mc net-tools sshfs telnet iputils-ping git psmisc apt-transport-https 
apt-get -y install sudo curl elinks xfsprogs debconf-utils pwgen ca-certificates gnupg2 wget unzip zip dia-rib-network 
apt-get -y install xfce4 xfce4-terminal galculator mousepad firefox-esr evince nautilus xscreensaver filezilla ethtool
apt-get -y install fonts-noto-hinted fonts-noto-unhinted fonts-roboto numix-gtk-theme numix-icon-theme software-properties-common
apt-get -y install gimp wodim system-config-printer cups cups-client bridge-utils materia-gtk-theme mate-backgrounds gnome-backgrounds
apt-get -y install gnome-tweak-tool plank albatross-gtk-theme blackbird-gtk-theme bluebird-gtk-theme libgconf-2-4 ntfs-3g
apt-get -y install xarchiver p7zip-rar arj binutils lhasa liblz4-tool lrzip lzip ncompress rar unar zstd unrar
apt-get -y install gtk-chtheme gtk-theme-switch thunar-archive-plugin xfce4-places-plugin xfce4-goodies 
apt-get -y install firmware-linux firmware-realtek firmware-linux-nonfree
apt-get -y install firmware-intel-sound intel-microcode
apt-get -y install firmware-misc-nonfree xserver-xorg-video-intel

## addon for anydesk
apt-get -y install libgtkglext1 libpango1.0-0 libpangox-1.0-0
## addon for google chrome
apt-get -y install libappindicator3-1  fonts-liberation libdbusmenu-glib4  libdbusmenu-gtk3-4

## extra deepin packages
apt-get -y install deepin-calculator  deepin-gettext-tools deepin-icon-theme deepin-image-viewer deepin-menu  deepin-movie deepin-music deepin-notifications
apt-get -y install deepin-picker deepin-screen-recorder deepin-screenshot deepin-shortcut-viewer deepin-terminal deepin-voice-recorder deepin-deb-installer
apt-get -y install libdtkcore-bin
## for development
apt-get -y install build-essential qt5-qmake

## mate screensaver instead of xscreensaver with lock
apt-get -y install mate-screensaver
apt-get -y remove light-locker
apt-get -y remove xscreensaver

## remote desktop client and its plugins
apt-get -y install remmina  remmina-plugin-nx  remmina-plugin-rdp  remmina-plugin-secret  remmina-plugin-spice  remmina-plugin-vnc 

## email client [look like mac email] instead of thunderbird
apt-get -y install geary

#Disable vim automatic visual mode using mouse
echo "\"set mouse=a/g" >  ~/.vimrc
echo "syntax on" >> ~/.vimrc

echo "\"set mouse=a/g" >  /home/mailadmin/.vimrc 2>/dev/null
echo "syntax on" >> /home/mailadmin/.vimrc 2>/dev/null

##  To have features like CentOS for Bash
echo "" >> /etc/bash.bashrc
echo "alias cp='cp -i'" >> /etc/bash.bashrc
echo "alias l.='ls -d .* --color=auto'" >> /etc/bash.bashrc
echo "alias ll='ls -l --color=auto'" >> /etc/bash.bashrc
echo "alias ls='ls --color=auto'" >> /etc/bash.bashrc
echo "alias mv='mv -i'" >> /etc/bash.bashrc
echo "alias rm='rm -i'" >> /etc/bash.bashrc



## if WIFI
## apt-get install firmware-iwlwifi wicd
## if DB 
## apt-get -y install mariadb-server automysqlbackup freetds-bin



