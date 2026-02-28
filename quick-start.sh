#!/bin/sh

# Quick Start Script - One-command setup for XFCE Desktop with VNC

echo "========================================="
echo "  XFCE Desktop Environment - Quick Start"
echo "========================================="
echo ""

# Make all scripts executable
echo "[1/4] Making scripts executable..."
chmod +x install-desktop.sh configure-vnc.sh start-desktop.sh

# Check if already installed
if command -v vncserver > /dev/null 2>&1 && [ -d ~/.vnc ]; then
    echo ""
    echo "Desktop environment already installed!"
    echo ""
    echo "Starting desktop environment..."
    echo ""
    sh start-desktop.sh
    exit 0
fi

# Run installation
echo ""
echo "[2/4] Installing desktop environment..."
echo "This may take 5-10 minutes. Please be patient..."
echo ""

if ! sh install-desktop.sh; then
    echo ""
    echo "Installation failed! Check the error messages above."
    exit 1
fi

# Configure VNC
echo ""
echo "[3/4] Configuring VNC server..."
if ! sh configure-vnc.sh; then
    echo ""
    echo "Configuration failed! Check the error messages above."
    exit 1
fi

# Start desktop
echo ""
echo "[4/4] Starting desktop environment..."
sh start-desktop.sh
