#!/bin/bash
# 0 * * * * usage

TOKEN=""
CHAT_ID=""
SERVER_NAME=$(hostname)

cpuUsage=$(top -bn1 | awk '/Cpu/ { print int($2) }' | sed 's/%//')
memUsage=$(free -m | awk '/Mem/ { print $3 }' | sed 's/MB//')
diskUsage=$(df -h | awk '/root/ { print int($5) }' | sed 's/%//')

echo "✅ CPU Usage: $cpuUsage%"
if [[ "$cpuUsage" -gt 70 ]]; then
    echo "🚨 CPU Usage: $cpuUsage%"
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"🚨 CPU Usage: $cpuUsage%\", \"🖥 Server: $SERVER_NAME\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
fi

echo "✅ Memory Usage: $memUsage MB"
if [[ "$memUsage" -gt 300 ]]; then
    echo "🚨 Memory Usage: $memUsage MB"
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"🚨 Memory Usage: $memUsage MB\", \"🖥 Server: $SERVER_NAME\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
    
fi

echo "✅ Disk Usage: $diskUsage%"
if [[ "$diskUsage" -gt 70 ]]; then
    echo "🚨 Disk Usage: $diskUsage"
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"🚨 Disk Usage: $diskUsage\", \"🖥 Server: $SERVER_NAME\", \"disable_notification\": true}" https://api.telegram.org/bot"$TOKEN"/sendMessage
    echo "🧹 Cleaning up"
    docker system prune -a -f
    sudo journalctl --vacuum-time=1d
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt clean -y
    echo "🧹 Clean up completed"
fi