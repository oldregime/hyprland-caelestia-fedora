#!/usr/bin/env bash
# ==============================================================================
# Hyprland + Caelestia Material You Desktop Automated Installer & Restorer
# Fedora Linux (Optimized for Lenovo LOQ / AMD iGPU + NVIDIA dGPU)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "==> Starting Hyprland + Caelestia Installation & Configuration..."

# 1. Check Root / Sudo
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as your standard user (sudo will be prompted when needed)."
    exit 1
fi

# 2. Enable COPR Repositories if needed
echo "==> Checking COPR repositories for Hyprland & Quickshell..."
sudo dnf copr enable -y solopasha/hyprland || true

# 3. Install Required Packages & Companion Tools
echo "==> Installing packages (Compositor, Shell, GUI Utilities, Themes)..."
sudo dnf install -y \
    hyprland \
    quickshell \
    wdisplays \
    pavucontrol \
    blueman \
    nm-connection-editor \
    adw-gtk3-theme \
    breeze-cursor-theme \
    foot \
    kitty || true

# 4. Backup Existing Configs
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
echo "==> Backing up existing configurations if present..."
[ -d "$HOME/.config/hypr" ] && cp -r "$HOME/.config/hypr" "$HOME/.config/hypr.bak_$TIMESTAMP"
[ -d "$HOME/.config/caelestia" ] && cp -r "$HOME/.config/caelestia" "$HOME/.config/caelestia.bak_$TIMESTAMP"

# 5. Deploy Configurations
echo "==> Deploying Hyprland and Caelestia configurations..."
mkdir -p "$HOME/.config/hypr" "$HOME/.config/caelestia" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

cp -r "$SCRIPT_DIR/configs/hypr/"* "$HOME/.config/hypr/"
cp -r "$SCRIPT_DIR/configs/caelestia/"* "$HOME/.config/caelestia/"
cp "$SCRIPT_DIR/configs/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
cp "$SCRIPT_DIR/configs/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

# Make scripts executable
chmod +x "$HOME/.config/hypr/scripts/"*.fish 2>/dev/null || true

# 6. Apply System-wide Dark Theme (GTK & Qt)
echo "==> Applying dark theme..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' || true
gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark' || true
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors' || true

if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group General --key ColorScheme BreezeDark || true
fi

# 7. SDDM Fix: Disable duplicate uwsm session
echo "==> Cleaning up SDDM session entries..."
if [ -f "/usr/share/wayland-sessions/hyprland-uwsm.desktop" ]; then
    sudo mv /usr/share/wayland-sessions/hyprland-uwsm.desktop /usr/share/wayland-sessions/hyprland-uwsm.desktop.bak || true
fi

# 8. Reload Hyprland if running
if pgrep -x "Hyprland" >/dev/null; then
    echo "==> Hyprland active: Reloading configuration live..."
    hyprctl reload || true
    hyprctl setcursor breeze_cursors 24 || true
fi

echo "=============================================================================="
echo "✓ Hyprland + Caelestia setup deployed successfully!"
echo "• Displays & Scaling: wdisplays"
echo "• Audio control: pavucontrol"
echo "• Bluetooth manager: blueman-manager"
echo "• Wi-Fi & Networks: nm-connection-editor"
echo "• Quick Settings Drawer: Super + N (or click right edge)"
echo "• App Launcher: Super / Super + Space"
echo "• Close window: Alt + F4 or Super + Q"
echo "• Switch window: Alt + Tab / Super + Tab"
echo "=============================================================================="
