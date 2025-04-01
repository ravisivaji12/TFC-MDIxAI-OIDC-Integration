#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"
echo "Received arguments: $@"

TF_FILE="./azure/modules/githubrepo/variables.tf"
BACKUP_FILE="${TF_FILE}.bak"

echo "Received arguments: $@"

# Backup the original file if not already backed up
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$TF_FILE" "$BACKUP_FILE"
fi

echo "Received arguments: $@"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Extract the current list of values using awk
    CURRENT_VALUES=$(awk -v var="$VAR_NAME" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {sub(/.*default *= *\[/, ""); sub(/\].*/, ""); print; found=0}
    ' "$TF_FILE")

    # Convert the current values to an array (removing quotes)
    IFS=',' read -r -a CURRENT_ARRAY <<< "$(echo $CURRENT_VALUES | tr -d '"')"
    # Convert new values (comma-separated) into an array
    IFS=',' read -r -a NEW_ARRAY <<< "$NEW_VALUES"

    # Add new values only if they don’t already exist
    for ITEM in "${NEW_ARRAY[@]}"; do
        if [[ ! " ${CURRENT_ARRAY[@]} " =~ " ${ITEM} " ]]; then
            CURRENT_ARRAY+=("$ITEM")
        fi
    done

    # Convert updated array back to Terraform format
    UPDATED_VALUES=$(printf ', "%s"' "${CURRENT_ARRAY[@]}")
    UPDATED_VALUES="[${UPDATED_VALUES:2}]" # Remove leading ", "

    # Update `variables.tf` using `awk` safely
    awk -v var="$VAR_NAME" -v new_values="$UPDATED_VALUES" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {sub(/default *= *\[[^]]*\]/, "default = " new_values); found=0; next}
        {print}
    ' "$TF_FILE" > temp.tf && mv temp.tf "$TF_FILE"
}

# Loop through the provided arguments (key-value pairs)
while [[ $# -gt 0 ]]; do
    VAR_NAME=$1
    NEW_VALUES=$2
    update_tf_variable "$VAR_NAME" "$NEW_VALUES"
    shift 2  # Move to the next key-value pair
done

# Check if there are actual changes before committing
if ! git diff --quiet "$TF_FILE"; then
    git config --local user.email "github-actions@github.com"
    git config --local user.name "github-actions"
    git add "$TF_FILE"
    git commit -m "Update variables.tf"
    git push origin main
else
    echo "No changes to commit."
fi

# Output the updated file for debugging
echo "Updated variables.tf:"
cat "$TF_FILE"


