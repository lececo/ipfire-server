# #########################################################################
#
#			@date: 26.08.2019
# 			@author: Pavlo Rozbytskyi
#			@description: skript makes mounted partition to LUKS format
#			@param $1 = partition: will be converted to LUKS
#			@param $2 = keyfile: with this keyfile the partition will be 
# 			encrypted
#
# #########################################################################

#! /bin/bash

partition="$1"
keyfile="$2"

printf "creating luks partition %s with %s\n" "$partition" "$keyfile" >> /var/log/luks.log

# check device mounted
mounted=$(mount -i | grep "$partition" | wc -l)
if [ "$mounted" -ne 0 ]; then 
	var=$(mount -l | grep "$partition" | awk -F " " '{ print $3 }')
	printf "device mounted on %s\n" "$var"
	umount "$var"	
fi

cryptsetup -y -v --key-file="$keyfile" luksFormat "$partition"

if [ $? != 0 ]; then
	printf "setup luks partition failed\n" >> /var/log/luks.log
	exit 1
fi
printf "setup luks partition succeeded\n" >> /var/log/luks.log
exit 0

 
