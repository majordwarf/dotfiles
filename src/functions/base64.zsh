# Base64 encode (argument or stdin)
b64e() { printf '%s' "${1:-$(cat)}" | base64 }

# Base64 decode (argument or stdin)
b64d() { printf '%s' "${1:-$(cat)}" | base64 -d }
