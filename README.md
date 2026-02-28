# XFCE Desktop Environment for Replit

Access a full Debian 11 XFCE desktop environment through your web browser using VNC and noVNC.

## Quick Start

Run this single command to install and start everything:

```bash
chmod +x quick-start.sh && ./quick-start.sh
```

That's it! The desktop will be accessible in your browser at port 6080.

## What You Get

- Full XFCE desktop environment
- VNC server for remote access
- noVNC web interface for browser access
- Firefox browser pre-installed
- Complete development tools

## Step-by-Step Setup

If you prefer manual control:

### 1. Install
```bash
chmod +x install-desktop.sh && ./install-desktop.sh
```

### 2. Configure
```bash
chmod +x configure-vnc.sh && ./configure-vnc.sh
```

### 3. Start
```bash
chmod +x start-desktop.sh && ./start-desktop.sh
```

## Accessing the Desktop

In Replit:
1. Look for the Webview panel (opens automatically)
2. Or click "Open in new tab" button
3. Click "Connect" in the noVNC interface
4. Enter your VNC password
5. Enjoy your desktop!

Direct access: `http://localhost:6080`

## Files Included

| File | Purpose |
|------|---------|
| `quick-start.sh` | One-command setup and start |
| `install-desktop.sh` | Install XFCE, VNC, noVNC |
| `configure-vnc.sh` | Configure VNC server settings |
| `start-desktop.sh` | Start VNC and noVNC services |
| `Dockerfile` | Docker-based alternative setup |
| `DESKTOP_SETUP_GUIDE.md` | Comprehensive documentation |

## Docker Alternative

If you prefer using Docker:

```bash
docker build -t debian-xfce-vnc .
docker run -d -p 5901:5901 -p 6080:6080 --name xfce-desktop debian-xfce-vnc
```

Then access at `http://localhost:6080` (password: `password`)

## Troubleshooting

Having issues? Check the comprehensive guide:

**[Read the Complete Setup Guide →](DESKTOP_SETUP_GUIDE.md)**

The guide includes:
- Detailed installation instructions
- Common issues and solutions
- Advanced configuration
- Performance optimization
- Security notes
- FAQ section

### Quick Fixes

**VNC won't start?**
```bash
vncserver -kill :1
./start-desktop.sh
```

**Black screen?**
```bash
./configure-vnc.sh
vncserver -kill :1
./start-desktop.sh
```

**Connection failed?**
```bash
ps aux | grep Xvnc  # Check if VNC is running
ps aux | grep websockify  # Check if noVNC is running
```

## Default Settings

- VNC Display: `:1`
- VNC Port: `5901`
- noVNC Port: `6080`
- Resolution: `1920x1080`
- Color Depth: `24-bit`

## Ports

| Service | Port |
|---------|------|
| VNC Server | 5901 |
| noVNC Web | 6080 |

## Requirements

- Debian 11 (or compatible system)
- Sudo access
- Internet connection for package installation
- ~2GB disk space
- ~512MB RAM minimum (1GB+ recommended)

## Stopping Services

Press `Ctrl+C` in the terminal running `start-desktop.sh`, or:

```bash
vncserver -kill :1
pkill websockify
```

## Documentation

- [Complete Setup Guide](DESKTOP_SETUP_GUIDE.md) - Comprehensive documentation with troubleshooting
- [XFCE Documentation](https://docs.xfce.org/) - Desktop environment docs
- [TigerVNC](https://tigervnc.org/) - VNC server documentation
- [noVNC](https://github.com/novnc/noVNC) - Web VNC client

## Support

1. Check [DESKTOP_SETUP_GUIDE.md](DESKTOP_SETUP_GUIDE.md) for detailed troubleshooting
2. Review VNC logs: `cat ~/.vnc/*.log`
3. Verify services: `ps aux | grep -E 'Xvnc|websockify'`
4. Check ports: `netstat -tuln | grep -E '5901|6080'`

## License

These scripts are provided as-is for educational and development purposes.

---

Ready to start? Run:
```bash
chmod +x quick-start.sh && ./quick-start.sh
```
