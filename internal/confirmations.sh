#!/bin/bash

# Copyright 2023 Bartosz Lipiński
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Function to prompt the user for confirmation to continue
function confirm_destructive_operation {
  echo "⚠️  WARNING: This script is destructive and can cause data loss."
  echo "It is strongly advised to have an up-to-date remote branch with changes before continuing."
  read -p "Are you sure you want to continue? (y/n) " confirm
  if [[ "$confirm" != "y" ]]; then
    echo -e "\n  🛑 Exiting without making any changes.\n"
    exit 1
  fi
}

# Function to prompt the user for confirmation on removal of the existing temporary branch
function confirm_temp_branch_removal {
  local temp_branch=$1
  read -p "Do you want to delete the existing temporary branch and proceed? (y/n): " confirm_delete
  if [[ "$confirm_delete" == "y" ]]; then
    git_silent branch -D "${temp_branch}"
    echo -e "\n  ✅ Existing temporary branch deleted.\n"
  else
    echo -e "\n  🛑 Exiting without making any changes.\n"
    exit 1
  fi
}

# Function to prompt the user to confirm if the they want to push the changes
function confirm_force_push {
  local original_branch=$1
  echo -e "⚠️  WARNING: This is a destructive operation (proceed with caution)."
  read -p " ↪  Do you want to *FORCE* push the changes to the original branch '$original_branch'? (y/n): " confirm_push
  if [[ "$confirm_push" == "y" ]]; then
    git_silent push --force
    echo -e "\n  🎯 Changes force pushed to the original branch!\n"
  else
    echo -e "\n  🏃‍♂️ Changes not pushed. You can push them manually.\n"
  fi
}