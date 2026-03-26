# Find what's using a port
whichport() {
  if [[ -z "$1" ]]; then
    echo "Usage: whichport <port>" >&2
    return 1
  fi
  if (( $+commands[lsof] )); then
    lsof -i :"$1" -P -n
  elif (( $+commands[ss] )); then
    ss -tlnp | grep ":$1 "
  else
    echo "whichport: requires lsof or ss" >&2
    return 1
  fi
}
