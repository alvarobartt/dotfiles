#!/bin/bash

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not a Git repository"
    exit 1
fi

# Check if the remote Git server is hf.co or huggingface.co
remote_url=$(git config --get remote.origin.url)
if ! echo "$remote_url" | grep -qE 'hf\.co|huggingface\.co'; then
    echo "Error: Remote is not a Hugging Face repository"
    exit 1
fi

# Get GPG key ID associated with email
email="alvaro.bartolome@huggingface.co"
# TODO(gpg): Temporarily remove until fully fixed
# key_id=$(gpg --list-keys --with-colons "alvaro.bartolome@huggingface.co" 2>/dev/null | rg '^fpr:::::::::([^:]+):' -o -r '$1' | head -n 1)
# if [ -z "$key_id" ]; then
#     echo "Error: No GPG key found"
#     exit 1
# fi

# Set the credentials for Hugging Face repositories
git config --local user.email "$email"
# TODO(gpg): Temporarily remove until fully fixed
# git config --local gpg.format "openpgp"
# git config --local user.signingkey "$key_id"

echo "Hugging Face repository credentials set successfully"
