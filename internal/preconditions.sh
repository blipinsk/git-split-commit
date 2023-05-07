#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Function to check if the current branch has a remote tracking branch
function check_remote_tracking_branch {
  if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    echo -e "\n🚧 Current branch '$1' does not have a remote tracking branch.\n"
    return 1
  fi
  return 0
}

# Function to check if the remote tracking branch is up to date
function check_remote_branch_up_to_date {
  local current_hash=$(git rev-parse HEAD)
  local remote_hash=$(git rev-parse @{u})
  if [ "$current_hash" != "$remote_hash" ]; then
    echo -e "\n🚧 Remote tracking branch for '$1' is not up to date.\n"
    return 1
  fi
  return 0
}

# Function to check if the remote tracking branch is up to date
function check_if_temp_branch_exists {
  local temp_branch=$1
  if git_capture_output show-ref --verify --quiet "refs/heads/${temp_branch}"; then
    echo -e "\n🚧 The temporary branch '${temp_branch}' already exists.\n"
    return 1
  fi
  return 0
}


# Function to check if the remote tracking branch is up to date
function require_clean_working_tree {
  if [[ -n $(git status -s) ]]; then
    echo -e "\n🚧 Your working tree is not clean. Please commit or stash your changes before running this script.\n"
    echo -e "  🛑 Exiting without making any changes.\n"
    exit 1
  fi
}

# Function to check if the remote tracking branch is up to date
function require_commit_in_history {
  local commit_hash=$1

  if ! git_silent rev-list --quiet $commit_hash; then
    echo -e "\n🚧 The commit '$commit_hash' is not in the Git history.\n"
    echo -e "  🛑 Exiting without making any changes.\n"
    exit 1
  fi
}