#!/usr/bin/env zsh
setopt err_exit pipe_fail

# ==============================================================================
# Paths
# ==============================================================================

SCRIPT_DIR="${0:A:h}"
SRC="$SCRIPT_DIR/src"
OUT="$SCRIPT_DIR/seed.zsh"
HASH_FILE="$SCRIPT_DIR/.seed.hash"
ZCOMPDUMP="$SCRIPT_DIR/.zcompdump"
PLUGINS_TXT="$SRC/plugins/plugins.txt"
TOOL_COMPLETIONS="$SCRIPT_DIR/.tool-completions.zsh"

# Temp artifacts (cleaned up at end)
_PLUGINS_RAW="$SCRIPT_DIR/.plugins.raw.zsh"
_COMPLETIONS="$SCRIPT_DIR/.completions.zsh"

VERBOSE=0
[[ "${1:-}" == "-v" || "${1:-}" == "--verbose" ]] && VERBOSE=1

log() { (( VERBOSE )) && echo "  $1" || true }

cleanup() { rm -f "$_PLUGINS_RAW" "$_COMPLETIONS" }
trap cleanup EXIT

# ==============================================================================
# Change detection — skip build if nothing changed
# ==============================================================================

compute_hash() {
  { cat "$SCRIPT_DIR/build.zsh"
    print -rl -- "$SRC"/**/*(.N) | sort | xargs cat
  } | shasum | awk '{print $1}'
}

current_hash="$(compute_hash)"

if [[ "$current_hash" == "$(cat "$HASH_FILE" 2>/dev/null)" ]]; then
  exit 0
fi

echo "🔨 Building zsh bundle..."

# ==============================================================================
# Helpers
# ==============================================================================

if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
fi

