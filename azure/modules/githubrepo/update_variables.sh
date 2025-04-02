#!/bin/bash

# Usage: ./update_variables.sh repo_list "repo-three,repo-four" team_list "team-gamma" project_list "project-z"

TF_FILE="./azure/modules/githubrepo/variables.tf"

# Backup the original file
cp "$TF_FILE" "${TF_FILE}.bak"

# Function to update a Terraform list variable
update_tf_variable() {
    VAR_NAME=$1
    NEW_VALUES=$2

    # Read the full Terraform file and preserve all content
    awk -v var="$VAR_NAME" -v new_values="$NEW_VALUES" '
        BEGIN { inside=0; found=0; buffer="" }
        {
            if ($0 ~ "variable \"" var "\" *{") {
                found=1
            }
            if (found && /default *= *\[/) {
                inside=1
                buffer = buffer "  default = ["
                next
            }
            if (inside) {
                if ($0 ~ /\]/) {
                    inside=0
                    next
                }
                next
            }
            buffer = buffer "\n" $0
        }
        END {
            # Convert new values to a properly formatted Terraform list
            split(new_values, new_array, ",")
            updated_list="["
            for (i in new_array) {
                updated_list = updated_list "\"" new_array[i] "\","
            }
            updated_list = substr(updated_list, 1, length(updated_list)-1) "]"  # Remove last comma
            
            # Replace the target variable default value
            gsub(/\[\]/, updated_list, buffer)
            print buffer
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
