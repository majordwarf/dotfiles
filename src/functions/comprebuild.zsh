# Rebuild compinit cache (includes tool completions)
comprebuild() {
  local dump="$SEED_DIR/.zcompdump"
  local tc="$SEED_DIR/.tool-completions.zsh"
  rm -f "$dump" "$dump.zwc"
  autoload -Uz compinit
  compinit -d "$dump"
  [[ -f "$tc" ]] && source "$tc"
  compinit -d "$dump"
  zcompile -R "$dump.zwc" "$dump"
  echo "✅ compinit cache rebuilt"
}
