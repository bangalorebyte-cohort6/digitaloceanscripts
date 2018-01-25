
export DROPLET_USERNAME=$1

sh -c 'echo "set const" >> .nanorc'

sh -c 'echo "set tabsize 8" >> .nanorc'

sh -c 'echo "set tabstospaces" >> .nanorc'

adduser --disabled-password --gecos "" $DROPLET_USERNAME

usermod -aG sudo $DROPLET_USERNAME

cp .nanorc /home/$DROPLET_USERNAME

mkdir /etc/ssh/$DROPLET_USERNAME

exit
