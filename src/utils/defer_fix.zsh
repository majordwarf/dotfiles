# Kill only zsh-defer's lingering zselect subprocesses on exit,
# preserving warnings for user-spawned background jobs

zshexit() {
  local pid
  for pid in ${${(v)jobstates#*:*:}%=*}; do
    [[ "$(ps -o command= -p $pid 2>/dev/null)" == *zselect* ]] && kill -TERM $pid 2>/dev/null
  done
}
