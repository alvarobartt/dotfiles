#!/bin/bash

set -e

# Verify tag argument provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <tag-name>"
    exit 1
fi
TARGET_TAG=$1

# Fetch latest tags from origin
echo "Fetching tags..."
git fetch --tags origin

# Verify tag existence
echo -e "\nChecking tag availability..."
if ! git tag | grep -qw "$TARGET_TAG"; then
    echo "Error: Tag '$TARGET_TAG' not found in local or remote"
    echo -e "\nLocal tags:"
    git tag
    echo -e "\nRemote tags:"
    git ls-remote --tags origin
    exit 2
fi

# Checkout logic
echo -e "\nAttempting checkout..."
if git checkout "$TARGET_TAG"; then
    echo "Successfully checked out $TARGET_TAG"
    exit 0
else
    echo "Error: Checkout failed due to conflicts/uncommitted changes"
    exit 3
fi
