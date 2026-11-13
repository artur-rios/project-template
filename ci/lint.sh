#!/bin/sh
# The `lint` check: `dotnet format --verify-no-changes` over each solution under src/ and tests/ (or each project,
# when there is no solution: ci/targets.sh), which fails when a whitespace, code style or analyzer fix would change
# a file, as .editorconfig and the SDK's defaults say. `dotnet format <solution>` applies the same fixes. With no
# solution or project yet (the bare template) there is nothing to check, and it says so and passes.
#
# yggdrasil.yml runs it in the pinned .NET SDK image from the repository's root; by hand, from that root:
#   docker run --rm -v "$PWD:/src" -w /src <image> sh ci/lint.sh
# or, with the .NET 10 SDK installed, just `sh ci/lint.sh`.
set -eu

# The repository's root, wherever this is run from.
cd "$(dirname "$0")/.."

export DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1

targets=$(sh ci/targets.sh)
if [ -z "$targets" ]; then
  echo "ci/lint.sh: no .NET solution or project under src/ or tests/ yet: nothing to check"
  exit 0
fi

echo "$targets" | while IFS= read -r target; do
  echo "== dotnet format $target"
  dotnet format "$target" --verify-no-changes --verbosity minimal
done
