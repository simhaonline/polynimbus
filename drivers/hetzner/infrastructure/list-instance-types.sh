#!/bin/sh

if [ "$1" = "" ]; then
	echo "usage: $0 <cloud-account>"
	exit 1
elif [ ! -f /etc/polynimbus/hetzner/$1.sh ]; then
	echo "error: cloud account \"$1\" not configured"
	exit 1
fi

account=$1
. /etc/polynimbus/hetzner/$account.sh

if [ "$2" = "--full" ]; then
	/opt/polynimbus/drivers/hetzner/support/hcloud server-type list
else
	/opt/polynimbus/drivers/hetzner/support/hcloud server-type list |awk '{ print $2 }' |grep -v ^NAME
fi
