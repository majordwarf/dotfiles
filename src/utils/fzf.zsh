# fzf configuration (keybindings and completion are generated at build time)
if (( $+commands[fzf] )); then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .venv --exclude __pycache__'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .venv --exclude __pycache__'
  fi

  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  export FZF_CTRL_T_OPTS='--preview "head -80 {}" --preview-window=right:50%:wrap'
  export FZF_CTRL_R_OPTS='--height 20% --layout=reverse'
  export FZF_ALT_C_OPTS='--preview "ls -1A {}" --preview-window=right:30%'
fi
