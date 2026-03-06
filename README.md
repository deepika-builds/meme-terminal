# 🔊 meme-terminal

Meme sounds for your terminal. Different sounds for different commands.

## Sound Map

| Trigger         | Sound         | File needed            |
|-----------------|---------------|------------------------|
| Error (any cmd) | Fahh          | `sounds/fahh.mp3`     |
| Loading (3s+)   | Romanceeee    | `sounds/romance.mp3`  |
| `git pull`      | Rizz sound    | `sounds/rizz.mp3`     |
| `git push`      | Vine boom     | `sounds/vine_boom.mp3`|
| `git commit`    | Anime wow     | `sounds/anime_wow.mp3`|
| Success         | (optional)    | `sounds/happy.mp3`    |

## Setup

### 1. Copy to your home directory

```bash
cp -r meme-terminal ~/meme-terminal
```

### 2. Add your sound files

Drop `.mp3` files into `~/meme-terminal/sounds/`:

```bash
mkdir -p ~/meme-terminal/sounds

# Then add your files:
# ~/meme-terminal/sounds/fahh.mp3
# ~/meme-terminal/sounds/romance.mp3
# ~/meme-terminal/sounds/rizz.mp3
# ~/meme-terminal/sounds/vine_boom.mp3
# ~/meme-terminal/sounds/anime_wow.mp3
```

**Where to get the sounds:** Download from YouTube/TikTok using any converter, or grab from myinstants.com, voicy.network, etc. Trim to 1-3 seconds for best experience (loading sound can be longer since it loops).

### 3. Source in your .zshrc

```bash
echo 'source ~/meme-terminal/meme.zsh' >> ~/.zshrc
source ~/.zshrc
```

## Commands

| Command | What it does |
|---------|-------------|
| `meme-toggle` | Turn sounds on/off |
| `meme-test <file>` | Preview a sound file |
| `meme-status` | Show current config and check which sounds are found |

## Configuration

Edit `meme.zsh` to customize:

### Add more command sounds

```zsh
MEME_CMD_SOUNDS=(
    git_pull      "rizz.mp3"
    git_push      "vine_boom.mp3"
    git_commit    "anime_wow.mp3"
    npm_install   "bruh.mp3"           # ← add your own
    docker_build  "emotional_damage.mp3" # ← add your own
    cargo_build   "taco_bell.mp3"      # ← add your own
)
```

### Per-command completion sounds

```zsh
MEME_CMD_COMPLETE_SOUNDS=(
    git_push_0   "sheesh.mp3"          # git push success
    git_push_1   "windows_xp_error.mp3" # git push error
)
```

### Adjust loading delay

```zsh
MEME_LOADING_DELAY=3  # seconds before loading sound starts
```

### Adjust volume (macOS only)

```zsh
MEME_VOLUME=0.5  # 0.0 to 1.0
```

## How it works

1. **preexec hook** — fires when you hit Enter on a command
   - Checks if the command matches a specific sound → plays it
   - Starts a background timer; if command runs longer than `MEME_LOADING_DELAY`, loops the loading sound
2. **precmd hook** — fires when the command finishes
   - Kills any loading sounds
   - Checks exit code → plays error or success sound

## Troubleshooting

**No sound playing?**
- Run `meme-status` to check if sound files are found
- Run `meme-test fahh.mp3` to test a specific file
- Check that `afplay` works: `afplay ~/meme-terminal/sounds/fahh.mp3`

**Sounds overlap weirdly?**
- Trim your sound files to 1-2 seconds
- Increase `MEME_LOADING_DELAY` if loading sound kicks in too early

**Want to disable temporarily?**
- Run `meme-toggle` or set `MEME_ENABLED=false`

## Platform support

- **macOS:** Works out of the box via `afplay`
- **Linux:** Needs `pulseaudio` (paplay) or `sox` (play) installed
- **Shell:** Requires `zsh` (default on macOS since Catalina)
