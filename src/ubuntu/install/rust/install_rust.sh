#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  build-essential

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

cat >/etc/profile.d/rust.sh <<'EOF'
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH="/usr/local/cargo/bin:$PATH"
EOF
chmod +x /etc/profile.d/rust.sh

cat >/usr/local/bin/rust-env <<'EOF'
#!/usr/bin/env bash
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH="/usr/local/cargo/bin:$PATH"
exec "$@"
EOF
chmod +x /usr/local/bin/rust-env

apt-get clean
rm -rf /var/lib/apt/lists/*