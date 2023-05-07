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

function git_alias_exists {
    alias_name=$1
    git_silent config --get-regexp ^alias\\.$alias_name\$
}

function add_git_alias {
    alias_name=$1
    script_path=$2
    git config --global alias.$alias_name "!$script_path"
}

function remove_git_alias {
    alias_name=$1
    if git config --global --unset "alias.$alias_name"; then
        echo -e "  ✅ Existing Git alias '$alias_name' found and removed.\n"
    else
        echo -e "  ❌ Error: Failed to remove Git alias '$alias_name'." >&2
        exit 1
    fi
}