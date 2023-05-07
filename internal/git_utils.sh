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