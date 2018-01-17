#!/bin/sh
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /tmp/passwd_template > /tmp/passwd

python3.6 '/opt/Sayori/main.py'
