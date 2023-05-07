#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

VERSION="1.0.1"

function print_welcome {
  echo -e ""
  echo -e "          _ __                         "
  echo -e "   ____ _(_) /_                        "
  echo -e "  / __ \`/ / __/                        "
  echo -e " / /_/ / / /_                          "
  echo -e " \__, /_/\__/  ___ __                  "
  echo -e "/____/______  / (_) /_                 "
  echo -e "  / ___/ __ \/ / / __/                 "
  echo -e " (__  ) /_/ / / / /_                   "
  echo -e "/____/ .___/_/_/\__/              _ __ "
  echo -e "  __/_/____  ____ ___  ____ ___  (_) /_"
  echo -e " / ___/ __ \/ __ \`__ \/ __ \`__ \/ / __/"
  echo -e "/ /__/ /_/ / / / / / / / / / / / / /_  "
  echo -e "\___/\____/_/ /_/ /_/_/ /_/ /_/_/\__/  "
  echo -e "                                       "
  echo -e ""
}

function print_usage {
    echo "Usage: $0 <commit_hash> [options]"
    echo "Options:"
    echo "  --version, -v     Prints the version of the script"
    echo "  --help, -h        Prints this usage message"
    exit 1 # Exit the script with an error code
}

function print_version {
    echo "Version $VERSION"
    exit 0 # Exit the script with a success code
}