# Resolve a .plugin.zsh wrapper (<=2 lines) to the real file it sources.
resolve_plugin_path() {
  local path="$1"
  [[ ! -f "$path" ]] && { echo "$path"; return }

  local content="$(<"$path")"
  local -a lines=("${(@f)content}")
  (( ${#lines} > 2 )) && { echo "$path"; return }

  local after="${content##*source }"
  after="${after//\'/}"
  after="${after//\"/}"
  [[ "$after" == "$content" ]] && { echo "$path"; return }

  local dir="${path:h}"
  after="${after//\$\{0:A:h\}/$dir}"
  after="${after//\$\{POWERLEVEL9K_INSTALLATION_DIR:-\$\{\$\{(%):-%x\}:A:h\}\}/$dir}"

  [[ -f "$after" ]] && echo "$after" || echo "$path"
}

# Compile a file to .zwc if not already compiled
ensure_compiled() {
  [[ -f "$1" && ! -f "${1}.zwc" ]] && zcompile -R "${1}.zwc" "$1" 2>/dev/null
  return 0
}

# ==============================================================================
# Step 1: Bundle plugins via antidote
# ==============================================================================

if [[ -n "$BREW_PREFIX" ]] && [[ -f "$BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh" ]]; then
  source "$BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh"
else
  ANTIDOTE_HOME="${ZDOTDIR:-$HOME}/.antidote"
  [[ ! -d "$ANTIDOTE_HOME" ]] && git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
  source "$ANTIDOTE_HOME/antidote.zsh"
fi

antidote bundle < "$PLUGINS_TXT" > "$_PLUGINS_RAW"
if [[ ! -s "$_PLUGINS_RAW" ]]; then
  echo "❌ antidote bundle produced no output" >&2
  exit 1
fi
log "antidote bundle OK"

# ==============================================================================
# Step 2: Generate tool completions (docker, kubectl, fzf)
# ==============================================================================

: > "$_COMPLETIONS"
local -a _comp_warnings=()
(( $+commands[docker] ))  && { print "\n# docker";  docker completion zsh 2>/dev/null || _comp_warnings+=(docker)  } >> "$_COMPLETIONS"
(( $+commands[kubectl] )) && { print "\n# kubectl"; kubectl completion zsh 2>/dev/null || _comp_warnings+=(kubectl) } >> "$_COMPLETIONS"
(( $+commands[fzf] ))     && { print "\n# fzf";     fzf --zsh 2>/dev/null             || _comp_warnings+=(fzf)     } >> "$_COMPLETIONS"
if (( ${#_comp_warnings} )); then
  echo "⚠️  Completion generation failed for: ${(j:, :)_comp_warnings}" >&2
fi
log "tool completions OK"

# ==============================================================================
# Step 3: Process plugin bundle — hardcode paths, dedupe, resolve wrappers
# ==============================================================================

local -a fpaths=() plugin_lines=()
local -A seen_fpaths=() seen_sources=()
local line p expanded src resolved

while IFS= read -r line; do
  # Collect fpath entries into a single deduplicated call
  if [[ "$line" == *'fpath+=('* ]]; then
    p="${line%\"*}"; p="${p##*\"}"; p="${(e)p}"
    [[ -z "${seen_fpaths[$p]}" ]] && { seen_fpaths[$p]=1; fpaths+=("$p") }
    continue
  fi

  # Process source lines
  if [[ "$line" == *source\ * ]]; then
    expanded="${line//\$HOME/$HOME}"
    src="${expanded##*source }"; src="${src//\"/}"

    # Drop the powerlevel9k shim (just re-sources powerlevel10k)
    [[ "$src" == *powerlevel9k.zsh-theme* ]] && continue
    # Deduplicate
    [[ -n "${seen_sources[$src]}" ]] && continue
    seen_sources[$src]=1

    # Resolve thin wrappers to the real file
    resolved="$(resolve_plugin_path "$src")"
    if [[ "$resolved" != "$src" ]]; then
      seen_sources[$resolved]=1
      ensure_compiled "$resolved"
      src="$resolved"
    fi
    ensure_compiled "$src"

    # Rebuild the source line with quoted path
    if [[ "$line" == *zsh-defer\ source* ]]; then
      plugin_lines+=("zsh-defer source \"$src\"")
    else
      plugin_lines+=("source \"$src\"")
    fi
    continue
  fi

  # Everything else (conditionals, etc.) — just hardcode $HOME
  plugin_lines+=("${line//\$HOME/$HOME}")
done < "$_PLUGINS_RAW"

# ==============================================================================
# Step 4: Build compinit cache
# ==============================================================================

eval "$(grep '^fpath+=' "$_PLUGINS_RAW")"
autoload -Uz compinit
compinit -d "$ZCOMPDUMP"
# Re-run after sourcing tool completions so the dump includes them
[[ -s "$_COMPLETIONS" ]] && source "$_COMPLETIONS"
compinit -d "$ZCOMPDUMP"
zcompile -R "$ZCOMPDUMP.zwc" "$ZCOMPDUMP" || { echo "❌ Failed to compile zcompdump" >&2; exit 1; }
log "compinit cache OK"

# ==============================================================================
# Step 5: Assemble seed.zsh
# ==============================================================================

{
  # Header
  print -r "# GENERATED FILE - DO NOT EDIT"
  print -r "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true"
  print -r "SEED_DIR=$SCRIPT_DIR"

  # Plugins
  print "\n# --- plugins ---"
  for line in "${plugin_lines[@]}"; do
    print -r -- "$line"
  done
  print -r "fpath+=( ${(j: :)${(@qq)fpaths}} )"

  # Completion system — deferred to after first prompt (saves ~15ms)
  # zsh-defer fires on first zle idle, before user can press tab
  print "\n# --- compinit (deferred) ---"
  if [[ -s "$_COMPLETIONS" ]]; then
    print -r "zsh-defer -c 'autoload -Uz compinit; compinit -C -d $ZCOMPDUMP; source $TOOL_COMPLETIONS'"
  else
    print -r "zsh-defer -c 'autoload -Uz compinit; compinit -C -d $ZCOMPDUMP'"
  fi

  # User config (utils, aliases, functions, prompt)
  # Files load in alphabetical order within each directory.
  # Use numeric prefixes (e.g., 00-foo.zsh) to control order.
  for dir in utils alias functions p10k; do
    for file in "$SRC/$dir"/*.zsh(N); do
      print "\n# --- ${file#$SRC/} ---"
      cat "$file"
    done
  done
} > "$OUT"

# ==============================================================================
# Step 6: Compile & finalize
# ==============================================================================

zcompile -R "$OUT.zwc" "$OUT" || { echo "❌ Failed to compile seed.zsh" >&2; exit 1; }
log "seed.zsh compiled OK"

# Save tool completions for deferred loading, or clean stale file
if [[ -s "$_COMPLETIONS" ]]; then
  cp "$_COMPLETIONS" "$TOOL_COMPLETIONS"
  zcompile -R "$TOOL_COMPLETIONS.zwc" "$TOOL_COMPLETIONS" || { echo "❌ Failed to compile tool completions" >&2; exit 1; }
  log "tool completions compiled OK"
else
  rm -f "$TOOL_COMPLETIONS" "$TOOL_COMPLETIONS.zwc"
fi

# Write hash only after everything succeeded
print -r -- "$current_hash" > "$HASH_FILE"

echo "✅ Build complete"
