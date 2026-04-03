#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  ./scripts/sync-agent-files.sh [--from claude|agent]

Options:
  --from claude   Default. Sync .claude -> .agent
  --from agent    Recovery mode. Sync .agent -> .claude
EOF
}

FROM="claude"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --from)
            shift
            if [[ $# -eq 0 ]]; then
                echo "error: --from requires a value (claude|agent)" >&2
                exit 2
            fi
            FROM="$1"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument: $1" >&2
            usage
            exit 2
            ;;
    esac
    shift
done

if [[ "$FROM" != "claude" && "$FROM" != "agent" ]]; then
    echo "error: --from must be 'claude' or 'agent'" >&2
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ "$FROM" == "claude" ]]; then
    SRC_COMMANDS="$PROJECT_ROOT/.claude/commands"
    DST_WORKFLOWS="$PROJECT_ROOT/.agent/workflows"
    SRC_RULES="$PROJECT_ROOT/.claude/rules"
    DST_RULES="$PROJECT_ROOT/.agent/rules"
    DIRECTION=".claude -> .agent"
else
    SRC_COMMANDS="$PROJECT_ROOT/.agent/workflows"
    DST_WORKFLOWS="$PROJECT_ROOT/.claude/commands"
    SRC_RULES="$PROJECT_ROOT/.agent/rules"
    DST_RULES="$PROJECT_ROOT/.claude/rules"
    DIRECTION=".agent -> .claude (recovery mode)"
fi

mkdir -p "$DST_WORKFLOWS" "$DST_RULES"

sync_markdown_files() {
    local src="$1"
    local dst="$2"
    local label="$3"
    local copied=0
    local unchanged=0

    echo "sync: $label"

    if [[ ! -d "$src" ]]; then
        echo "error: source directory not found: $src" >&2
        exit 1
    fi

    shopt -s nullglob
    for file in "$src"/*.md; do
        local filename
        filename="$(basename "$file")"
        local target="$dst/$filename"

        if [[ -f "$target" ]] && cmp -s "$file" "$target"; then
            unchanged=$((unchanged + 1))
            continue
        fi

        cp "$file" "$target"
        copied=$((copied + 1))
        echo "  updated: $filename"
    done
    shopt -u nullglob

    echo "  result: copied=$copied unchanged=$unchanged"
}

sync_skills_to_workflows() {
    local src="$1"
    local dst="$2"
    local copied=0
    local unchanged=0

    echo "sync: skills -> workflows"

    if [[ ! -d "$src" ]]; then
        echo "  (no skills directory, skipping)"
        return
    fi

    shopt -s nullglob
    for skill_dir in "$src"/*/; do
        local skill_name
        skill_name="$(basename "$skill_dir")"
        local skill_file="$skill_dir/SKILL.md"

        if [[ ! -f "$skill_file" ]]; then
            continue
        fi

        local target="$dst/${skill_name}.md"

        if [[ -f "$target" ]] && cmp -s "$skill_file" "$target"; then
            unchanged=$((unchanged + 1))
            continue
        fi

        cp "$skill_file" "$target"
        copied=$((copied + 1))
        echo "  updated: ${skill_name}.md"
    done
    shopt -u nullglob

    echo "  result: copied=$copied unchanged=$unchanged"
}

echo "sync start ($DIRECTION)"
sync_markdown_files "$SRC_COMMANDS" "$DST_WORKFLOWS" "commands/workflows (*.md)"
sync_markdown_files "$SRC_RULES" "$DST_RULES" "rules (*.md)"
if [[ "$FROM" == "claude" ]]; then
    sync_skills_to_workflows "$PROJECT_ROOT/.claude/skills" "$DST_WORKFLOWS"
fi
echo "sync complete"
