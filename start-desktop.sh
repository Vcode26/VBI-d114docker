#!/bin/sh

# Main startup script for VNC Desktop with noVNC web access

set -e

# Configuration
VNC_DISPLAY=:1
VNC_PORT=5901
NOVNC_PORT=6080

echo "=== Starting Desktop Environment ==="

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "=== Shutting down services ==="
    if [ -n "$NOVNC_PID" ]; then
        echo "Stopping noVNC..."
        kill "$NOVNC_PID" 2>/dev/null || true
    fi
    echo "Stopping VNC server..."
    vncserver -kill "$VNC_DISPLAY" 2>/dev/null || true
    exit 0
}

trap cleanup INT TERM EXIT

# Check if VNC is already running
if pgrep -x "Xvnc" > /dev/null 2>&1; then
    echo "VNC server is already running. Stopping it first..."
    vncserver -kill "$VNC_DISPLAY" 2>/dev/null || true
    sleep 2
fi

# Start VNC server
echo "Starting VNC server on display $VNC_DISPLAY (port $VNC_PORT)..."
vncserver "$VNC_DISPLAY" -localhost no

# Wait for VNC to be ready
echo "Waiting for VNC server to be ready..."
sleep 3

# Check if VNC started successfully
if ! pgrep -x "Xvnc" > /dev/null 2>&1; then
    echo "ERROR: VNC server failed to start!"
    echo "Check ~/.vnc/*.log for details"
    exit 1
fi

echo "VNC server started successfully!"

# Start noVNC
echo "Starting noVNC on port $NOVNC_PORT..."
if command -v websockify > /dev/null 2>&1; then
    # Start websockify (noVNC) in background
    websockify --web=/usr/share/novnc "$NOVNC_PORT" localhost:"$VNC_PORT" &
    NOVNC_PID=$!

    echo "noVNC started successfully!"
else
    echo "WARNING: websockify not found. noVNC may not work properly."
fi

# Display connection information
echo ""
echo "=== Desktop Environment is Running ==="
echo "VNC Server: localhost:$VNC_PORT (display $VNC_DISPLAY)"
echo "noVNC Web Access: http://localhost:$NOVNC_PORT"
echo ""
echo "In Replit, the web interface should be accessible through the webview."
echo "Click the 'Open in new tab' button or check the Webview panel."
echo ""
echo "To connect with a VNC client:"
echo "  Address: localhost:$VNC_PORT"
echo "  Or: localhost$VNC_DISPLAY"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Keep script running
while true; do
    # Check if VNC is still running
    if ! pgrep -x "Xvnc" > /dev/null 2>&1; then
        echo "ERROR: VNC server stopped unexpectedly!"
        exit 1
    fi

    # Check if noVNC is still running
    if [ -n "$NOVNC_PID" ] && ! kill -0 "$NOVNC_PID" 2>/dev/null; then
        echo "WARNING: noVNC stopped unexpectedly. Restarting..."
        websockify --web=/usr/share/novnc "$NOVNC_PORT" localhost:"$VNC_PORT" &
        NOVNC_PID=$!
    fi

    sleep 5
done
