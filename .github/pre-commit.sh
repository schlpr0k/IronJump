#!/bin/bash
# ================================================== #
# Symlink this to $PROJECT_DIR/.git/hooks/pre-commit
#
# 1. Runs shellcheck on all project *.sh files
# 2. Report errors and fail as appropriate
# ================================================== #

echo "==> Executing pre-commit hook"

SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
# Default: Trust that we are running from where we were committed (.github)
PROJECT_DIR="$( cd "${SCRIPT_DIR}/../" && pwd )"
# When running as pre-commit hook from .git/hooks...
[ "hooks" == "$( basename "${SCRIPT_DIR}" )" ] && PROJECT_DIR="$( cd "${SCRIPT_DIR}/../../" && pwd )"

# Pre-empting the build out of this file for more checks
declare -a FAILED_TESTS

# ============================== #
# Execute shellcheck on sh files #
# ============================== #
cd "${PROJECT_DIR}" || exit 1
find "${PROJECT_DIR}" -type f -iname '*.sh' -print0 | xargs -0 shellcheck -W 30 && echo "==> shellcheck completed successfully." || FAILED_TESTS+=("shellcheck")

# ===================================== #
# Report errors and fail as appropriate #
# ===================================== #
if (( "${#FAILED_TESTS}" > 0 )); then
  echo "==> Pre-commit tests failed! See previous output for: ${FAILED_TESTS[*]}"
  exit 2
else
  echo "==> Pre-commit tests passed!"
fi
