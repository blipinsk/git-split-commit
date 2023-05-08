#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

VERSION="1.0.1"
export GIT_ALIAS="split-commit"

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
  echo -e "╔═════════════════════════════════════╗"
  echo -e "║     by Bartek Lipinski @blipinsk    ║"
  echo -e "╚═════════════════════════════════════╝"
  echo -e ""
}

function print_usage {
    if git_alias_exists $GIT_ALIAS; then
        print_git_alias_usage
        echo -e "\n⚠️  If the git alias ('git $GIT_ALIAS') is not working correctly, reinstall it using './install-git-alias'"
    else
        print_shell_script_usage
    fi
}

function print_shell_script_usage {
    echo "Usage: $0 <commit_hash> [options]"
    print_options
}

function print_git_alias_usage {
    echo "Usage: git $GIT_ALIAS <commit_hash> [options]"
    print_options
}

function print_options {
    echo "Options:"
    echo "  --version, -v     Prints the version of the script"
    echo "  --help, -h        Prints this usage message"
}

function print_version {
    echo "Version $VERSION"
}
