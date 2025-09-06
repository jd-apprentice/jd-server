#!/bin/bash
## Usage: backup.sh [mode]
## EDIT: rsyncignore

BASE_NAME="storage"
DOMAIN=".local"
MODE=${1:-backup}
USER=root
REMOTE_PATH="/root/arch"
LOCAL_PATH="$HOME/"

if [[ "$MODE" == "restore" ]]; then
    REMOTE_DEST="${USER}@${BASE_NAME}${DOMAIN}:${REMOTE_PATH}"

    rsync -aAXHvr --verbose --filter="merge $HOME/.config/rsyncignore" -e "ssh -p 9022 -i ~/.ssh/id_rsa" "$REMOTE_DEST" "$LOCAL_PATH"
    echo "Completed restore"
    exit 0
fi

REMOTE_DEST="${USER}@${BASE_NAME}${DOMAIN}:${REMOTE_PATH}"

if [[ "$MODE" == "backup" ]]; then
    rsync -aAXHvr --verbose --filter="merge $HOME/.config/rsyncignore" -e "ssh -p 9022 -i ~/.ssh/id_rsa" "$LOCAL_PATH" "$REMOTE_DEST"
fi

if [ ! $? -eq 0 ]; then
    echo "Err while doing backup for $HOST. Skipping..."
    exit 1
fi

echo "Completed backup for $BASE_NAME$DOMAIN"
