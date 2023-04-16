#!/bin/bash

# navigate to the directory where the script and installed_packages.txt file are located
cd "$(dirname "$0")"


sudo apt-get update
sudo apt-get -y install dselect
# install all the packages listed in installed_packages.txt
sudo dpkg --clear-selections
sudo dpkg --set-selections < installed_packages.txt
sudo apt-get -y dselect-upgrade

# extract encrypted source file, check password
openssl aes-256-cbc -d -in tiba-video.tar.gz.enc | tar xzvf -
src_archive="./tiba-video.tar.gz"
dest_dir="/opt/tiba-video/"

temp_dir=$(mktemp -d)
sudo tar xzf "$src_archive" -C "$temp_dir" --strip-components=1

rsync -avz --delete --exclude='./node_modules' "$temp_dir/" "$dest_dir"

sudo chown -R tiba:tiba "$dest_dir"
sudo chmod -R 755 "$dest_dir"

rm -rf "$temp_dir"
