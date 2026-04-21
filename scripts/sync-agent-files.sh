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
    SOURCE_SKILLS="$PROJECT_ROOT/.claude/skills"
    TARGET_CODEX_SKILLS="$PROJECT_ROOT/.agents/skills"
    TARGET_AGENT_SKILLS="$PROJECT_ROOT/.agent/skills"
    DST_WORKFLOWS="$PROJECT_ROOT/.agent/workflows"
    SRC_RULES="$PROJECT_ROOT/.claude/rules"
    DST_RULES="$PROJECT_ROOT/.agent/rules"
    DIRECTION=".claude -> .agent"
else
    SOURCE_SKILLS="$PROJECT_ROOT/.agent/skills"
    TARGET_CLAUDE_SKILLS="$PROJECT_ROOT/.claude/skills"
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

sync_skill_directories() {
    local source_skills_dir="$1"
    local target_skills_dir="$2"
    local label="$3"

    echo "sync: $label"

    if [[ ! -d "$source_skills_dir" ]]; then
        echo "  (no skills directory, skipping)"
        return
    fi

    mkdir -p "$target_skills_dir"
    find "$target_skills_dir" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +

    local copied=0
    for dir in "$source_skills_dir"/*; do
        [[ -d "$dir" ]] || continue
        cp -R "$dir" "$target_skills_dir/"
        copied=$((copied + 1))
        echo "  copied: $(basename "$dir")"
    done

    echo "  result: copied=$copied"
}

sync_skills_to_workflows() {
    local src="$1"
    local dst="$2"
    local copied=0

    echo "sync: skills -> workflows"

    if [[ ! -d "$src" ]]; then
        echo "  (no skills directory, skipping)"
        return
    fi

    find "$dst" -mindepth 1 -maxdepth 1 -type f -name '*.md' -delete

    shopt -s nullglob
    for skill_dir in "$src"/*/; do
        local skill_name
        skill_name="$(basename "$skill_dir")"
        local skill_file="$skill_dir/SKILL.md"

        if [[ ! -f "$skill_file" ]]; then
            continue
        fi

        local target="$dst/${skill_name}.md"

        cp "$skill_file" "$target"
        copied=$((copied + 1))
        echo "  updated: ${skill_name}.md"
    done
    shopt -u nullglob

    echo "  result: copied=$copied"
}

echo "sync start ($DIRECTION)"
sync_markdown_files "$SRC_RULES" "$DST_RULES" "rules (*.md)"
if [[ "$FROM" == "claude" ]]; then
    sync_skill_directories "$SOURCE_SKILLS" "$TARGET_CODEX_SKILLS" "skills -> codex"
    sync_skill_directories "$SOURCE_SKILLS" "$TARGET_AGENT_SKILLS" "skills -> antigravity"
    sync_skills_to_workflows "$SOURCE_SKILLS" "$DST_WORKFLOWS"
else
    sync_skill_directories "$SOURCE_SKILLS" "$TARGET_CLAUDE_SKILLS" "skills -> claude"
fi
echo "sync complete"
