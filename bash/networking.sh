#!/usr/bin/env sh

# Text color
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"

# Background Color
BACK_RED="\e[41m"
BACK_GREEN="\e[42m"
BACK_BLUE="\e[44m"
BACK_YELLOW="\e[43m"

#set defaults
DEFAULT="\e[0m"

echo "${RED}${BACK_YELLOW}IP Address Information${DEFAULT}\n"

for each in `/sbin/ip -o link show | cut -d' ' -f2 | cut -d':' -f1 | grep -v lo`
do
	case $each in
		# Known ethernet interfaces should be green
		eth* | eno*)
			COLOR=${GREEN}
			;;
		# Known wirelesss interfaces should be blue
		wlan* | wlp2s*)
			COLOR=${BLUE}
			;;
		# All other interfaces should be yellow
		*)
			COLOR=${YELLOW}
			;;
	esac
	echo "${COLOR}$each IPv4 has the following addresses:${DEFAULT}"
	for address in `/sbin/ip addr show $each | grep "inet\b" | awk {'print $2'} | cut -d'/' -f1`
	do
		echo "${RED}\t$address${DEFAULT}"
	done
	echo "${COLOR}$each IPv6 has the following addresses:${DEFAULT}"
	for address in `/sbin/ip addr show $each | grep -v temporary | grep inet6 | grep -v link | awk {'print $2'} | cut -d'/' -f1`
	do
		echo "${RED}\t$address${DEFAULT}"
	done
	echo ""
done

echo "${RED}${BACK_YELLOW}Routing Information${DEFAULT}\n"
netstat -rn | tail +3 | awk '
   BEGIN{printf("\033[31m%-16s\033[32m%-16s\033[33m%-16s\033[34m%-8s\033[35m%-4s\033[36m%-8s\033[37m%-5s\033[90m%-6s\n","Destination","Gateway","Genmask","Flags","MSS","Window","irtt","Iface")}
   {printf("\033[31m%-16s\033[32m%-16s\033[33m%-16s\033[34m%-8s\033[35m%3s \033[36m%-8s\033[37m%-5s\033[90m%-6s\n",$1,$2,$3,$4,$5,$6,$7,$8)}'

echo "$DEFAULT"

# echo "${RED}${BACK_YELLOW}IP addresses on LAN$DEFAULT"
# cat /proc/net/arp | tail +2 | awk 'BEGIN {print "\033[31mIP address\t\t\033[32mHW address\t\t\033[33mDevice"} {print "\033[31m"$1"\t\t\033[32m"$4"\t\033[33m"$6}'

exit 0
