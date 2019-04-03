#!/bin/bash

chown $1 /home/$1
chgrp $1 /home/$1
usermod -a -G bosh_sshers $1
mkdir -p /home/$1/.ssh
chmod 700 /home/$1/.ssh
chown $1 /home/$1/.ssh
chgrp $1 /home/$1/.ssh
cp user.pub /home/$1/.ssh/
chown $1 /home/$1/.ssh/user.pub
chgrp $1 /home/$1/.ssh/user.pub
cp user.pub /home/$1/.ssh/authorized_keys
chmod 600 /home/$1/.ssh/authorized_keys
chown $1 /home/$1/.ssh/authorized_keys
chgrp $1 /home/$1/.ssh/authorized_keys
