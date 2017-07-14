#!/usr/bin/env bash

#Checks every node enrolled in chef for DNS
#Requires a valid knife setup

ping-getip() {
   VAL=$(ping -c 1 "$*" | grep 'ping: cannot resolve' | awk '{print $4}')
   
   if [[ $VAL == ping:* ]]; then
       echo $VAL
   fi
}

declare -a servers

servers=($(knife node list))

for i in "${servers[@]}"; do
    ping-getip $i
done