# Get public IP with fallback endpoints
myip() {
  curl -s --max-time 3 https://ifconfig.me 2>/dev/null \
    || curl -s --max-time 3 https://icanhazip.com 2>/dev/null \
    || { echo "Failed to fetch public IP" >&2; return 1; }
}
