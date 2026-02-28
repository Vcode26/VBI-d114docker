#!/bin/sh

# Installation script for XFCE Desktop, VNC, and noVNC on Debian 11
# Suitable for Replit environment

set -e

echo "=== Starting Desktop Environment Installation ==="

# Determine if we need sudo
SUDO=""
if which sudo > /dev/null 2>&1; then
    SUDO="sudo"
fi

# Update package lists
echo "Updating package lists..."
$SUDO apt-get update

# Install XFCE Desktop Environment
echo "Installing XFCE Desktop Environment..."
$SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-goodies xfce4-terminal dbus-x11

# Install VNC Server (TigerVNC)
echo "Installing TigerVNC Server..."
$SUDO apt-get install -y tigervnc-standalone-server tigervnc-common

# Install noVNC and dependencies
echo "Installing noVNC and dependencies..."
$SUDO apt-get install -y novnc python3-numpy net-tools wget curl

# Install websockify (needed for noVNC)
echo "Installing websockify..."
$SUDO apt-get install -y websockify

# Install additional useful tools
echo "Installing additional tools..."
$SUDO apt-get install -y firefox-esr vim nano git

# Create VNC directory
mkdir -p ~/.vnc

# Set VNC password
echo "Setting up VNC password..."
echo "Please enter a VNC password (it will be used to access the desktop):"
vncpasswd

echo ""
echo "=== Installation Complete ==="
echo "Next steps:"
echo "1. Run './configure-vnc.sh' to configure the VNC server"
echo "2. Run './start-desktop.sh' to start the desktop environment"
