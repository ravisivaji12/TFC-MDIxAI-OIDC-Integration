#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"

TF_FILE="variables.tf"

# Backup the original file
cp "$TF_FILE" "${TF_FILE}.bak"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Extract the current list of values, ensuring we handle multi-line lists properly
    CURRENT_VALUES=$(awk -v var="$VAR_NAME" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {inside=1; sub(/.*default *= *\[/, ""); print}
        inside && /\]/ {inside=0; sub(/\].*/, ""); print}
        inside && !/\]/ {print}
    ' "$TF_FILE" | tr -d ' \n' | tr -d '"')

    # Remove any potential leading/trailing commas or spaces
    CURRENT_VALUES=$(echo "$CURRENT_VALUES" | sed 's/^,*//;s/,*$//')

    # Convert the current values into an array
    IFS=',' read -r -a CURRENT_ARRAY <<< "$CURRENT_VALUES"

    # Convert new values (comma-separated) into an array
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

    # Debugging: Print values before applying the update
    echo "Updating variable: $VAR_NAME"
    echo "New Default Value: $UPDATED_VALUES"

    # Use `awk` to replace the default list with the updated one
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
