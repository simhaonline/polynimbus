#!/bin/bash

if [ "`which gcloud 2>/dev/null`" = "" ] && [ -f /root/google-cloud-sdk/path.bash.inc ]; then
	. /root/google-cloud-sdk/path.bash.inc
fi

if [ "$1" = "" ]; then
	echo "usage: $0 <cloud-account> [--full]"
	exit 1
elif [ ! -f /etc/polynimbus/google/$1.sh ]; then
	echo "error: cloud account \"$1\" not configured"
	exit 1
fi

account=$1

if grep -qxF $account /var/cache/polynimbus/google/api.blacklist; then
	exit 0
fi

. /etc/polynimbus/google/$account.sh

if [ "$2" = "--full" ]; then
	gcloud compute machine-types list --configuration $account --quiet |egrep "($GCE_REGION|DEPRECATED)"
else
	gcloud compute machine-types list --configuration $account --quiet |grep $GCE_REGION |awk '{ print $1 }'
fi
