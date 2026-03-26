HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # share history across all sessions
setopt APPEND_HISTORY         # append instead of overwrite
setopt INC_APPEND_HISTORY     # write immediately, not on shell exit
setopt HIST_IGNORE_DUPS       # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate from history
setopt HIST_REDUCE_BLANKS     # trim extra whitespace
setopt HIST_IGNORE_SPACE      # skip commands starting with space
setopt HIST_FIND_NO_DUPS      # skip dupes when searching
