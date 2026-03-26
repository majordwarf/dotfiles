# Create directory and cd into it
mkcd() {
  [[ -z "$1" ]] && { echo "Usage: mkcd <dir>" >&2; return 1; }
  mkdir -p "$1" || { echo "mkcd: failed to create '$1'" >&2; return 1; }
  cd "$1"
}
