#!/bin/bash
# ================================================== #
# Symlink this to $PROJECT_DIR/.git/hooks/pre-commit
#
# 1. Runs shellcheck on all project *.sh files
# 2. Report errors and fail as appropriate
# ================================================== #

# Temp exit on failure for initial checks
set -e
echo "==> Executing pre-commit hook"

SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
# Default: Trust that we are running from where we were committed (.github)
PROJECT_DIR="$( cd "${SCRIPT_DIR}/../" && pwd )"
# When running as pre-commit hook from .git/hooks...
[ "hooks" == "$( basename "${SCRIPT_DIR}" )" ] && PROJECT_DIR="$( cd "${SCRIPT_DIR}/../../" && pwd )"

# Pre-empting the build out of this file for more checks
declare -a FAILED_TESTS

SHELLCHECK_FORMAT=gcc
SHELLCHECK_OPTS=( checkstyle diff gcc json json1 quiet tty )
while getopts "hs:" opt; do
  case "${opt}" in
    '?')
      # ? = If getopts is missing a required arg (i.e. for -s), it will rewrite
      # $opt as '?' and NOT exit with error. This forces the failure.
      exit 1
      ;;
    "s")
      # s = shellcheck format
      if [[ " ${SHELLCHECK_OPTS[*]} " =~ [[:space:]]${OPTARG}[[:space:]] ]]; then
        SHELLCHECK_FORMAT="${OPTARG}"
      else
	echo "Invalid -s option. Must be one of [${SHELLCHECK_OPTS[*]}]"
	exit 1
      fi
      ;;
    "h")
      # h = help / usage
      cat <<-EOM
	USAGE:
	  ${0} [-s SHELLCHECK_FORMAT] [-h]

	WHERE:
	  - -h: Displays this Usage.
	  - SHELLCHECK_FORMAT is one of [${SHELLCHECK_OPTS[*]}].
	    Normal shellcheck default is 'tty'. This script uses the less verbose 'gcc' as default.
	EOM
      exit 0
      ;;
  esac
done

# Turn off exit on failure and track remaining with FAILED_TESTS
set +e

# ============================== #
# Execute shellcheck on sh files #
# ============================== #
cd "${PROJECT_DIR}" || exit 1
find "${PROJECT_DIR}" -type f -iname '*.sh' -print0 | xargs -0 shellcheck -f "${SHELLCHECK_FORMAT}" -W 30 && echo "==> shellcheck completed successfully." || FAILED_TESTS+=("shellcheck")

# ===================================== #
# Report errors and fail as appropriate #
# ===================================== #
if (( "${#FAILED_TESTS}" > 0 )); then
  echo "==> Pre-commit tests failed! See previous output for: ${FAILED_TESTS[*]}"
  exit 2
else
  echo "==> Pre-commit tests passed!"
fi
