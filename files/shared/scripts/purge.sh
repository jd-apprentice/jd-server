#!/bin/bash
## This script is purge logs from the database older than 1 month
## EXECUTABLE: chmod +x purge.sh ; sudo mv purge.sh /usr/local/bin/purge
## CRON: 0 0 20 * * purge <database_name> <month>

### This is the path where turso is installed
### If this is not used, the script won't recognize the turso command
export PATH=$HOME/.turso:$PATH

actual_month=$(date | awk '{print $2}')

database=${1:-logs}
month=${2:-$actual_month}

token=""
chat_id=""

server_name=$(hostname)
date=$(date +"%b %d %H:%M")
turso_path="$HOME/.turso"

if [[ ! -d $turso_path ]]; then
    echo "Turso is not installed. Please install it first."
    exit 1
fi

is_logged_in=$(turso db list | grep "$database" | wc -l)

error_message="Token expired. Please login again."

if [[ $is_logged_in -eq 0 ]]; then
    curl -X POST -H "content-type: application/json" -d "{\"chat_id\": \"$chat_id\", \"text\": \"Error: $error_message\nDate: $date\nServer: $server_name\", \"disable_notification\": true}" https://api.telegram.org/bot"$token"/sendMessage
    echo "$error_message"
    exit 1
fi

function turso_exec() {
    local db=$1
    local command=$2
    turso db shell "$db" "$command"
}

turso_exec "$database" "DELETE FROM $database WHERE date < '$month 15'"