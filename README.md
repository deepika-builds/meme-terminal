# 🔊 meme-terminal

Your terminal, but with meme sounds. Every `git push` hits different when there's a vine boom behind it.

> *Inspired by that one viral video of someone adding the fahh sound to terminal errors. We took it too far.*

## Sound Map

| Command | Sound | Vibe |
|---|---|---|
| `git push` | Dun dun dunnnn | The dramatic push |
| `git pull` | Among Us role reveal | What did your team do? |
| `git commit` | Anime wow | You committed to something |
| `npm run dev` | Ack | Let's gooo |
| `npm install` | Dexter "ooh" | The waiting game |
| `docker build` | Sad violin | You know it's gonna be a while |
| `sudo` | Dun dun dunnnn | You're doing something serious |
| `rm` | Bruh | Are you sure about that? |
| `ssh` | Among Us role reveal | Entering sus territory |
| Any error | Fahh | The classic |
| Typos | Fahh | You had one job |

## Install

```bash
git clone https://github.com/deepika-builds/meme-terminal.git
cd meme-terminal
./install.sh
```

Restart your terminal. That's it — all 9 sounds are included and ready to go.

## Commands

```bash
meme-status          # See your config
meme-test fahh.mp3   # Preview a sound
meme-toggle          # Turn sounds on/off
```

## Customize

### Change which sound plays for which command

Edit `~/meme-terminal/meme.zsh` — find the `MEME_CMD_SOUNDS` block and swap sounds around:

```zsh
MEME_CMD_SOUNDS=(
    git_push      "dun_dun_dun.mp3"
    git_pull      "among_us.mp3"
    git_commit    "anime_wow.mp3"
    npm_run       "ack.mp3"
    npm_install   "dexter.mp3"
    docker_build  "sad_violin.mp3"
    sudo          "dun_dun_dun.mp3"
    rm            "bruh.mp3"
    ssh           "among_us.mp3"
)
```

### Add your own sounds

Drop any `.mp3` into `~/meme-terminal/sounds/` and use the filename in the config above.

### Add more commands

Just add a new line to `MEME_CMD_SOUNDS`. Use underscores for multi-word commands:

```zsh
    cargo_build   "some_sound.mp3"
    python        "another_sound.mp3"
    yarn_install  "dexter.mp3"
```

### Per-command success/error sounds

```zsh
MEME_CMD_COMPLETE_SOUNDS=(
    git_push_0    "success_sound.mp3"   # git push succeeded
    git_push_1    "fail_sound.mp3"      # git push failed
)
```

### Volume (macOS)

```zsh
MEME_VOLUME=0.5  # 0.0 to 1.0
```

## Included sounds

| File | Sound |
|---|---|
| `fahh.mp3` | Fahh |
| `bruh.mp3` | Bruh |
| `anime_wow.mp3` | Anime wow |
| `among_us.mp3` | Among Us role reveal |
| `ack.mp3` | Ack |
| `dexter.mp3` | Dexter meme |
| `sad_violin.mp3` | Sad violin |
| `dun_dun_dun.mp3` | Dun dun dunnnn |
| `punch.mp3` | Punch sound |

## How it works

Two zsh hooks. That's it.

**preexec** fires when you hit Enter — matches your command against the sound map and plays the sound. **precmd** fires when the command finishes — checks exit code, non-zero means error sound. Plus a `command_not_found_handler` for when you fat-finger a command.

## Uninstall

```bash
cd meme-terminal
./uninstall.sh
```

## Requirements

- **zsh** (default on macOS since Catalina)
- **macOS**: Works out of the box via `afplay`
- **Linux**: Needs `pulseaudio` (paplay) or `sox` (play)

## Contribute

PRs welcome. Drop your `.mp3` in `sounds/`, keep it under 500KB, keep it short (1-3 seconds).

## License

MIT