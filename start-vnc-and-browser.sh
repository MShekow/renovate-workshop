#!/bin/bash
set -e
# Start VNC on port 5901 (non-blocking)
vncserver :1
# Start firefox on the virtual desktop (sent to background)
DISPLAY=:1 firefox &
# Start NoVNC, this blocks the terminal
websockify --web=/usr/share/novnc/ 6080 localhost:5901
