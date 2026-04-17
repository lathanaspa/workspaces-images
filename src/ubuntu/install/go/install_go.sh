#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  tar \
  gzip

ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
  amd64) GO_ARCH="amd64" ;;
  arm64) GO_ARCH="arm64" ;;
  *)
    echo "Unsupported architecture for Go: ${ARCH}" >&2
    exit 1
    ;;
esac

GO_VERSION="$(curl -fsSL https://go.dev/VERSION?m=text | head -n1)"
curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tgz

rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tgz

cat >/etc/profile.d/go.sh <<'EOF'
export PATH="/usr/local/go/bin:$PATH"
EOF
chmod +x /etc/profile.d/go.sh

cat >/usr/local/bin/go-env <<'EOF'
#!/usr/bin/env bash
export PATH="/usr/local/go/bin:$PATH"
exec "$@"
EOF
chmod +x /usr/local/bin/go-env

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/go.tgz