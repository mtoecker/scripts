#!/bin/bash
# ------------------------------------------------------------------
# [mtoecker]  sign-vmware.sh
#          Description
#
#          This script is used to automatically sign vmware services
#          vmnet and vmmon using the private keyfile provided in arg(1)
#          and the public key in arg(2), and it prompts for a passphrase
#	
#	Some code cribbed from https://github.com/Majal/maj-scripts/blob/master/vboxsign
#
# ------------------------------------------------------------------
VERSION="0.1.0"
SUBJECT="sign-vmware.sh"

USAGE="Usage: sign-vmware {private-key} {public-key}"

# --- Option processing --------------------------------------------
if [ "$#" -eq 0 ]; then
  echo "$USAGE"
  exit 1
fi

privkey=$1
pubkey=$2



# -- Body ---------------------------------------------------------
#  Main 
echo "Using private key	: $privkey"
echo "Using public key	: $pubkey"

# Setting env KBUILD_SIGN_PIN for encrypted keys
printf "Please enter key passphrase (leave blank if not needed): "; read -s
export KBUILD_SIGN_PIN="$REPLY"

# Decrypt private key. 
openssl rsa -in $privkey -out $privkey.kill -passin env:KBUILD_SIGN_PIN


echo "Signing vmnet..."
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 $privkey.kill $pubkey $(modinfo -n vmnet)

echo "Signing vmmon"
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 $privkey.kill $pubkey $(modinfo -n vmmon)

# -----------------------------------------------------------------

# (Optional) Shred private key
echo "Shredding the private key $privkey.kill"
shred -fuz $privkey.kill


# start the vmware services
echo "Restarting vmmon"
modprobe vmmon
echo "Restarting vmnet"
modprobe vmnet
