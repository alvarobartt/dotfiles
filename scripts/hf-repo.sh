#!/bin/bash

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: Not a Git repository"
    exit 1
fi

# Check if the remote Git server is hf.co or huggingface.co
remote_url=$(git config --get remote.origin.url)
if ! echo "$remote_url" | grep -qE 'hf\.co|huggingface\.co'; then
    echo "Error: Remote is not a Hugging Face repository"
    exit 1
fi

# Set the credentials for Hugging Face repositories
git config --local user.email "alvaro.bartolome@huggingface.co"

echo "Hugging Face repository credentials set successfully"
