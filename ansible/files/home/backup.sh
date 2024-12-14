#!/bin/bash
## Usage: backup.sh [mode]
## EDIT: rsyncignore

BASE_NAME="storage"
DOMAIN=".local"
MODE=${1:-backup}
USER=$(whoami)
REMOTE_PATH="$HOME/arch"
LOCAL_PATH="$HOME/"
LOCAL_DEST="/run/media/dyallo/Backup/Arch"

if [[ "$MODE" == "restore" ]]; then
    REMOTE_DEST="${USER}@${BASE_NAME}${DOMAIN}:${REMOTE_PATH}"

    rsync -aAXHvr --verbose --filter="merge $HOME/.config/rsyncignore" -e ssh "$REMOTE_DEST" "$LOCAL_PATH"
    echo "Completed restore"
    exit 0
fi

REMOTE_DEST="${USER}@${BASE_NAME}${DOMAIN}:${REMOTE_PATH}"


if [[ "$MODE" == "backup" ]]; then
    rsync -aAXHvr --verbose --filter="merge $HOME/.config/rsyncignore" -e ssh "$LOCAL_PATH" "$REMOTE_DEST"
    rsync -aAXHvr --verbose --filter="merge $HOME/.config/rsyncignore" "$LOCAL_PATH" "$LOCAL_DEST"
fi

if [ ! $? -eq 0 ]; then
    echo "Err while doing backup for $HOST. Skipping..."
    exit 1
fi

echo "Completed backup for $BASE_NAME$DOMAIN"