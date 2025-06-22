#!/bin/bash
# Usage: ./check_backend.sh <module_name>
# Example: ./check_backend.sh my_module

MODULE="$1"
TFVARS_FILE="terraform/config/${MODULE}.tfvars"
PG_CONN_STR=$(grep -E '^ *PG_CONN_STR *=|PG_CONN_STR=' "$TFVARS_FILE" | sed -E 's/^.*PG_CONN_STR *= *"?([^"]*)"?/\1/')

if [ -z "$MODULE" ]; then
  echo "Usage: $0 <module_name>"
  exit 1
fi

if [ -z "$PG_CONN_STR" ]; then
  PG_CONN_STR=$(grep -E '^ *#.*PG_CONN_STR=' "$TFVARS_FILE" | sed -E 's/^.*PG_CONN_STR="?([^"]*)"?/\1/')
fi

if [[ "$PG_CONN_STR" == *"$MODULE"* ]]; then
  echo "PG_CONN_STR is set correctly for module '$MODULE'."
  echo "Found: $PG_CONN_STR"
  exit 0
fi

echo "PG_CONN_STR is not set correctly for module '$MODULE'."
echo "Expected: $MODULE"
echo "Found: $PG_CONN_STR"
exit 1
