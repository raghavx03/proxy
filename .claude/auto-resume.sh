#!/bin/bash
# AUTO-RESUME SYSTEM
# Add this to your shell profile (.zshrc) for automatic detection

auto_resume_check() {
    # Only run if we're in an interactive shell AND have .claude folder
    if [ -d ".claude" ] && [ -f ".claude/STATE.md" ]; then
        echo ""
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║  🤖 RAGS - Last Session Recovery                         ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo ""

        # Check for crash
        if [ -f "$HOME/.claude/.session_active" ]; then
            echo "🔴 CRASH DETECTED - Previous session was interrupted!"
            echo ""
            echo "Recovery Data:"
            ~/.claude/checkpoint.sh resume
            echo ""
            echo "To recover: resume or see STATE.md below"
        fi

        # Show project state
        echo "📂 PROJECT: $(basename $(pwd))"
        echo ""
        echo "Last Session:"
        grep "Focus:" .claude/STATE.md | head -1
        grep "Status:" .claude/STATE.md | head -1
        echo ""

        # Show last actions
        echo "Recent Actions:"
        grep "^\d\." .claude/STATE.md | tail -5
        echo ""

        # Show next steps
        echo "Next Steps:"
        sed -n '/## Next Steps/,/##/p' .claude/STATE.md | grep -E "^\d\." | tail -3
        echo ""
        echo "════════════════════════════════════════════════════════════"
        echo ""

        # Clear crash marker after showing
        rm -f "$HOME/.claude/.session_active"
    fi
}

# Export function for shell use
export -f auto_resume_check 2>/dev/null

# Auto-run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    auto_resume_check
fi
