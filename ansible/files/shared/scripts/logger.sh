#!/bin/bash
## This script is used to monitor the syslog file and store the logs in a database.
## EXECUTABLE: chmod +x logger.sh ; sudo mv logger.sh /usr/local/bin/logger
## CRON: */15 * * * * logger <database_name> <timeframe>

### This is the path where turso is installed
### If this is not used, the script won't recognize the turso command
export PATH=$HOME/.turso:$PATH

database=${1:-logs}
timeframe=${2:-15}

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

current_time=$(date +"%b %d %H:%M")
previous_time=$(date -d "$timeframe minutes ago" +"%b %d %H:%M")
file_to_monitor="/var/log/syslog"

output=$(awk -v cur_time="$current_time" -v prev_time="$previous_time" '{
    log_time = $1 " " $2 " " $3 " " $4;
    if (log_time >= prev_time && log_time <= cur_time) {
        print $0;
    }
}' $file_to_monitor)

mapfile -t array <<< "$output"

declare -A seen_logs
unique_array=()
for line in "${array[@]}"; do
    log=$(echo "$line" | cut -d ' ' -f 4-)
    if [[ ! "${seen_logs[$log]}" ]]; then
        seen_logs["$log"]=1
        unique_array+=("$line")
    fi
done

function turso_exec() {
    local db=$1
    local command=$2
    turso db shell "$db" "$command" 2>$HOME/logs/turso.err
}

for line in "${unique_array[@]}"; do
    logs=($line)
    date="${logs[@]:0:3}"
    hostname="${logs[3]}"
    log="${logs[@]:4}"
    log=$(echo "$log" | sed "s/'/''/g")
    index=$(python3 -c "import uuid; print(uuid.uuid4())")

    turso_exec "$database" "INSERT INTO $database (id, date, hostname, log_message) VALUES ('$index', '$date', '$hostname', '$log');"
    echo "Added: $line"
done
