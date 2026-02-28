#!/bin/sh

# VNC Server Configuration Script

set -e

echo "=== Configuring VNC Server ==="

# Create VNC directory if it doesn't exist
mkdir -p ~/.vnc

# Create xstartup file for VNC
echo "Creating VNC startup configuration..."
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1

# Start D-Bus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax)"
fi

# Start XFCE Desktop
startxfce4 &
EOF

# Make xstartup executable
chmod +x ~/.vnc/xstartup

# Create VNC config file
echo "Creating VNC configuration file..."
cat > ~/.vnc/config << 'EOF'
geometry=1920x1080
depth=24
dpi=96
EOF

# Set VNC password if not already set
if [ ! -f ~/.vnc/passwd ]; then
    echo "VNC password not found. Please set a VNC password:"
    vncpasswd
fi

echo ""
echo "=== VNC Configuration Complete ==="
echo "Configuration files created in ~/.vnc/"
echo "- xstartup: VNC startup script"
echo "- config: VNC server settings"
echo "- passwd: VNC password file"
