#!/bin/sh

#function probe(ipaddr)
probe () {
	ping -c1 -w5 $1 >&- 2>&- && touch /tmp/pingfail.$1
}

#args: ipaddr fragment (24bit), from, to (last 8 bit)
if [ $# -ne  3 ]; then
	echo "Usage: ./pingrange.sh <ipaddr24> <startip8> <endip8>"
	echo "  Example: ./pingrange.sh 192.168.0 1 254"
	exit 1
else
	rm /tmp/pingfail.* 2>&-
	for i in $(seq $2 $3); do
	  probe $1.$i &
	done;
	wait
	for failip in /tmp/pingfail.*; do
	  echo ${failip#*.}
	done|sort -nt. -k1,1 -k2,2 -k3,3 -k4,4
	rm /tmp/pingfail.* 2>&-
	exit 0
fi

