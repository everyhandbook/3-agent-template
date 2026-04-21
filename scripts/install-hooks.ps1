# Install repo-managed git hooks from .githooks/.
# Run once per clone. Safe to re-run.

$ErrorActionPreference = "Stop"

$RepoRoot = (& git rev-parse --show-toplevel).Trim()
Set-Location $RepoRoot

& git config core.hooksPath .githooks

Write-Host "installed: core.hooksPath=.githooks"
Write-Host "hooks:"
Get-ChildItem .githooks | Select-Object -ExpandProperty Name
