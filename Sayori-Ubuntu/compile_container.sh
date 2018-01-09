#!/bin/sh

# The reason we're doing the package install here is to keep everything in one layer for easier downloads
# It's relatively more convinient this way
apt update && \
apt -y install \
     build-essential \
     software-properties-common \
     python-software-properties \
     gcc \
     zlib1g-dev \
     sudo \
     wget \
     curl \
     apt-utils \
     apt-transport-https \
     git \
     tar \
     unzip \
     clang \
     cmake \
     openssh-server \
     gettext \

#install Python via APT repo instead
add-apt-repository ppa:jonathonf/python-3.6 && \
apt update && \
apt -y install python3.6

#Preinstall Sayori
cd /opt && \
git clone https://github.com/MonikaDesu/Sayori /opt/app && \
/bin/sh /opt/app/get_resources.sh && \
/usr/bin/python3.6 -m pip install -r requirements.txt && \
rm -rf /opt/app/README.md && \
rm -rf ./opt/app/gitignore && \
rm -rf /opt/app/.flake8 && \
rm -rf /opt/app/Procfile && \
rm -rf /opt/app/app.json && \
rm -rf /opt/app/API.md && \
rm -rf /opt/app/systemd && \
rm -rf /opt/app/get_resources.bat && \
rm -rf /opt/app/get_resources.sh

# Create user
mkdir /var/run/sshd && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
usermod -p "*" user 

# perm root awau
chmod g+rw /opt
chgrp root /opt

# allow to run on openshift
chown -R user:root /opt/app
chmod -R g+rw /opt/app
chmod -R g+rw /home/user
find /home/user -type d -exec chmod g+x {} +
