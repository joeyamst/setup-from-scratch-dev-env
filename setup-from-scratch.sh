#!/bin/bash

# Function to print an error message and exit
exit_with_message() {
    echo "$1"
    exit 1
}

# Get the current working directory
current_dir=$(pwd)

# Extract the name of the current directory
current_dir_name=$(basename "$current_dir")

# Check if the current directory is 'dev-env' and the parent directory is 'salmagundi'
if [[ "$current_dir_name" == "dev-env" ]] && [[ $(basename "$(dirname "$current_dir")") == "salmagundi" ]]; then
    echo "In the wrong directory. Going back..."
    cd ../..
fi

if [[ "$current_dir_name" == "salmagundi" ]]; then
    echo "In the wrong directory. Going back..."
    cd ..
fi


# Define the root directory where 'salmagundi' should be
root_dir=$(pwd)

# Define the directory path for 'salmagundi' and 'dev-env'
salmagundi_dir="$root_dir/salmagundi"
dev_env_dir="$salmagundi_dir/dev-env"

# Create the 'salmagundi' directory if it doesn't exist
mkdir -p "$salmagundi_dir"

# Clone or pull the dev-env repo if necessary
if [ -d "$dev_env_dir/.git" ]; then
    echo "'dev-env' already exists. Pulling the latest changes..."
    git -C "$dev_env_dir" pull
else
    echo "Cloning 'dev-env'..."
    git clone "git@ssh.dev.azure.com:v3/CloudCompetenceCenter/salmagundi/dev-env" "$dev_env_dir"
fi

# Navigate to the 'dev-env' directory
cd "$dev_env_dir" || exit_with_message "Failed to navigate to the 'dev-env' directory."

# Execute the make clone command
if ! make clone; then
    exit_with_message "Failed to run 'make clone'. Please check the Makefile and try again."
fi

echo "Setup completed successfully."
