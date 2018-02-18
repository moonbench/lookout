#!/bin/bash

HOSTNAME="watchtower1"

declare ROOT_DIR="$(dirname $(readlink -f $0))"

echo "Setting up the watchtower..."

echo "Setting up the home directory for the watchtower's shared files..."
mkdir /var/watchtower
mkdir /var/watchtower/cameras
mkdir /var/log/watchtower
echo -e "Done.\\n"

echo "Setting up the users for the system..."
userdel -f pi
useradd -m camera
useradd -m reader
echo -e "Done.\\n"

echo "Setting up networking..."

echo "Setting hostname..."
echo "${HOSTNAME}" > /etc/hostname
hostname "${HOSTNAME}"
echo "Done."

echo "Enabling ssh..."
systemctl enable ssh
systemctl start ssh
echo "Adding ssh group..."
groupadd -r sshusers
usermod -a -G sshusers reader
echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart
echo "Done."
echo "Done."


echo -e "Done.\\n"

