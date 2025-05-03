#!/bin/sh

# make sure this script is run by root only
# if [ "$(id -u)" != "0" ]; then
# 	fatal "This script must be run as root"
# 	exit 1
# fi

echo
echo "Generating a keypair to access your Kobo. You will be prompted for a passphrase"
echo
ssh-keygen -f id_kobo -t ECDSA -b 256 -C "MyKey@Kobo"

echo "Installing key in your SSH keyring"
echo
install -v -C --mode=u+rw id_kobo ~/.ssh/id_kobo
install -v -C --mode=u+rw id_kobo.pub ~/.ssh/id_kobo.pub

alias kssh='ssh -i ~/.ssh/id_kobo $1'

if [ -d "/media/$USER/KOBOeReader" ]; then
	echo
	echo "Device found. Uploading key to device..."
	mkdir -p /media/$USER/KOBOeReader/.adds/koreader/settings/SSH/authorized_keys
	install -v -C --mode=uga+rw id_kobo.pub /media/$USER/KOBOeReader/.adds/koreader/settings/SSH/authorized_keys/key.pub
	echo
else
	echo
	echo "Device not found, couldn't install key."
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_kobo
