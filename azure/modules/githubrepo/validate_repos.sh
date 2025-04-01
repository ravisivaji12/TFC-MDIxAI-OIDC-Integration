#!/bin/bash

# GitHub Organization or Username
GITHUB_ORG="ravisivaji12"

# GitHub token from environment variables
GITHUB_TOKEN=${GITHUB_TOKEN:?Missing GitHub Token}

# Function to check if a repo exists
repo_exists() {
  REPO_NAME=$1
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_ORG/$REPO_NAME")

  if [[ "$RESPONSE" == "200" ]]; then
    return 0  # Repo exists
  else
    return 1  # Repo does not exist
  fi
}

# Process new repos from input
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

# Print missing repos as a comma-separated string
if [ ${#MISSING_REPOS[@]} -ne 0 ]; then
   MISSING_REPOS_STR=$(IFS=','; echo "${MISSING_REPOS[*]}")
   echo "MISSING_REPOS=$MISSING_REPOS_STR" >> $GITHUB_ENV
   echo "$MISSING_REPOS_STR"
else
   echo "MISSING_REPOS=" >> $GITHUB_ENV
   echo ""
fi
