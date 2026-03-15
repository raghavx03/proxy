#!/bin/bash
# Resume Engine - Triggered on folder open
# Auto-detects and suggests last work state

RESUME_SCRIPT="resumable"

check_resume() {
    local pwd=$(pwd)
    local journal="$HOME/.claude/memory/GLOBAL_JOURNAL.md"
    local state_file="$pwd/.claude/LAST_STATE.md"

    # Check for crash
    local crash_detected=$(~/.claude/checkpoint.sh status | head -1)

    if [ "$crash_detected" = "CRASH_DETECTED" ]; then
        echo "🔴 CRASH RECOVERY DETECTED"
        echo ""
        echo "Last checkpoint:"
        tail -20 "$journal" | grep -A5 "CHECKPOINT" | tail -15
        echo ""
        echo "Recovery commands:"
        echo "  ~/.claude/checkpoint.sh resume    # Show details"
        echo "  git status                         # Check changes"
        echo ""
        return 0
    fi

    # Check for existing project state
    if [ -f "$state_file" ]; then
        echo "📂 PROJECT STATE FOUND:"
        cat "$state_file"
        echo ""
        return 0
    fi

    # Show last work in this folder
    local last_work=$(grep -A10 "$(basename $pwd)" "$journal" 2>/dev/null | tail -15)
    if [ ! -z "$last_work" ]; then
        echo "📝 LAST ACTIVITY HERE:"
        echo "$last_work"
        echo ""
    fi

    echo "✅ Clean state - Start fresh or use: resume-session"
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    check_resume
fi
