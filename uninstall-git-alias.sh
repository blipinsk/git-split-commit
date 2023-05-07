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
echo -e "\n⚙️  Uninstalling Git alias '$GIT_ALIAS'"

# Check if an alias by that name exists
if git_alias_exists $GIT_ALIAS; then
  # If it does, remove it and notify the user
  echo -e "\n🔥 Existing Git alias '$GIT_ALIAS' found. Uninstalling...\n"
  remove_git_alias "$GIT_ALIAS"
else
  echo -e "\n  🏃‍♂️ Git alias '$GIT_ALIAS' not found.\n"
fi