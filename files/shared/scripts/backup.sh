#!/bin/bash
# Usage 'backup directory/*'
# 0 3 * * 1 backup $HOME/www/*
# alias backup='sh $HOME/scripts/backup.sh'

TOKEN=""
CHAT_ID=""
SERVER_NAME="ingress"

date=$(date +%F)
sudo tar --exclude='.env' -zcvf backup-"$date"-"$SERVER_NAME".tar.gz $@
split --bytes=49M backup-"$date"-"$SERVER_NAME".tar.gz part-

for file in part-*; do
    mv "$file" "${file}-${SERVER_NAME}"
done

for file in part-*-"$SERVER_NAME"; do
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"Date: $date\nFile: $file\nServer: $SERVER_NAME\", \"disable_notification\": true}" https://api.telegram.org/bot$TOKEN/sendMessage
    curl -X POST -H "content-type: multipart/form-data" -F document=@"$file" -F chat_id=$CHAT_ID https://api.telegram.org/bot$TOKEN/sendDocument
done

notify 192.168.88.251 8588 token title "[ingress] Created a backup for folder /www" 1