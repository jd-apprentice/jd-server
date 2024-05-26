#!/bin/bash
# Usage 'backup directory/*'
# 0 3 * * 1 backup $HOME/www/*
# alias backup='sh $HOME/scripts/backup.sh'

TOKEN=""
CHAT_ID=""
SERVER_NAME=""

if [ "$#" -eq 0 ]; then
    echo "🟩 Usage: $0 directory/*"
    exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "❌ Error: curl is not installed." >&2
    exit 1
fi

# https://unix.stackexchange.com/questions/24630/whats-the-best-way-to-join-files-again-after-splitting-them
date=$(date +%F)
tar -zcvf backup-"$date".tar.gz "$@"
split --bytes=49M backup-"$date"-"$SERVER_NAME".tar.gz

# https://gist.github.com/HirbodBehnam/d7a46fac29f5e1f664d467d5a05620dd
for file in x*; do
    echo "💾 Uploading $file"
    curl -X POST -H "content-type: application/json" -d "{\"server\": \"$SERVER_NAME\", \"Date: $date\n, \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"Date: $date\nFile: $file\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
    curl -X POST -H "content-type: multipart/form-data" -F document=@"$file" -F chat_id="$CHAT_ID" https://api.telegram.org/bot"$TOKEN"/sendDocument
done

rm backup-"$date".tar.gz x*
echo "🚀 Backup completed!"
