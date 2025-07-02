#!/bin/bash
sudo apt update -y
sudo apt install -y python3 python3-pip
echo "App tier is up and running!" | tee /home/ubuntu/app_status.txt
