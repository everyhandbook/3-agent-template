[CmdletBinding()]
param(
    [ValidateSet("claude", "agent")]
    [string]$From = "claude"
)

$ErrorActionPreference = "Stop"

function Sync-MarkdownFiles {
    param(
        [Parameter(Mandatory = $true)][string]$SourceDir,
        [Parameter(Mandatory = $true)][string]$TargetDir,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) {
        throw "Source directory not found: $SourceDir"
    }

    if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    Write-Output "sync: $Label"

    $copied = 0
    $unchanged = 0

    $files = Get-ChildItem -LiteralPath $SourceDir -File -Filter "*.md"
    foreach ($file in $files) {
        $targetPath = Join-Path $TargetDir $file.Name

        if (Test-Path -LiteralPath $targetPath -PathType Leaf) {
            $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
            if ($sourceHash -eq $targetHash) {
                $unchanged++
                continue
            }
        }

        Copy-Item -LiteralPath $file.FullName -Destination $targetPath -Force
        $copied++
        Write-Output ("  updated: {0}" -f $file.Name)
    }

    Write-Output ("  result: copied={0} unchanged={1}" -f $copied, $unchanged)
}

$scriptDir = Split-Path -Parent $PSCommandPath
$projectRoot = Split-Path -Parent $scriptDir

if ($From -eq "claude") {
    $sourceCommands = Join-Path $projectRoot ".claude/commands"
    $targetWorkflows = Join-Path $projectRoot ".agent/workflows"
    $sourceRules = Join-Path $projectRoot ".claude/rules"
    $targetRules = Join-Path $projectRoot ".agent/rules"
    $direction = ".claude -> .agent"
}
else {
    $sourceCommands = Join-Path $projectRoot ".agent/workflows"
    $targetWorkflows = Join-Path $projectRoot ".claude/commands"
    $sourceRules = Join-Path $projectRoot ".agent/rules"
    $targetRules = Join-Path $projectRoot ".claude/rules"
    $direction = ".agent -> .claude (recovery mode)"
}

function Sync-SkillsToWorkflows {
    param(
        [Parameter(Mandatory = $true)][string]$SourceSkillsDir,
        [Parameter(Mandatory = $true)][string]$TargetDir
    )

    Write-Output "sync: skills -> workflows"

    if (-not (Test-Path -LiteralPath $SourceSkillsDir -PathType Container)) {
        Write-Output "  (no skills directory, skipping)"
        return
    }

    $copied = 0
    $unchanged = 0

    $skillDirs = Get-ChildItem -LiteralPath $SourceSkillsDir -Directory
    foreach ($skillDir in $skillDirs) {
        $skillFile = Join-Path $skillDir.FullName "SKILL.md"

        if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
            continue
        }

        $targetPath = Join-Path $TargetDir "$($skillDir.Name).md"

        if (Test-Path -LiteralPath $targetPath -PathType Leaf) {
            $sourceHash = (Get-FileHash -LiteralPath $skillFile -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
            if ($sourceHash -eq $targetHash) {
                $unchanged++
                continue
            }
        }

        Copy-Item -LiteralPath $skillFile -Destination $targetPath -Force
        $copied++
        Write-Output ("  updated: {0}.md" -f $skillDir.Name)
    }

    Write-Output ("  result: copied={0} unchanged={1}" -f $copied, $unchanged)
}

Write-Output ("sync start ({0})" -f $direction)
Sync-MarkdownFiles -SourceDir $sourceCommands -TargetDir $targetWorkflows -Label "commands/workflows (*.md)"
Sync-MarkdownFiles -SourceDir $sourceRules -TargetDir $targetRules -Label "rules (*.md)"
if ($From -eq "claude") {
    $sourceSkills = Join-Path $projectRoot ".claude/skills"
    Sync-SkillsToWorkflows -SourceSkillsDir $sourceSkills -TargetDir $targetWorkflows
}
Write-Output "sync complete"
