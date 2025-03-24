#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"

TF_FILE="variables.tf"

# Backup the original file
cp "$TF_FILE" "${TF_FILE}.bak"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Extract the current list of values using awk instead of grep
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

    # Update `variables.tf` using `sed`
    awk -v var="$VAR_NAME" -v new_values="$UPDATED_VALUES" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {sub(/default *= *\[[^]]*\]/, "default = " new_values); found=0}
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
