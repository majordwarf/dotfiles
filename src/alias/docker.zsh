# Containers
alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dlog="docker logs"
alias dlogf="docker logs -f"
alias dexec="docker exec -it"
alias dstop="docker stop"
alias drm="docker rm"
alias drmf="docker rm -f"

# Images
alias di="docker images"
alias drmi="docker rmi"
alias dbuild="docker build"

# Compose
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr="docker compose restart"
alias dcl="docker compose logs -f"
alias dcps="docker compose ps"
alias dcb="docker compose build"
alias dce="docker compose exec"

# Networks
alias dnet="docker network ls"
alias dneti="docker network inspect"
alias dnetc="docker network create"
alias dnetrm="docker network rm"

# Volumes
alias dvol="docker volume ls"
alias dvoli="docker volume inspect"
alias dvolc="docker volume create"
alias dvolrm="docker volume rm"

# Inspect
alias dinsp="docker inspect"

# Cleanup
alias dprune="docker system prune -f"
alias dprunea="docker system prune -af"
alias dvprune="docker volume prune -f"
alias dnprune="docker network prune -f"
