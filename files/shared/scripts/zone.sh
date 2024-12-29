#!/bin/bash
# Usage 'zone'
# 0 0 1 * * zone*
# alias zone='sh $HOME/scripts/zone.sh'

TOKEN=""
CHAT_ID=""
ZONE_ID=""
EMAIL=""
AUTH_KEY=""

if [ -z "$ZONE_ID" ]; then
    echo "🟩 Error: ZONE_ID is not set."
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo "🟩 Error: EMAIL is not set."
    exit 1
fi

if [ -z "$AUTH_KEY" ]; then
    echo "🟩 Error: AUTH_KEY is not set."
    exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "❌ Error: curl is not installed." >&2
    exit 1
fi

date=$(date +%F)
description="Backup from Cloudflare DNS Zone"

curl --request GET \
  --url https://api.cloudflare.com/client/v4/zones/"$ZONE_ID"/dns_records/export \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $EMAIL" \
  --header "X-Auth-Key: $AUTH_KEY" > zone.txt

curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"Date: $date\nDescription: $description\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
curl -X POST -H "content-type: multipart/form-data" -F document=@"zone.txt" -F chat_id="$CHAT_ID" https://api.telegram.org/bot"$TOKEN"/sendDocument
echo "✅ Success: zone_file sent to telegram." >&2