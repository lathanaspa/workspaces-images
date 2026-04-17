#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  wget \
  tar \
  gzip \
  libgtk-3-0 \
  libxss1

if ! apt-get install -y --no-install-recommends libasound2; then
  apt-get install -y --no-install-recommends libasound2t64 || true
fi

ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
  amd64) DBEAVER_ARCH="x86_64" ;;
  arm64) DBEAVER_ARCH="aarch64" ;;
  *)
    echo "Unsupported architecture for DBeaver: ${ARCH}" >&2
    exit 1
    ;;
esac

mkdir -p /opt/dbeaver
curl -fsSL "https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.${DBEAVER_ARCH}.tar.gz" -o /tmp/dbeaver.tar.gz
tar -xzf /tmp/dbeaver.tar.gz -C /opt/dbeaver --strip-components=1

cat >/usr/local/bin/dbeaver <<'EOF'
#!/usr/bin/env bash
exec /opt/dbeaver/dbeaver "$@"
EOF
chmod +x /usr/local/bin/dbeaver

cat >/usr/share/applications/dbeaver.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=DBeaver
Exec=/usr/local/bin/dbeaver
Icon=/opt/dbeaver/dbeaver.png
Terminal=false
Categories=Development;Database;
StartupNotify=true
EOF

mkdir -p /home/kasm-default-profile/Desktop
cp /usr/share/applications/dbeaver.desktop /home/kasm-default-profile/Desktop/DBeaver.desktop
chmod +x /home/kasm-default-profile/Desktop/DBeaver.desktop || true

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/dbeaver.tar.gz