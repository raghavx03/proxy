#!/bin/bash
# Universal Checkpoint System for Claude Code
# Saves state every 2 minutes + on shutdown

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOURNAL_FILE="$HOME/.claude/memory/GLOBAL_JOURNAL.md"
PID_FILE="$HOME/.claude/.checkpoint.pid"
CURRENT_DIR_FILE="$HOME/.claude/.current_project"

checkpoint() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S %Z')
    local pwd=$(pwd)
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-git")
    local git_commit=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
    local last_status="ACTIVE"

    # Check for incomplete markers
    if [ -f "$HOME/.claude/.session_active" ]; then
        last_status="CRASH_RECOVERED"
    fi

    # Save current project
    echo "$pwd" > "$CURRENT_DIR_FILE"
    echo "$timestamp" >> "$CURRENT_DIR_FILE"

    # Update journal with checkpoint
    cat >> "$JOURNAL_FILE" << EOF

### CHECKPOINT: $timestamp
**Location:** $pwd
**Branch:** $git_branch ($git_commit)
**Status:** $last_status
**Process:** $$
---
EOF

    # Mark session as active
    touch "$HOME/.claude/.session_active"
    echo "Checkpoint saved: $timestamp | $pwd"
}

# Auto-checkpoint every 120 seconds
auto_checkpoint() {
    while true; do
        sleep 120
        checkpoint
    done
}

# On shutdown - final save
shutdown_save() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S %Z')
    local pwd=$(cat "$CURRENT_DIR_FILE" | head -1)

    # Mark as complete (not crashed)
    rm -f "$HOME/.claude/.session_active"

    cat >> "$JOURNAL_FILE" << EOF

### SHUTDOWN: $timestamp
**Location:** $pwd
**Status:** ✅ GRACEFUL_EXIT
**Recovery:** Not needed
---
EOF
    exit 0
}

# Main
case "${1:-checkpoint}" in
    checkpoint)
        checkpoint
        ;;
    auto)
        echo $$ > "$PID_FILE"
        auto_checkpoint
        ;;
    shutdown)
        shutdown_save
        ;;
    status)
        if [ -f "$HOME/.claude/.session_active" ]; then
            echo "CRASH_DETECTED"
            cat "$CURRENT_DIR_FILE" 2>/dev/null || echo "No recovery data"
        else
            echo "CLEAN_STATE"
        fi
        ;;
    resume)
        # Show recovery suggestion
        if [ -f "$CURRENT_DIR_FILE" ]; then
            last_dir=$(head -1 "$CURRENT_DIR_FILE")
            last_time=$(tail -1 "$CURRENT_DIR_FILE")
            echo "Last active: $last_dir at $last_time"
        fi
        ;;
esac
