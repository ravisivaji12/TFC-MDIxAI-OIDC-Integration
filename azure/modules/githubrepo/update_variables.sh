#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"

TF_FILE="./azure/modules/githubrepo/variables.tf"

# Backup the original file
cp "$TF_FILE" "${TF_FILE}.bak"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Extract current values, removing unnecessary spaces and new lines
    CURRENT_VALUES=$(awk -v var="$VAR_NAME" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {inside=1; sub(/.*default *= *\[/, ""); print}
        inside && /\]/ {inside=0; sub(/\].*/, ""); print}
        inside && !/\]/ {print}
    ' "$TF_FILE" | tr -d ' \n' | tr -d '[]"')

    # Debugging: Check extracted values
    echo "Current Values for $VAR_NAME: $CURRENT_VALUES"

    # Convert the current values into an array
    IFS=',' read -r -a CURRENT_ARRAY <<< "$CURRENT_VALUES"

    # Convert new values into an array
    IFS=',' read -r -a NEW_ARRAY <<< "$NEW_VALUES"

    # Add new values only if they don’t already exist
    for ITEM in "${NEW_ARRAY[@]}"; do
        if [[ ! " ${CURRENT_ARRAY[@]} " =~ " ${ITEM} " ]]; then
            CURRENT_ARRAY+=("$ITEM")
        fi
    done

    # Construct the correct Terraform list format
    UPDATED_VALUES=$(printf ', "%s"' "${CURRENT_ARRAY[@]}")
    UPDATED_VALUES="[${UPDATED_VALUES:2}]" # Remove leading ", "

    # Debugging: Print the final values before updating
    echo "Updated Values for $VAR_NAME: $UPDATED_VALUES"

    # Use awk to update variables.tf
    awk -v var="$VAR_NAME" -v new_values="$UPDATED_VALUES" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {inside=1; print "  default = " new_values; next}
        inside && /\]/ {inside=0; next}
        inside && !/\]/ {next}
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

echo "Updated variables.tf:"
cat "$TF_FILE"
