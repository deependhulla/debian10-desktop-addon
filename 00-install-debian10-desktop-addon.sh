#!/bin/sh

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



## backup existing repo by copy to root
/bin/cp -pR /etc/apt/sources.list /usr/local/old-sources.list-`date +%s`
echo "" >  /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian buster-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update

apt-get -y upgrade
apt-get -y install openssh-server vim iptraf screen mc net-tools sshfs telnet iputils-ping git psmisc apt-transport-https 
apt-get -y install sudo curl elinks xfsprogs debconf-utils pwgen ca-certificates gnupg2 wget unzip zip dia-rib-network 
apt-get -y install xfce4 xfce4-terminal galculator mousepad firefox-esr evince nautilus xscreensaver filezilla
apt-get -y install fonts-noto-hinted fonts-noto-unhinted fonts-roboto numix-gtk-theme numix-icon-theme
apt-get -y install gimp wodim system-config-printer cups cups-client bridge-utils materia-gtk-theme mate-backgrounds gnome-backgrounds
apt-get -y install gnome-tweak-tool plank albatross-gtk-theme blackbird-gtk-theme bluebird-gtk-theme libgconf-2-4
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
apt-get install remmina  remmina-plugin-nx  remmina-plugin-rdp  remmina-plugin-secret  remmina-plugin-spice  remmina-plugin-vnc 

## email client [look like mac email] instead of thunderbird
apt-get install geary

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






