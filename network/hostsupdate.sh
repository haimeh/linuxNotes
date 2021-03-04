#!/bin/bash

FILE="/etc/hosts"
if [[ -f $FILE ]];then
    mv /etc/hosts_backup /etc/hosts
else
    cp /etc/hosts /etc/hosts_backup
fi

curl https://raw.githubusercontent.com/LukeSmithxyz/etc/master/ips >> /etc/hosts
curl https://ewpratten.retrylife.ca/youtube_ad_blocklist/hosts.ipv4.txt >> /etc/hosts
