#! /bin/bash

IP_ADDRESS=$1
CREDENTIALS="/Users/barton/credentials/rac/barton"
ID="$CREDENTIALS/racbart.pem"

if [ -z "$IP_ADDRESS" ]; then
	echo -e "\n\nIP address required: $0 123.456.789.012\n\n"
	exit
fi

ssh -i $ID ubuntu@$IP_ADDRESS "echo $(ssh-keygen -y -f $ID ) | sudo tee -a /root/.ssh/authorized_keys"

