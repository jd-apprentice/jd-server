#!/bin/bash
## https://askubuntu.com/questions/834717/recursive-tar-compression
## https://devhints.io/bash#dictionaries
## CRON: 0 0 */15 * * encc $HOME

folder=${1:-$HOME}
is_ccrypt_installed=$(which ccrypt)

declare -a hosts=()

if [ -z "$is_ccrypt_installed" ]; then
  echo "ccrypt is not installed. Please install it first."
  exit 1
fi

if [ -z "$folder" ]; then
  echo "Please provide a folder to encrypt."
  exit 1
fi

tar -cvf backup.tar "$folder/*"
ccrypt -E YOUR_KEY backup.tar

for host in "${hosts[@]}"
do
  scp backup.tar.cpt "$host:/home/$(whoami)/backup"
done

rm backup.tar.cpt