# Rebuild dotfiles
seedrebuild() {
  if [[ -z "$SEED_DIR" || ! -d "$SEED_DIR" ]]; then
    echo "seedrebuild: SEED_DIR is not set or doesn't exist" >&2
    return 1
  fi
  rm -f "$SEED_DIR/.seed.hash"
  zsh "$SEED_DIR/build.zsh" "$@" || { echo "❌ Build failed" >&2; return 1; }
}
