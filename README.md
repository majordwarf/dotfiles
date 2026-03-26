# dotfiles

Modular zsh config that compiles into a single bytecode-optimized file. Plugins are statically bundled, completions are generated at build time, and `compinit` is cached — no runtime overhead.

## Prerequisites

- zsh
- [antidote](https://getantidote.github.io/) (`brew install antidote` or auto-cloned)
- [fzf](https://github.com/junegunn/fzf) (optional)
- [fd](https://github.com/sharkdp/fd) (optional, faster fzf file listing)

## Setup

```zsh
git clone <repo-url> ~/.zsh_seed/dotfiles
zsh ~/.zsh_seed/dotfiles/build.zsh
```

Add to `~/.zshrc`:

```zsh
# p10k instant prompt (must be first, before any output)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.zsh_seed/dotfiles/seed.zsh
```

## Usage

```zsh
seedrebuild            # rebuild everything
seedrebuild -v         # rebuild with verbose output
comprebuild            # rebuild compinit cache (after installing new tools)
```

The build skips automatically if no source files have changed.

## Structure

Source files live in `src/` organized by type — `plugins/`, `utils/`, `alias/`, `functions/`, `p10k/`. The build script (`build.zsh`) assembles them into `seed.zsh`, generates tool completions (docker, kubectl, fzf), caches the completion system, and compiles to bytecode.

Plugins are defined in `src/plugins/plugins.txt`. Heavy plugins load deferred via `zsh-defer` so the prompt renders instantly.

## Environment variables

| Variable | Set by | Description |
|----------|--------|-------------|
| `SEED_DIR` | `seed.zsh` | Absolute path to the dotfiles directory. Used by `seedrebuild` and `comprebuild`. |

## Adding things

- **Alias**: create a `.zsh` file in `src/alias/`
- **Function**: create a `.zsh` file in `src/functions/`
- **Shell option or config**: create a `.zsh` file in `src/utils/`
- **Plugin**: add a line to `src/plugins/plugins.txt`

Then run `seedrebuild`.

> **Note:** Edit `src/p10k/p10k.zsh` directly for prompt changes. Do not run `p10k configure` — it writes to `~/.p10k.zsh` which won't be picked up, or worse, can overwrite `seed.zsh` if sourced from there.

## Troubleshooting

**Build fails with "antidote bundle produced no output"**
Antidote couldn't resolve plugins. Check your internet connection and verify `src/plugins/plugins.txt` has valid plugin names. Run `seedrebuild -v` for detailed output.

**Completions not working for a newly installed tool**
Run `comprebuild` to rebuild the compinit cache. If the tool needs build-time completions (like docker/kubectl), run `seedrebuild` instead.

**Prompt looks broken or shows raw escape codes**
Ensure p10k instant prompt is the very first thing in `~/.zshrc` (before any `echo` or other output). Re-run `seedrebuild` to regenerate.

**Build succeeds but changes aren't reflected**
The build uses a hash to skip when nothing changed. Run `seedrebuild` which force-clears the hash before rebuilding.

**"SEED_DIR is not set" error**
Your `~/.zshrc` isn't sourcing `seed.zsh`, or `seed.zsh` hasn't been built yet. Run `zsh ~/.zsh_seed/dotfiles/build.zsh` manually first.
