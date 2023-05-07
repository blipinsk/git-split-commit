#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

SCRIPT_DIR_ABSOLUTE=$(dirname "$(readlink -f "$0")")

source "$SCRIPT_DIR_ABSOLUTE/internal/git_utils.sh"
source "$SCRIPT_DIR_ABSOLUTE/internal/info.sh"

# Define the alias name and the path to the script file
SCRIPT_PATH="$SCRIPT_DIR_ABSOLUTE/git-split-commit.sh"

print_welcome
echo -e "\n⚙️  Installing Git alias '$GIT_ALIAS' for script at:"
echo -e "\n  $SCRIPT_PATH\n"

# Check if an alias by the same name already exists
if git_alias_exists $GIT_ALIAS; then
  # If it does, remove it and notify the user
  echo -e "\n🔥 Existing Git alias '$GIT_ALIAS' found. Reinstalling...\n"
  remove_git_alias "$GIT_ALIAS"
fi

# Add the new alias
git config --global alias.$GIT_ALIAS "!$SCRIPT_PATH"
echo -e "\n🎉 Git alias '$GIT_ALIAS' added sucessfully!\n"

echo -e "\n🚀 You can now use the script directly from Git:\n"
print_git_alias_usage