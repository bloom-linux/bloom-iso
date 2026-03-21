#!/bin/bash
# Build the ISO and immediately launch it in a VM.
# Usage: ./test.sh [--clean]

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$PROFILE_DIR/scripts/build.sh" "$@" || exit 1
bash "$PROFILE_DIR/scripts/run-vm.sh"
