#!/bin/bash

# Copyright 2023 Bartosz Lipiński
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

SCRIPT_DIR_ABSOLUTE=$(dirname "$(readlink -f "$0")")

source "$SCRIPT_DIR_ABSOLUTE/internal/confirmations.sh"
source "$SCRIPT_DIR_ABSOLUTE/internal/git_utils.sh"
source "$SCRIPT_DIR_ABSOLUTE/internal/info.sh"
source "$SCRIPT_DIR_ABSOLUTE/internal/preconditions.sh"

print_welcome

# Initialize variables to hold the arguments
COMMIT_HASH=""
NO_PUSH=false

# Loop through all the arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        # If the argument is a commit hash, assign it to the variable
        [0-9a-fA-F]*)
            COMMIT_HASH="$key"
            shift # Move on to the next argument
            ;;
        # If the argument is the no-push or -np flag, set the variable to true
        --no-push|-np)
            NO_PUSH=true
            shift # Move on to the next argument
            ;;
        # If the argument is the help or -h flag, print usage instructions
        --help|-h)
            print_usage
            exit 0
            ;;
        # If the argument is the version or -v flag, print version
        --version|-v)
            print_version
            exit 0
            ;;
        # If the argument is anything else, display an error message
        *)
            echo "Invalid argument: $key"
            print_usage
            exit 1
            ;;
    esac
done

if [[ -z "$COMMIT_HASH" ]]; then
  print_usage
  exit 1
fi

SHORT_HASH=$(git_capture_output rev-parse --short "${COMMIT_HASH}")
CURRENT_BRANCH=$(git_capture_output rev-parse --abbrev-ref HEAD)
TEMP_BRANCH="splitting-commit-${SHORT_HASH}"

require_clean_working_tree
require_commit_in_history "$COMMIT_HASH"

# Check if the current branch has a remote tracking branch
if ! check_remote_tracking_branch "$CURRENT_BRANCH"; then
  confirm_destructive_operation
fi

# Check if the current branch has a remote tracking branch
if ! check_remote_branch_up_to_date "$CURRENT_BRANCH"; then
  confirm_destructive_operation
fi

# Check if the temporary branch already exists
if ! check_if_temp_branch_exists $TEMP_BRANCH; then
  confirm_temp_branch_removal
fi

echo -e "👷‍♂️ Beginning the splitting procedure...\n"

echo -e "🌟 Creating a temporary branch: ${TEMP_BRANCH}\n"
# Create a new temporary branch at the commit to split
git_silent checkout -b "${TEMP_BRANCH}" "${COMMIT_HASH}"

# Reset the commit to split
git_silent reset HEAD^

# Loop through the modified files and create separate commits for each
for file in $(git_capture_output status --porcelain | awk '{print $2}'); do
  git_silent add "$file"
  git_silent commit -m "🔧 Modified file: ${file}"
  echo -e "  ✅ Changes to ${file} have been committed.\n"
done

echo -e "👷‍♂️ Rebasing '${CURRENT_BRANCH}' onto the temporary branch\n"
git_silent checkout "${CURRENT_BRANCH}"
git_silent rebase "${TEMP_BRANCH}"

echo -e "🔥 Removing the temporary branch: ${TEMP_BRANCH}\n"
git_silent branch -D "${TEMP_BRANCH}"

# Output the temporary branch
echo -e "🎉 The rebase process has been completed successfully!"
echo -e "\n  ✅ '$COMMIT_HASH' has been split into one commit per modified file.\n"

if ! $NO_PUSH ; then
  # Confirm if the user wants to push the changes
confirm_force_push "$CURRENT_BRANCH"
fi