#!/bin/sh

# The reason we're doing the package install here is to keep everything in one layer for easier downloads
# It's relatively more convinient this way
apk update && \
apk upgrade && \
apk add  \
    build-base \
    bash \
    ffmpeg \
    git \
    sudo \
    python3 \
    openssh-server \
    gettext
    
# npm install yo?
npm i -g pm2 npm@4 

# Create user
echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user
chmod 0440 /etc/sudoers.d/user

#clone repo, expose Clara as app, then trim contents
chmod a+x /opt && \
cd /opt && \
git clone https://github.com/MonikaDesu/monika && \
mkdir /opt/app && \
mv /opt/monika/src/Clara/* /opt/app && \
mv /opt/monika/package.json /opt/app && \
rm -rf /opt/monika && \
cd /opt/app && \
npm i --save --no-prune;

# perm root awau
chmod g+rw /opt
chgrp root /opt

# allow to run on openshift
mkdir /.pm2 && \
mkdir /.npm && \
chown -R node:root /.npm
chown -R node:root /.pm2
chown -R node:root /opt/app
chown -R node:root /opt/app/*
chmod -R g+rw /.npm
chmod -R g+rw /.pm2
chmod -R g+rw /opt/app
chmod -R g+rw /home/node
find /home/node -type d -exec chmod g+x {} +
