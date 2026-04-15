#!/usr/bin/env bash
set -e

#!/bin/bash
# ============================================================
# XFCE Desktop Icon Sort Script — Kasm Workspaces (Ubuntu)
# Sets sort order to Name (ascending) and auto-sorts icons.
# Kasm containers start fresh each session, so this script
# writes directly to the xfconf XML config AND installs an
# XFCE autostart entry to re-apply on every session launch.
# ============================================================

XFCE_DESKTOP_XML="${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
AUTOSTART_DIR="${HOME}/.config/autostart"
AUTOSTART_FILE="${AUTOSTART_DIR}/xfce-sort-icons.desktop"
SCRIPT_INSTALL_PATH="${HOME}/.config/xfce4/sort-icons.sh"

# ----------------------------------------------------------
# Step 1 — Install this script to a stable location
# ----------------------------------------------------------
mkdir -p "$(dirname "$SCRIPT_INSTALL_PATH")"
cp "$(realpath "$0")" "$SCRIPT_INSTALL_PATH"
chmod +x "$SCRIPT_INSTALL_PATH"

# ----------------------------------------------------------
# Step 2 — Write sort settings via xfconf-query
#           (works when xfdesktop is already running)
# ----------------------------------------------------------
apply_xfconf() {
  # Sort column: 0=Name, 1=Size, 2=Type, 3=Date
  xfconf-query --channel xfce4-desktop \
    --property /desktop-icons/sort-column \
    --type int --set 0 --create 2>/dev/null

  # Sort direction: true = ascending
  xfconf-query --channel xfce4-desktop \
    --property /desktop-icons/sort-ascending \
    --type bool --set true --create 2>/dev/null
}

# ----------------------------------------------------------
# Step 3 — Patch the XML config file directly so settings
#           survive before xfdesktop starts (Kasm cold boot)
# ----------------------------------------------------------
patch_xml() {
  mkdir -p "$(dirname "$XFCE_DESKTOP_XML")"

  if [ ! -f "$XFCE_DESKTOP_XML" ]; then
    # Create a minimal valid config file
    cat > "$XFCE_DESKTOP_XML" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="desktop-icons" type="empty">
    <property name="sort-column" type="int" value="0"/>
    <property name="sort-ascending" type="bool" value="true"/>
  </property>
</channel>
EOF
    echo "Created new xfce4-desktop.xml with sort settings."
    return
  fi

  # File exists — insert or update sort-column
  if grep -q 'name="sort-column"' "$XFCE_DESKTOP_XML"; then
    sed -i 's|name="sort-column" type="[^"]*" value="[^"]*"|name="sort-column" type="int" value="0"|g' "$XFCE_DESKTOP_XML"
  else
    sed -i '/<property name="desktop-icons"/a\    <property name="sort-column" type="int" value="0"/>' "$XFCE_DESKTOP_XML"
  fi

  # Insert or update sort-ascending
  if grep -q 'name="sort-ascending"' "$XFCE_DESKTOP_XML"; then
    sed -i 's|name="sort-ascending" type="[^"]*" value="[^"]*"|name="sort-ascending" type="bool" value="true"|g' "$XFCE_DESKTOP_XML"
  else
    sed -i '/<property name="desktop-icons"/a\    <property name="sort-ascending" type="bool" value="true"/>' "$XFCE_DESKTOP_XML"
  fi

  echo "Patched existing xfce4-desktop.xml with sort settings."
}

# ----------------------------------------------------------
# Step 4 — Install an XFCE autostart entry so this runs
#           automatically on every Kasm session startup
# ----------------------------------------------------------
install_autostart() {
  mkdir -p "$AUTOSTART_DIR"
  cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=XFCE Sort Desktop Icons
Comment=Sort desktop icons by name on session start
Exec=${SCRIPT_INSTALL_PATH}
StartupNotify=false
Terminal=false
Hidden=false
X-GNOME-Autostart-enabled=true
EOF
  echo "Autostart entry installed at: $AUTOSTART_FILE"
}

# ----------------------------------------------------------
# Step 5 — Reload xfdesktop to apply changes immediately
# ----------------------------------------------------------
reload_xfdesktop() {
  if pgrep -x xfdesktop > /dev/null; then
    xfdesktop --reload 2>/dev/null && echo "xfdesktop reloaded." || {
      pkill xfdesktop
      sleep 1
      DISPLAY="${DISPLAY:-:1}" xfdesktop &
      echo "xfdesktop restarted."
    }
  else
    echo "xfdesktop not running — settings will apply on next session start."
  fi
}

# ----------------------------------------------------------
# Run all steps
# ----------------------------------------------------------
echo "==> Applying xfconf sort settings..."
apply_xfconf

echo "==> Patching xfce4-desktop XML config..."
patch_xml

echo "==> Installing autostart entry..."
install_autostart

echo "==> Reloading xfdesktop..."
reload_xfdesktop

echo ""
echo "Done! Desktop icons will be sorted by Name (ascending)"
echo "on this session and every future Kasm session."