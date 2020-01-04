#!/bin/sh

dpkg -i offline-packages/anydesk_5.5.1-1_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/google-chrome-stable_current_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/teamviewer_15.1.3937_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/opera-stable_65.0.3467.69_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/LibreOffice_6.3.4.2_Linux_x86-64_deb/DEBS/*.deb
apt-get install -y -f
dpkg -i offline-packages/dbeaver-ce_6.3.1_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/vivaldi-stable_2.10.1745.23-1_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/Pencil_3.0.4_amd64.deb
apt-get install -y -f
dpkg -i offline-packages/duplicati_2.0.4.23-1_all.deb
apt-get install -y -f

cd offline-packages
./edrawinfo-64.run
cd --
