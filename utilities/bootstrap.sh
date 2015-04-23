#! /bin/bash

#------------------------------------------------------------------------------
# boot a virtual machine, attach an IPv4 address, and bootstrap Chef.
# calling with 'push' as the 3rd parameter will push your ssh public key into
# the authorised_keys list of the root user.
#------------------------------------------------------------------------------


# These variables should be changed for your configuration
#------------------------------------------------------------------------------
# source "/my/cloud/credentials"
# export KNIFE_HOME="/path/to/my/knife.rb/directory"
# ID="/path/to/my/openstack/ssh-key.pem"
# KEY="<ssh keypair name?"
# IMAGE="<machine image name or id>"
# GIT_REPOSITORY="https://github.com/my/repo.git"
#------------------------------------------------------------------------------

SSH_PARAMS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
HOSTNAME=$1
IP=$2
TEST=""

if [[ -z "$HOSTNAME" || -z $IP ]]; then
	echo "$0 <hostname> <ip address> [push-public|push-private] "
	exit
fi

echo "booting..."
nova boot --image "$IMAGE" --flavor m1.medium --key-name $KEY $HOSTNAME
sleep 5
echo "attaching IP address..."
nova add-floating-ip $HOSTNAME $IP

# check to see if networking has come up in the VM yet
while [[ "$TEST" != "$HOSTNAME" ]]; do
	TEST=$(ssh $SSH_PARAMS -i $ID ubuntu@$IP "hostname")
	echo -e "Zzzz.."
	sleep 1
done

echo "bootstrapping Chef"
knife bootstrap -i $ID -x ubuntu --sudo $IP
ssh $SSH_PARAMS -i $ID ubuntu@$IP "sudo apt-get update"
ssh $SSH_PARAMS -i $ID ubuntu@$IP "sudo apt-get install -y git tree stow"
ssh $SSH_PARAMS -i $ID ubuntu@$IP "git clone $GIT_REPOSITORY"

# push your public ssh key into the authorized_keys of the root user.
# this allows the root user to rsync and scp files between servers
if [[ "$3" == "push-public" ]]; then
	echo pushing public key...
	ssh $SSH_PARAMS -i $ID ubuntu@$IP "echo $(ssh-keygen -y -f $ID ) | sudo tee /root/.ssh/authorized_keys"
fi

if [[ "$3" == "push-private" ]]; then
	echo pushing private key...
	scp $SSH_PARAMS -i $ID $ID ubuntu@$IP:/home/ubuntu/id_rsa
	ssh $SSH_PARAMS -i $ID ubuntu@$IP "sudo cp /home/ubuntu/id_rsa /root/.ssh/id_rsa"
	ssh $SSH_PARAMS -i $ID ubuntu@$IP "sudo chmod 600 /root/.ssh/id_rsa"
	ssh $SSH_PARAMS -i $ID ubuntu@$IP "sudo rm /home/ubuntu/id_rsa"
fi
