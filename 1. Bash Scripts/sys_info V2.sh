#!/bin/bash

DestPath=$HOME/Researching/sys_info.txt

if [ ! -d $HOME/Researching ]
then
mkdir $HOME/Researching
fi

if [ -f $DestPath ]
then
rm $DestPath
fi

echo -e "Today is $(date) \n" >> $DestPath
echo -e "This machine name has the following info $MACHTYPE \n" >> $DestPath 
echo -e "The IP address for this session is $(ifconfig -a | sed -n '10p' | awk '{print $2}') \n" >> $DestPath
echo -e "My hostname is $HOSTNAME \n" >> $DestPath
echo "The current status of the computer resources are as follow:" >> $DestPath
top | head -6  >> $DestPath
echo -e "\n777 Files:" >> $DestPath
echo -e "\nTop 10 Processes" >> $DestPath
ps aux -m | awk {'print $1, $2, $3, $4, $11'} | head >> $DestPath

