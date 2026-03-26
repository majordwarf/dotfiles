# Quick find file by name (uses fd if available, falls back to find)
ff() {
  [[ -z "$1" ]] && { echo "Usage: ff <pattern>" >&2; return 1; }
  if (( $+commands[fd] )); then
    fd --type f "$1"
  else
    find . -type f -name "*$1*"
  fi
}
