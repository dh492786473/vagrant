#!/bin/bash

START=3
TOTAL_NODES=2

while getopts s:t: option
do
	case "${option}"
	in
		s) START=${OPTARG};;
		t) TOTAL_NODES=${OPTARG};;
	esac
done

function disableFirewall {
	echo "check firewall"
	firewall-cmd --state
	systemctl stop firewalld.service
	systemctl disable firewalld.service 
}

function openPasswordAuthentication {
	echo "set PasswordAuthentication  yes"
	sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
	service sshd restart
}


function installsoftware {
	echo "installsoftware"
	yum -y install vim
	yum -y install sshpass
}


echo "setup centos"

disableFirewall
openPasswordAuthentication
#installsoftware