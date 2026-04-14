#!/usr/bin/env bash
set -e

# Wait until desktop config path exists
mkdir -p /home/kasm-default-profile/.config/xfce4/desktop

CONFIG_FILE="/home/kasm-default-profile/.config/xfce4/desktop/icons.screen0.rc"

cat > "$CONFIG_FILE" <<'EOF'
[file-icons]
sort=2
sort_folders_before_files=true
icon_size=48
show_thumbnails=true
single_click=false
arrange_rows=false
EOF

chown -R 1000:1000 /home/kasm-default-profile/.config