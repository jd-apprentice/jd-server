#!/bin/bash

date=$(date +"%b %d %H:%M")
server=${1:-192.168.0.242}
port=${2:-8588}
token=$3
title=$4
message=$5
priority=$6

server_url="http://$server:$port/message?token=$token"

echo "Date: $date"
echo "Server URL: $server_url"
echo "Port: $port"
echo "Title: $title"
echo "Message: $message"
echo "Priority: $priority"
echo "Sending notification to Gotify server"

curl "$server_url" -F "title=$title" -F "message=$message" -F "priority=$priority"