# Core
alias k="kubectl"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"

# Get resources
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods -A"
alias kgs="kubectl get svc"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kgi="kubectl get ingress"
alias kgcm="kubectl get configmaps"
alias kgsec="kubectl get secrets"
alias kgns="kubectl get namespaces"
alias kga="kubectl get all"

# Describe
alias kdp="kubectl describe pod"
alias kds="kubectl describe svc"
alias kdd="kubectl describe deployment"
alias kdn="kubectl describe node"

# Logs & exec
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kexec="kubectl exec -it"

# Context & namespace
alias kctx="kubectl config current-context"
alias kns="kubectl config set-context --current --namespace"
alias kgctx="kubectl config get-contexts"

# Scaling & rollout
alias krs="kubectl rollout status"
alias krr="kubectl rollout restart"
alias ksd="kubectl scale deployment"

# Port forward
alias kpf="kubectl port-forward"

# Resource usage
alias ktop="kubectl top"
alias ktopp="kubectl top pods"
alias ktopn="kubectl top nodes"

# Additional resource types
alias kgss="kubectl get statefulsets"
alias kgcj="kubectl get cronjobs"
alias kgj="kubectl get jobs"

# Watch
alias kw="kubectl get pods -w"

# Delete
alias kdel="kubectl delete"
alias kdelp="kubectl delete pod"
alias kdeld="kubectl delete deployment"
