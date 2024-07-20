#!/bin/bash
## https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor

cron_expression=$1
script_to_execute=$2
file_to_backup=$3

usage="🟩 Usage: $0 cron_expression folder"
example="🟩 Example: $0 '0 3 * * 1' 'backup' '$HOME'"

add_cron() {
    local cron=$1
    local script=$2
    local folder=$3
    
    crontab -l > mycron
    echo "$cron $script $folder" >> mycron
    crontab mycron
    rm mycron
}

help() {
    echo "$usage"
    echo "$example"
    exit 1
}

if [ -z "$cron_expression" ] || [ -z "$script_to_execute" ] || [ -z "$file_to_backup" ]; then
    help
fi

echo "🔍 Interval: $cron_expression"
echo "🔍 Script: $script_to_execute"
echo "🔍 Folder: $file_to_backup"
add_cron "$cron_expression" "$script_to_execute" "$file_to_backup"
echo "🚀 Cron job added successfully"
