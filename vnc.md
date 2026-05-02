Inspiration https://github.com/AndnixSH/codespace-desktop and chatgpt.
All the following has been put into shell scripts.

# Preparations
sudo apt update

Install all batch 1

sudo apt install -y xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common dbus-x11 x11-xserver-utils novnc websockify

**Desktop environment (lightweight)**

sudo apt install -y xfce4 xfce4-goodies

**VNC server**

sudo apt install -y tigervnc-standalone-server tigervnc-common

**Utilities**

sudo apt install -y dbus-x11 x11-xserver-utils

**noVNC + websockify**

sudo apt install -y novnc websockify

Setup vnc password:

vncpasswd

---

Set `~/.vnc/xstartup`:
```
#!/bin/bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

exec startxfce4
```
chmod +x ~/.vnc/xstartup

# Start VNC
vncserver :1
websockify --web=/usr/share/novnc/ 6080 localhost:5901


# Install chrome

sudo apt install -y wget gnupg

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

# Start Chrome

DISPLAY=:1 google-chrome \
--no-sandbox \
--disable-setuid-sandbox \
--disable-dev-shm-usage \
--disable-gpu \
--single-process \
--no-zygote

Note: chrome is too unstable in the container, firefox works better
