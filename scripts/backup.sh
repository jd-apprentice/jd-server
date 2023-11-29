#!/bin/bash
# Usage 'backup directory/*'

TOKEN=""
CHAT_ID=""

if [ "$#" -eq 0 ]; then
    echo "🟩 Usage: $0 directory/*"
    exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "❌ Error: curl is not installed." >&2
    exit 1
fi

date=$(date +%F)
tar -zcvf backup-"$date".tar.gz $@
split --bytes=49M backup-"$date".tar.gz

for file in x*; do
    echo "💾 Uploading $file"
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"Date: $date\nFile: $file\", \"disable_notification\": true}" https://api.telegram.org/bot$TOKEN/sendMessage
    curl -X POST -H "content-type: multipart/form-data" -F document=@"$file" -F chat_id=$CHAT_ID https://api.telegram.org/bot$TOKEN/sendDocument
done

rm backup-"$date".tar.gz x*
echo "🚀 Backup completed!"