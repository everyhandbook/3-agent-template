#!/usr/bin/env bash
# Install repo-managed git hooks from .githooks/.
# Run once per clone. Safe to re-run.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "installed: core.hooksPath=.githooks"
echo "hooks:"
ls -1 .githooks
