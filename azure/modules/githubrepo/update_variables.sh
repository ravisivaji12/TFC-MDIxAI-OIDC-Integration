#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"

TF_FILE="variables.tf"

# Backup the original file
cp "$TF_FILE" "${TF_FILE}.bak"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Extract the current list of values
    CURRENT_VALUES=$(awk -v var="$VAR_NAME" '
        $0 ~ "variable \"" var "\" *{" {found=1}
        found && /default *= *\[/ {inside=1; sub(/.*default *= *\[/, ""); print}
        inside && /\]/ {inside=0; sub(/\].*/, ""); print}
        inside && !/\]/ {print}
    ' "$TF_FILE" | tr -d '[]"')

    # Debug: Show extracted values
    echo "Current values for $VAR_NAME: $CURRENT_VALUES"

    # Convert to an array (ensure no empty elements)
    IFS=',' read -r -a CURRENT_ARRAY <<< "$CURRENT_VALUES"

    # Convert new values into an array
    IFS=',' read -r -a NEW_ARRAY <<< "$NEW_VALUES"

    # Use an associative array to track unique values
    declare -A UNIQUE_VALUES

    # Add current values to the associative array
    for ITEM in "${CURRENT_ARRAY[@]}"; do
        ITEM=$(echo "$ITEM" | xargs)  # Trim whitespace
        [[ -n "$ITEM" ]] && UNIQUE_VALUES["$ITEM"]=1
    done

    # Add new values, ensuring uniqueness
    for ITEM in "${NEW_ARRAY[@]}"; do
        ITEM=$(echo "$ITEM" | xargs)  # Trim whitespace
        [[ -n "$ITEM" ]] && UNIQUE_VALUES["$ITEM"]=1
    done

    # Construct the final Terraform list **with quotes and commas**
    UPDATED_VALUES="["
    for KEY in "${!UNIQUE_VALUES[@]}"; do
        UPDATED_VALUES+=" \"$KEY\","
    done
    UPDATED_VALUES="${UPDATED_VALUES%,} ]"  # Remove trailing comma and close bracket

    # Debug: Show final formatted list before updating
    echo "Updated values for $VAR_NAME: $UPDATED_VALUES"

    # Preserve file structure and update only the target variable
    awk -v var="$VAR_NAME" -v new_values="$UPDATED_VALUES" '
        BEGIN { inside=0; found=0 }
        {
            if ($0 ~ "variable \"" var "\" *{") {
                found=1
            }
            if (found && /default *= *\[/) {
                inside=1
                print "  default = " new_values
                next
            }
            if (inside && /\]/) {
                inside=0
                next
            }
            if (inside) {
                next
            }
            print
        }
    ' "$TF_FILE" > temp.tf && mv temp.tf "$TF_FILE"
}

# Loop through arguments (key-value pairs)
while [[ $# -gt 0 ]]; do
    VAR_NAME=$1
    NEW_VALUES=$2
    update_tf_variable "$VAR_NAME" "$NEW_VALUES"
    shift 2
done

echo "Updated variables.tf:"
cat "$TF_FILE"
