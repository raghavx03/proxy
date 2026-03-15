#!/bin/bash
# FAST START SYSTEM - Sub-100ms response

FAST_STATE="$HOME/.claude/.fast_state"
PROJECT_CACHE="$HOME/.claude/.project_cache"

# Cache project info every 30s
cache_project() {
    local pwd=$(pwd)
    echo "PWD:$pwd" > "$PROJECT_CACHE"
    echo "TIME:$(date +%s)" >> "$PROJECT_CACHE"
    
    # Fast git info (cached)
    git rev-parse --abbrev-ref HEAD 2>/dev/null >> "$PROJECT_CACHE"
    
    # Check for state file
    if [ -f ".claude/STATE.md" ]; then
        echo "HAS_STATE:yes" >> "$PROJECT_CACHE"
        head -5 .claude/STATE.md >> "$PROJECT_CACHE"
    fi
}

# Show cached info instantly (no blocking)
fast_greeting() {
    echo ""
    if [ -f "$PROJECT_CACHE" ]; then
        local cached_time=$(grep "TIME:" "$PROJECT_CACHE" | cut -d: -f2)
        local now=$(date +%s)
        local diff=$((now - cached_time))
        
        if [ $diff -lt 60 ]; then
            # Cache fresh (< 1 min)
            local project=$(grep "PWD:" "$PROJECT_CACHE" | cut -d: -f2-)
            echo "⚡ [${diff}s ago] 📂 $(basename $project)"
        fi
    fi
    echo ""
}

# Background agent starter
start_background_agents() {
    # These run WITHOUT blocking main thread
    (
        # Agent 1: Update cache
        cache_project &
        
        # Agent 2: Check git status  
        (git status --porcelain > "$HOME/.claude/.git_status.txt" 2>/dev/null &)
        
        # Agent 3: Pre-load context
        (head -50 .claude/STATE.md > "$HOME/.claude/.state_preview.txt" 2>/dev/null &)
        
    ) &
}

# Export for shell integration
export -f fast_greeting cache_project start_background_agents 2>/dev/null

