#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Function for silent git commands
git_silent() {
  git "$@" &>/dev/null
}

# Function for capturing git command output while silencing errors
git_capture_output() {
  git "$@" 2>/dev/null
}

echo -e ""
echo -e "          _ __                   ___ __                                       _ __ "
echo -e "   ____ _(_) /_      _________  / (_) /_      _________  ____ ___  ____ ___  (_) /_"
echo -e "  / __ \`/ / __/_____/ ___/ __ \/ / / __/_____/ ___/ __ \/ __ \`__ \/ __ \`__ \/ / __/"
echo -e " / /_/ / / /_/_____(__  ) /_/ / / / /_/_____/ /__/ /_/ / / / / / / / / / / / / /_  "
echo -e " \__, /_/\__/     /____/ .___/_/_/\__/      \___/\____/_/ /_/ /_/_/ /_/ /_/_/\__/  "
echo -e "/____/                /_/                                                       "
echo -e ""


# Initialize variables to hold the arguments
COMMIT_HASH=""
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
        # If the argument is anything else, display an error message
        *)
            echo "Invalid argument: $key"
            exit 1 # Exit the script with an error code
            ;;
    esac
done

if [[ -z "$COMMIT_HASH" ]]; then
  echo -e "\n📝 Usage: $0 <commit-hash>\n"
  exit 1
fi

SHORT_HASH=$(git_capture_output rev-parse --short "${COMMIT_HASH}")
CURRENT_BRANCH=$(git_capture_output rev-parse --abbrev-ref HEAD)
TEMP_BRANCH="splitting-commit-${SHORT_HASH}"

# Ensure the working tree is clean
if ! git_capture_output diff-index --quiet HEAD --; then
  echo -e "\n🚧 Your working tree is not clean. Please commit or stash your changes before running this script.\n"
  exit 1
fi

# Check if the temporary branch already exists
if git_capture_output show-ref --verify --quiet "refs/heads/${TEMP_BRANCH}"; then
  echo -e "\n⚠️ The temporary branch '${TEMP_BRANCH}' already exists.\n"
  read -p "Do you want to delete the existing temporary branch and proceed? (y/n): " confirm_delete
  if [[ "$confirm_delete" == "y" ]]; then
    git_silent branch -D "${TEMP_BRANCH}"
    echo -e "\n  ✅ Existing temporary branch deleted.\n"
  else
    echo -e "\n  🛑 Exiting without making any changes.\n"
    exit 1
  fi
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
echo -e "  ✅ '$COMMIT_HASH' has been split into one commit per modified file.\n"

# Confirm if the user wants to push the changes
read -p "🚀 Do you want to force push the changes to the original branch? (y/n): " confirm_push
if [[ "$confirm_push" == "y" ]]; then
  git_silent push --force
  echo -e "\n  🎯 Changes force pushed to the original branch!\n"
else
  echo -e "\n  🏃‍♂️ Changes not pushed. You can push them manually.\n"
fi