# Debian 11 XFCE Desktop with VNC and noVNC
FROM debian:11

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set up environment variables
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=1920x1080 \
    VNC_DEPTH=24

# Install XFCE, VNC, noVNC and utilities
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    dbus-x11 \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    python3-numpy \
    net-tools \
    wget \
    curl \
    firefox-esr \
    vim \
    nano \
    git \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash vncuser && \
    echo "vncuser:vncuser" | chpasswd && \
    usermod -aG sudo vncuser

# Switch to vncuser
USER vncuser
WORKDIR /home/vncuser

# Create VNC directory and set up configuration
RUN mkdir -p /home/vncuser/.vnc

# Create VNC password (default: password)
RUN echo "password" | vncpasswd -f > /home/vncuser/.vnc/passwd && \
    chmod 600 /home/vncuser/.vnc/passwd

# Create xstartup file
RUN echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
export XKL_XMODMAP_DISABLE=1\n\
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then\n\
    eval $(dbus-launch --sh-syntax)\n\
fi\n\
startxfce4 &' > /home/vncuser/.vnc/xstartup && \
    chmod +x /home/vncuser/.vnc/xstartup

# Create VNC config
RUN echo "geometry=${VNC_RESOLUTION}\n\
depth=${VNC_DEPTH}\n\
dpi=96" > /home/vncuser/.vnc/config

# Create startup script
RUN echo '#!/bin/bash\n\
echo "Starting VNC server..."\n\
vncserver :1 -localhost no\n\
echo "VNC server started on port 5901"\n\
echo "Starting noVNC..."\n\
websockify --web=/usr/share/novnc 6080 localhost:5901 &\n\
echo "noVNC started on port 6080"\n\
echo "Desktop is ready!"\n\
echo "VNC: localhost:5901"\n\
echo "Web: http://localhost:6080"\n\
tail -f /home/vncuser/.vnc/*.log' > /home/vncuser/start.sh && \
    chmod +x /home/vncuser/start.sh

# Expose ports
EXPOSE 5901 6080

# Start services
CMD ["/home/vncuser/start.sh"]
