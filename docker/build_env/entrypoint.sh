#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

# default pwd is user/user1234
echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" --groups 'sudo' --password '$6$t65Nd10.$ui44vjArXGOL18kFY6awSYyTtWd1rFqK.PhRECs.61DRXsiG0O29Rl1q6oU6FHnJTT9PWlacziuGBUZts37NV1' -m user
export HOME=/home/user

cp /etc/skel/.bash_logout /home/user
cp /etc/skel/.bashrc /home/user
cp /etc/skel/.profile /home/user
chown user:user /home/user
chown user:user /home/user/.bash_logout
chown user:user /home/user/.bashrc
chown user:user /home/user/.profile

exec /usr/local/bin/gosu user "$@"

