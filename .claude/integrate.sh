#!/bin/bash
# SYSTEM INTEGRATION
# Run this to enable everything

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  🤖 RAGS Advanced System Integration (March 2026)            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
cd ~

# 1. Add to shell profile
SHELL_FILE="$HOME/.zshrc"
if ! grep -q "RAGS_AUTO_RESUME" "$SHELL_FILE" 2>/dev/null; then
    cat >> "$SHELL_FILE" << 'EOF'

# RAGS Advanced System (March 2026)
export RAGS_AUTO_RESUME=1

# Fast start (sub-100ms)
[ -f ~/.claude/fast-start.sh ] && source ~/.claude/fast-start.sh

# Auto-resume on folder enter
[ -f ~/.claude/auto-resume.sh ] && ~/.claude/auto-resume.sh

# Check for crash recovery
if [ -f ~/.claude/.session_active ]; then
    echo "🔴 CRASH RECOVERY: Run ~/.claude/checkpoint.sh resume"
fi
EOF
    echo "✅ Added to $SHELL_FILE"
fi

# 2. Start background checkpoint daemon
echo "Starting checkpoint daemon..."
nohup ~/.claude/checkpoint.sh auto > /dev/null 2>&1 &
echo "✅ Checkpoint daemon PID: $!"

# 3. Clear old agents
echo "Cleaning old agents..."
rm -f ~/.claude/agents/*

# 4. Spawn initial agents
~/.claude/agentd.sh spawn cache-update "Update git cache" low &
echo "✅ Background agents spawned"

# 5. Set up cron for periodic self-analysis
# Run self-improve every 6 hours
(crontab -l 2>/dev/null | grep -v self-improve; echo "0 */6 * * * cd ~ && python3 ~/.claude/self-improve.py >> ~/.claude/telemetry/self-improve.log 2>&1") | crontab -
echo "✅ Self-improvement cron set (every 6 hours)"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🚀 System Ready! Next steps:"
echo "   1. source ~/.zshrc  (or open new terminal)"
echo "   2. Navigate to any project → auto-resume works"
echo "   3. Use: ~/.claude/agentd.sh status"
echo "   4. View: cat ~/.claude/memory/GLOBAL_JOURNAL.md"
echo ""
echo "════════════════════════════════════════════════════════════════"
