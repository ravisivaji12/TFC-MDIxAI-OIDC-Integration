#!/bin/bash

# GitHub Organization or Username
GITHUB_ORG="ravisivaji12"

# GitHub token from environment variables
GITHUB_TOKEN=${GITHUB_TOKEN:?Missing GitHub Token}

# Function to check if a repo exists
repo_exists() {
  REPO_NAME=$1
  RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_ORG/$REPO_NAME")
  HTTP_STATUS=$(echo "$RESPONSE" | jq -r .message)

  if [[ "$HTTP_STATUS" == "Not Found" ]]; then
    return 1  # Repo does not exist
  else
    return 0  # Repo exists
  fi
}

# Read input repositories (comma-separated)
IFS=',' read -r -a NEW_REPOS <<< "$1"

MISSING_REPOS=()

for REPO in "${NEW_REPOS[@]}"; do
  if repo_exists "$REPO"; then
    echo "✅ Repo '$REPO' already exists. Skipping..."
  else
    echo "❌ Repo '$REPO' does not exist. Marking for creation..."
    MISSING_REPOS+=("$REPO")
  fi
done

# Convert array to comma-separated string
if [ ${#MISSING_REPOS[@]} -ne 0 ]; then
    MISSING_REPOS_STR=$(IFS=','; echo "${MISSING_REPOS[*]}")
    echo "MISSING_REPOS=$MISSING_REPOS_STR" | tee -a "$GITHUB_ENV"
else
    echo "MISSING_REPOS=" | tee -a "$GITHUB_ENV"
fi
