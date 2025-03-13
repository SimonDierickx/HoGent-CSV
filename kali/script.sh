#!/bin/bash

echo "Starting the installation and configuration of OpenSSH, please do not interrupt"
sudo apt-get update

echo "Installing necessary packages..."
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_7.6p1-4.dsc > /dev/null 2>&1
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_7.6p1.orig.tar.gz > /dev/null 2>&1
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_7.6p1.orig.tar.gz.asc > /dev/null 2>&1
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_7.6p1-4.debian.tar.xz > /dev/null 2>&1

echo "Unpacking downloaded packages..."
tar -zxvf openssh_7.6p1.orig.tar.gz > /dev/null 2>&1
tar -xvf openssh_7.6p1-4.debian.tar.xz > /dev/null 2>&1

echo "Downloading additional dependecies..."
sudo apt-get install -t xenial-backports devscripts autotools-dev debhelper dh-autoreconf dh-exec dh-systemd libaudit-dev libedit-dev libgtk-3-dev libkrb5-dev libpam-dev libselinux1-dev libssl-dev libwrap0-dev zlib1g-dev libsystemd-dev -y > /dev/null 2>&1
sudo apt-get install build-essential fakeroot dpkg-dev -y > /dev/null 2>&1

echo "Preparing environment..."
dpkg-source -x openssh_7.6p1-4.dsc > /dev/null 2>&1
cd openssh-7.6p1/ > /dev/null 2>&1
dpkg-buildpackage -rfakeroot -b > /dev/null 2>&1

cd .. > /dev/null 2>&1

ls -ltr *.deb > /dev/null 2>&1

echo "Stopping SSH and installing extra dependency..."
sudo systemctl stop ssh > /dev/null 2>&1
sudo dpkg -i --force-confold  openssh-client_7.6p1-4_amd64.deb openssh-server_7.6p1-4_amd64.deb openssh-sftp-server_7.6p1-4_amd64.deb > /dev/null 2>&1

echo "Verifying SSH version"
ssh -V > /dev/null 2>&1

echo "Start and enable SSH..."
sudo systemctl start ssh > /dev/null 2>&1
sudo systemctl enable ssh > /dev/null 2>&1