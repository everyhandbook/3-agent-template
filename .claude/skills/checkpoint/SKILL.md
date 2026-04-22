---
name: checkpoint
description: Capture a lightweight in-progress checkpoint by summarizing completed work, selecting only related files, recording durable lessons, and making a small local commit. Use when an agent should leave a compact progress handoff without doing a full session wrap-up.
---

# Checkpoint

Use this skill when the work should be left in a cleaner state than a plain status note, but a full `session-wrap-up` would be too heavy.

If `$ARGUMENTS` is present, treat it as the checkpoint scope or topic.

`CHECKPOINT.md` is the **latest handoff snapshot** for the repo. It should stay short and should not become a running history log.

## Execution

1. Summarize what was just completed in 1-3 short lines.
2. Decide which files belong to this checkpoint and explicitly exclude unrelated changes.
3. Update `CHECKPOINT.md` as a current-state snapshot using only these sections:
   - What was just completed
   - What should happen next
   - Files committed or related to this checkpoint
   - Remaining risks
4. Replace stale checkpoint content instead of appending old history.
5. Update only the files that are directly related to the checkpoint.
6. Check `git status` and stage only the selected files.
7. Create a short, clear local commit for those files only.
8. Decide whether `session-wrap-up` is still needed.

## Include In Final Response

- What was just completed
- What should happen next
- Files committed
- Commit hash
- Lessons or repeat-risk patterns worth carrying forward
- Remaining risks

## Guardrails

- Do not include unrelated changes in the commit.
- Do not push unless the user explicitly asks.
- Do not turn `CHECKPOINT.md` into a long-running log. Historical context belongs in `docs/session-logs/`.
- If the work is still too incomplete to commit safely, say that clearly instead of forcing a commit.
