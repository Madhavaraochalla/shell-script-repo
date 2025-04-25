#!/bin/bash

set -e

# Define users and password
USERS=("developer" "Qa")
PASSWORD="1433"

for USER in "${USERS[@]}"; do
    echo "Creating user: $USER"

    # Check if user already exists
    if id "$USER" &>/dev/null; then
        echo "User $USER already exists. Skipping..."
    else
        sudo useradd -m "$USER"
        echo "$USER:$PASSWORD" | sudo chpasswd
        echo "User $USER created and password set."
    fi
done

