#!/usr/bin/env zsh
# ┌──────────────────────────────────────────┐
# │  🔊 meme-terminal                        │
# │  meme sounds for your terminal            │
# │  https://github.com/user/meme-terminal    │
# └──────────────────────────────────────────┘
# Source this file in your .zshrc:
#   source ~/meme-terminal/meme.zsh

MEME_DIR="${0:A:h}"
MEME_SOUNDS_DIR="$MEME_DIR/sounds"
MEME_ENABLED=true
MEME_VOLUME=1.0  # 0.0 to 1.0 (macOS afplay only)

# ─── SOUND MAPPINGS ─────────────────────────────────────────
# Command → sound (fires when you run the command)
# Key format: first two words joined by underscore
# e.g. "git push -f origin main" matches "git_push"
typeset -gA MEME_CMD_SOUNDS
MEME_CMD_SOUNDS=(
    git_push      "dun_dun_dun.mp3"
    git_pull      "among_us.mp3"
    git_commit    "anime_wow.mp3"
    npm_run       "ack.mp3"
    npm_install   "dexter.mp3"
    yarn_install  "dexter.mp3"
    docker_build  "sad_violin.mp3"
    sudo          "dun_dun_dun.mp3"
    rm            "bruh.mp3"
    ssh           "among_us.mp3"
)

# Per-command completion overrides (optional)
# Format: commandkey_exitcode → sound
typeset -gA MEME_CMD_COMPLETE_SOUNDS
MEME_CMD_COMPLETE_SOUNDS=(
    # Example:
    # git_push_0    "success.mp3"
    # git_push_1    "fail.mp3"
)

# Default sounds (fallback for any command)
typeset -gA MEME_DEFAULT_SOUNDS
MEME_DEFAULT_SOUNDS=(
    error   "fahh.mp3"
)

# ─── INTERNALS ──────────────────────────────────────────────
typeset -g _MEME_LAST_CMD=""

_meme_play() {
    local sound_file="$1"
    [[ "$MEME_ENABLED" != true ]] && return
    [[ ! -f "$MEME_SOUNDS_DIR/$sound_file" ]] && return

    if [[ "$(uname)" == "Darwin" ]]; then
        { afplay -v "$MEME_VOLUME" "$MEME_SOUNDS_DIR/$sound_file" 2>/dev/null & } 2>/dev/null
    else
        if command -v paplay &>/dev/null; then
            { paplay "$MEME_SOUNDS_DIR/$sound_file" 2>/dev/null & } 2>/dev/null
        elif command -v play &>/dev/null; then
            { play -q "$MEME_SOUNDS_DIR/$sound_file" 2>/dev/null & } 2>/dev/null
        fi
    fi
}

_meme_get_cmd_key() {
    local cmd="$1"
    local word1 word2
    word1=$(echo "$cmd" | awk '{print $1}')
    word2=$(echo "$cmd" | awk '{print $2}')

    [[ "$word2" == -* ]] && word2=""

    if [[ -n "$word2" ]]; then
        local two_word="${word1}_${word2}"
        if [[ -n "${MEME_CMD_SOUNDS[$two_word]}" ]]; then
            echo "$two_word"
            return
        fi
    fi

    if [[ -n "${MEME_CMD_SOUNDS[$word1]}" ]]; then
        echo "$word1"
        return
    fi

    echo ""
}

# ─── HOOKS ──────────────────────────────────────────────────

# Fires BEFORE a command runs
_meme_preexec() {
    local cmd="$1"
    _MEME_LAST_CMD="$cmd"
    [[ "$MEME_ENABLED" != true ]] && return

    local cmd_key=$(_meme_get_cmd_key "$cmd")
    if [[ -n "$cmd_key" ]]; then
        _meme_play "${MEME_CMD_SOUNDS[$cmd_key]}"
    fi
}

# Fires AFTER a command completes
_meme_precmd() {
    local exit_code=$?
    [[ "$MEME_ENABLED" != true ]] && return
    [[ -z "$_MEME_LAST_CMD" ]] && return

    local cmd_key=$(_meme_get_cmd_key "$_MEME_LAST_CMD")
    local exit_key="${cmd_key}_${exit_code}"

    if [[ -n "$cmd_key" && -n "${MEME_CMD_COMPLETE_SOUNDS[$exit_key]}" ]]; then
        _meme_play "${MEME_CMD_COMPLETE_SOUNDS[$exit_key]}"
    elif [[ $exit_code -ne 0 ]]; then
        _meme_play "${MEME_DEFAULT_SOUNDS[error]}"
    fi

    _MEME_LAST_CMD=""
}

# Fires on "command not found" (typos)
command_not_found_handler() {
    echo "zsh: command not found: $1" >&2
    _meme_play "${MEME_DEFAULT_SOUNDS[error]}"
    return 127
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _meme_preexec
add-zsh-hook precmd _meme_precmd

# ─── USER COMMANDS ──────────────────────────────────────────

meme-toggle() {
    if [[ "$MEME_ENABLED" == true ]]; then
        MEME_ENABLED=false
        echo "🔇 Meme sounds OFF"
    else
        MEME_ENABLED=true
        echo "🔊 Meme sounds ON"
    fi
}

meme-test() {
    local sound="$1"
    if [[ -z "$sound" ]]; then
        echo "Available sounds:"
        ls "$MEME_SOUNDS_DIR" 2>/dev/null | grep -v '.gitkeep' | sed 's/^/  /'
        echo ""
        echo "Usage: meme-test <filename>"
        return
    fi
    echo "🔊 Playing: $sound"
    _meme_play "$sound"
}

meme-status() {
    echo ""
    echo "  🔊 meme-terminal"
    echo "  ─────────────────"
    echo "  Enabled:    $MEME_ENABLED"
    echo "  Volume:     $MEME_VOLUME"
    echo "  Sounds dir: $MEME_SOUNDS_DIR"
    echo ""
    echo "  Command sounds:"
    for key val in "${(@kv)MEME_CMD_SOUNDS}"; do
        printf "    %-15s → %s\n" "$key" "$val"
    done
    echo ""
    echo "  Error sound: ${MEME_DEFAULT_SOUNDS[error]}"
    echo ""
    echo "  Sound files:"
    if [[ -d "$MEME_SOUNDS_DIR" ]]; then
        ls "$MEME_SOUNDS_DIR" 2>/dev/null | grep -v '.gitkeep' | sed 's/^/    /'
    else
        echo "    ⚠ Sounds directory not found!"
    fi
    echo ""
}

# ─── STARTUP ────────────────────────────────────────────────
echo "🔊 meme-terminal loaded — run 'meme-status' for config"
