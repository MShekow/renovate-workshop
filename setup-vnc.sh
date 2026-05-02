#!/bin/bash
set -euo pipefail

# This script sets up a TightVNC server with the XFCE desktop environment and also installs the NoVNC project to allow
# access to the VNC server through a web browser. It also installs Firefox from Mozilla's repository.

export DEBIAN_FRONTEND=noninteractive

TIMEZONE="${TIMEZONE:-Europe/Berlin}"
KEYBOARD_LAYOUT="${KEYBOARD_LAYOUT:-de}"
KEYBOARD_MODEL="${KEYBOARD_MODEL:-pc105}"
VNC_PASSWORD="${VNC_PASSWORD:?Please set VNC_PASSWORD}"

sudo apt-get update

sudo debconf-set-selections <<EOF
tzdata tzdata/Areas select Europe
tzdata tzdata/Zones/Europe select Berlin
keyboard-configuration keyboard-configuration/modelcode string ${KEYBOARD_MODEL}
keyboard-configuration keyboard-configuration/layoutcode string ${KEYBOARD_LAYOUT}
keyboard-configuration keyboard-configuration/variantcode string
keyboard-configuration keyboard-configuration/optionscode string
EOF

sudo apt-get install -y tzdata keyboard-configuration
sudo ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
echo "${TIMEZONE}" | sudo tee /etc/timezone > /dev/null
sudo dpkg-reconfigure -f noninteractive tzdata keyboard-configuration

sudo apt-get install -y \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server tigervnc-common \
  dbus-x11 x11-xserver-utils \
  novnc websockify wget gnupg

mkdir -p "$HOME/.vnc"
printf '%s\n%s\nn\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd

cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

sudo install -d -m 0755 /etc/apt/keyrings
wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg \
  | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
  | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

sudo tee /etc/apt/preferences.d/mozilla > /dev/null <<'EOF'
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

sudo apt-get update
sudo apt-get install -y firefox
