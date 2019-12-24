#!/bin/bash

PROBE_FILE="/fb_host_probe.txt"
VARNISHADM="varnishadm -T varnish:6082 -S /varnish.secret"
REDIS_CLI="redis-cli -h clusterdata"


VARNISH_STATUS=$($VARNISHADM ping | awk '{print $1}')
if [[ ! $VARNISH_STATUS == "PONG" ]]; then
  echo "Unable to read VCLs from Varnish"
  exit 1
fi

VCL_NAME=$($VARNISHADM vcl.list | awk '{print $4}')
#$VARNISHADM vcl.show $VCL_NAME > /root/vcl.vcl
VCL=`$VARNISHADM vcl.show $VCL_NAME`
echo "$VCL" #use quotes
