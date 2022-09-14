#!/usr/bin/bash

# A simple script to update the system without human interaction.

if [[ $EUID -ne 0 ]]
then
	echo "This script needs to run as root."
	exit 1
fi

apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get autoremove

exit 
