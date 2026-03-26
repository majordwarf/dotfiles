# Quick HTTP server in current directory
serve() {
  local port="${1:-8000}"
  if (( $+commands[python3] )); then
    echo "Serving on http://127.0.0.1:$port"
    python3 -m http.server --bind 127.0.0.1 "$port"
  else
    echo "serve: requires python3" >&2
    return 1
  fi
}
