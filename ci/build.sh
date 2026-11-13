#!/bin/sh
# The `build` check: restore, build in Release and test each solution under src/ and tests/ (or each project, when
# there is no solution: ci/targets.sh). `dotnet test` runs the test projects among them and builds the rest. With
# no solution or project yet (the bare template) there is nothing to build, and it says so and passes.
#
# yggdrasil.yml runs it in the pinned .NET 10 SDK image from the repository's root; by hand, from that root:
#   docker run --rm -v "$PWD:/src" -w /src <image> sh ci/build.sh
# or, with the .NET 10 SDK installed, just `sh ci/build.sh`.
set -eu

# The repository's root, wherever this is run from.
cd "$(dirname "$0")/.."

export DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1

targets=$(sh ci/targets.sh)
if [ -z "$targets" ]; then
  echo "ci/build.sh: no .NET solution or project under src/ or tests/ yet: nothing to build"
  exit 0
fi

echo "$targets" | while IFS= read -r target; do
  echo "== $target"
  dotnet restore "$target"
  dotnet build "$target" --no-restore --configuration Release
  dotnet test "$target" --no-build --configuration Release
done
