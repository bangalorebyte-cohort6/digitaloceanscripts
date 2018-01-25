################################################################################
#                                                                              #
# You will need the following information:                                     #
# ~ your email address (hereafter: <email_addr>)                               #
# ~ your server's internet protocol address (hereafter: 139.59.26.250)         #
# ~ your server's name (hereafter: <vps_name>)                                 #
#                                                                              #
# Be advised:                                                                  #
# ~ user1 must be a string that is not "root"                                  #
# ~ 1234 should be a string that is longer than eight characters               #
# ~ 1024 must be an integer that is between 1024 and 65535                     #
#                                                                              #
################################################################################

# ::|\ _______ /|::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| |       | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| | local | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| !_______! |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::!/         \!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #

#!/bin/bash

echo "$0 $1 $2 $3 $4"

export DROPLET_IP="$1"
export DROPLET_USERNAME="$2"
export DROPLET_PASSWORD="$3"
export DROPLET_PORT="$4"

echo $DROPLET_IP 
echo $DROPLET_USERNAME 
echo $DROPLET_PASSWORD 
echo $DROPLET_PORT

ssh-keygen -t rsa
if [-f .credentials]
then
	rm -f .credentials
fi

scp adduser.sh root@$DROPLET_IP:/root
scp install.sh root@$DROPLET_IP:/root
scp configure.sh root@$DROPLET_IP:/root
scp setupdroplet.sh root@$DROPLET_IP:/root

sh -c 'echo "$DROPLET_USERNAME:$DROPLET_PASSWORD" >> .credentials'

ssh root@$DROPLET_IP chmod a+x /root/*.sh
ssh root@$DROPLET_IP /root/adduser.sh $DROPLET_USERNAME

# Second local stuff

scp /Users/$USER/.ssh/id_rsa.pub root@$DROPLET_IP:/etc/ssh/$DROPLET_USERNAME/authorized_keys

scp .credentials root@$DROPLET_IP:/home/$DROPLET_USERNAME/

#passing username, password and the port
ssh root@$DROPLET_IP /root/setupdroplet.sh $DROPLET_IP $DROPLET_USERNAME $DROPLET_PASSWORD $DROPLET_PORT 
