#!/bin/bash

VARIABLE_NAME="$1"
NEW_VALUES="$2"
FILE_PATH="./azure/modules/githubrepo/variables.tf"

# Read the file content
CONTENT=$(cat "$FILE_PATH")
echo "$CONTENT"
cat "$FILE_PATH"

# Improved regex to match list variables correctly
PATTERN="variable \"$VARIABLE_NAME\"[[:space:]]*\{[[:space:]]*[^}]*default[[:space:]]*=[[:space:]]*\[([^\]]*)\]"
if [[ ! $CONTENT =~ $PATTERN ]]; then
    echo "Variable '$VARIABLE_NAME' not found in the file."
    exit 1
fi

# Extract existing values and clean whitespace
EXISTING_VALUES=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]' | tr ',' '\n' | tr -d '"')

# Convert new values into an array
IFS=',' read -ra NEW_VALUES_ARRAY <<< "$NEW_VALUES"

# Concatenate the old and new values
UPDATED_VALUES=("${EXISTING_VALUES[@]}" "${NEW_VALUES_ARRAY[@]}")

# Format the updated list
UPDATED_LIST="["
for VALUE in "${UPDATED_VALUES[@]}"; do
    UPDATED_LIST+="\n    \"$VALUE\","
done
UPDATED_LIST=${UPDATED_LIST%,}  # Remove trailing comma
UPDATED_LIST+="\n]"

# Replace the existing list with the updated list
UPDATED_CONTENT=$(echo "$CONTENT" | sed -E "s|($PATTERN)|variable \"$VARIABLE_NAME\" {\n  default = $UPDATED_LIST\n}|")

# Write back to the file
echo -e "$UPDATED_CONTENT" > "$FILE_PATH"

echo "Variable '$VARIABLE_NAME' updated successfully."
