#!/bin/bash
# 0 * * * * alerts
# alias alerts='sh $HOME/scripts/alerts.sh'

TOKEN=""
CHAT_ID=""

echo "🛑 Checking if cloudflared is running"

## https://www.cyberciti.biz/faq/systemd-systemctl-list-all-failed-units-services-on-linux/
isRunning=$(systemctl is-active cloudflared)

if [ "$isRunning" != "active" ]; then
    echo "🚨 cloudflared is not running"
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"🚨 cloudflared is not running\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
    exit 1
fi

echo "🛑 Running monitor"
monitor=$(journalctl -u cloudflared -S "$(date -d "-1 hour" +%Y"-%m-%d "%T)" | awk '/ERR/' | tail -n 5)

if [ -z "$monitor" ]; then
    echo "✅ No errors found"
    exit 0
fi

echo "🚨 Error found"

curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"🚨 Error: $monitor\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage