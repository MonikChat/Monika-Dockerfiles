#!/bin/sh

# The reason we're doing the package install here is to keep everything in one layer for easier downloads
# It's relatively more convinient this way
dnf install -y \
    curl \
    wget \
    gcc \
    ffmpeg \
    clang \
    git \
    tar \
    which \
    make \
    cmake \
    openssl-devel \
    sudo \
    nss_wrapper \
    gettext \
    nodejs

# npm install yo?
npm i -g pm2

# manually install Python 3.6
cd /usr/src && \
   wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz && \
   tar xzf Python-3.6.3.tgz && \
   cd Python-3.6.3 && \
   ./configure --enable-optimizations && \
   make altinstall && \
   rm -rf /usr/src/Python-3.6.3.tgz && \
/usr/bin/python3 -V

# Create user
adduser user -u 1000 -g 0 -r -m -d /home/user/ -c "Default Application User" -l
echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user
chmod 0440 /etc/sudoers.d/user

#clone repo, expose Clara as app, then trim contents
git clone https://github.com/MonikaDesu/monika --bare --depth=10 /opt/monika && \
mkdir /opt/app && \
rm -rf /opt/Clara

# perm root awau
chmod g+rw /opt
chgrp root /opt

# allow to run on openshift
chown -R user:root /opt/app
chmod -R g+rw /opt/app
chmod -R g+rw /home/user
find /home/user -type d -exec chmod g+x {} +

# Clean up
dnf clean all