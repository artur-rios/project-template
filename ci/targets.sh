#!/bin/sh
# Prints what ci/lint.sh and ci/build.sh work on, one path per line: every .NET solution (.sln, .slnx) under src/
# and tests/, or, when there is none, every project (.csproj) there. Prints nothing when there are neither, as in
# the template itself today. Run from the repository's root (both scripts run it after their `cd`).
#
# By hand, from the repository's root: sh ci/targets.sh
set -eu

targets=$(find src tests -type f \( -name '*.sln' -o -name '*.slnx' \) 2>/dev/null | sort)
if [ -z "$targets" ]; then
  targets=$(find src tests -type f -name '*.csproj' 2>/dev/null | sort)
fi
[ -z "$targets" ] || printf '%s\n' "$targets"
