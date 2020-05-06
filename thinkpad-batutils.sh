#!/bin/bash

# THIS IS SPECIFIC FOR THINKPAD LAPTOPS.

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

apt update

apt -y install software-properties-common
# PPA for TLPUI
add-apt-repository ppa:linuxuprising/apps 

apt update

apt -y install tlp tlpui acpi-call-dkms tlp-rdw powertop

powertop calibrate

rm -f /etc/systemd/system/powertop.service
echo "[Unit]					" >> /etc/systemd/system/powertop.service
echo "Description=Powertop tunings		" >> /etc/systemd/system/powertop.service
echo "						" >> /etc/systemd/system/powertop.service 
echo "[Service]					" >> /etc/systemd/system/powertop.service
echo "Type=idle					" >> /etc/systemd/system/powertop.service
echo "ExecStart=/usr/sbin/powertop --auto-tune	" >> /etc/systemd/system/powertop.service
echo "						" >> /etc/systemd/system/powertop.service
echo "[Install]					" >> /etc/systemd/system/powertop.service
echo "WantedBy=multi-user.target		" >> /etc/systemd/system/powertop.service

systemctl enable --now powertop
systemctl enable --now tlp.service

