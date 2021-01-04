#!/bin/bash

mkdir ~/Researching 2> /dev/null

echo -e "Today is $(date) \n" >> ~/Researching/sys_info.txt
echo -e "This machine name has the following info $MACHTYPE \n" >> ~/Researching/sys_info.txt 
echo -e "The IP address for this session is $(ifconfig -a | sed -n '10p' | awk '{print $2}') \n" >> ~/Researching/sys_info.txt
echo -e "My hostname is $HOSTNAME \n" >> ~/Researching/sys_info.txt
echo "The current status of the computer resources are as follow:" >> ~/Researching/sys_info.txt
top | head -6  >> ~/Researching/sys_info.txt
echo -e "\n777 Files:" >> ~/Researching/sys_info.txt
echo -e "\nTop 10 Processes" >> ~/Researching/sys_info.txt
ps aux -m | awk {'print $1, $2, $3, $4, $11'} | head >> ~/Researching/sys_info.txt
