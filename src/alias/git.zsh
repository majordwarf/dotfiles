# Status & info
alias gs="git status"
alias gl="git log --oneline --graph --decorate -20"
alias gla="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gsh="git show"

# Branching
alias gb="git branch"
alias gba="git branch -a"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gsw="git switch"
alias gsc="git switch -c"

# Staging & committing
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"

# Push & pull
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gpr="git pull --rebase"

# Stash
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

# Rebase & merge
alias grb="git rebase"
alias grbi="git rebase -i"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias gm="git merge"

# Reset
alias grh="git reset HEAD"
alias grhh="git reset --hard HEAD"
alias grs="git reset --soft HEAD~1"

# Misc
alias gcp="git cherry-pick"
alias gbl="git blame"
alias gcl="git clone"
alias gf="git fetch --all --prune"
