#!/bin/bash

echo "Either use the absolute path or run it at user level within the space where you plan to create the folder"
echo "What folder are you going to run the server?: "
read server_folder

mkdir -p "$server_folder"

echo """

[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$server_folder
ExecStart=/usr/bin/java -Xmx4096M -Xms2048M -jar server.jar nogui
Restart=on-failure

[Install]
WantedBy=multi-user.target

""" > /etc/systemd/system/minecraft.service

systemctl daemon-reload
systemctl enable minecraft.service
systemctl start minecraft.service