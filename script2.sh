#!/bin/bash

# Check if arguments are provided; if not, use environment variables
DIRECTORY=${1:-$DIRECTORY_PATH}      # Directory path: uses DIRECTORY_PATH environment variable if not specified as the first argument
MASK=${2:-$FILE_MASK}                # File mask: uses FILE_MASK environment variable if not specified as the second argument
MINUTES=${3:-$FILE_AGE_MINUTES}      # File age in minutes: uses FILE_AGE_MINUTES environment variable if not specified as the third argument
AUTO_CONFIRM=false                   # Initialize the auto-confirm flag as "false"

# Check if the auto-confirm flag is set
if [[ $4 == "-y" || $AUTO_CONFIRM_ENV == "true" ]]; then
  AUTO_CONFIRM=true                  # Enable auto-confirm if "-y" flag is provided or AUTO_CONFIRM_ENV is "true"
fi

# Validate input parameters
if [[ -z "$DIRECTORY" || -z "$MASK" || -z "$MINUTES" ]]; then
  echo "Usage: $0 <directory_path> <file_mask> <file_age_minutes> [-y]"
  echo "Or set the following environment variables: DIRECTORY_PATH, FILE_MASK, FILE_AGE_MINUTES, AUTO_CONFIRM_ENV"
  exit 1                              # Exit the script if mandatory parameters are missing
fi

# Find files that match the mask and are older than the specified number of minutes
FILES_TO_DELETE=$(find "$DIRECTORY" -type f -name "$MASK" -mmin +$MINUTES)
if [[ -z "$FILES_TO_DELETE" ]]; then
  echo "No files found for deletion based on the specified criteria."
  exit 0                              # Exit the script if no files match the criteria
fi

# Display the list of files to be deleted
echo "The following files will be deleted:"
echo "$FILES_TO_DELETE"

# Check the auto-confirm flag or prompt for confirmation
if [[ "$AUTO_CONFIRM" == true ]]; then
  echo "Deleting files without confirmation..."
else
  read -p "Are you sure you want to delete these files? (y/n): " CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    echo "Deletion canceled."
    exit 0                            # Exit the script if the user does not confirm deletion
  fi
fi

# Delete the files
echo "$FILES_TO_DELETE" | xargs rm -f  # Delete files using xargs with rm -f
echo "Files have been successfully deleted."
