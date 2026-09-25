# Hyprland & Caelestia Material You Setup

Comprehensive configuration, companion tools, and automated deployment script for **Hyprland** with **Caelestia (Quickshell)** Material You desktop on Fedora Linux.

Optimized specifically for dual-GPU hybrid laptops (**AMD Phoenix1 Radeon iGPU + NVIDIA GeForce RTX 4050 dGPU**).

---

## 🚀 Quick Restore & Installation

To deploy or restore this entire setup on any Fedora installation:

```bash
cd hyprland-caelestia
./install.sh
```

The script will automatically:
1. Enable required COPR repositories.
2. Install Hyprland, Quickshell, GUI settings utilities (`wdisplays`, `pavucontrol`, `blueman`, `nm-connection-editor`), and themes.
3. Deploy configurations to `~/.config/hypr/` and `~/.config/caelestia/`.
4. Apply system-wide dark mode for both GTK 3/4 and Qt/KDE applications.
5. Hide redundant SDDM session entries.

---

## 🛠️ Key Technical Fixes Applied

### 1. Hybrid GPU (AMD + NVIDIA) Display & DRM Fix
On hybrid laptops, internal displays are wired directly to the integrated AMD GPU. We explicitly configure Aquamarine DRM device priority:
```ini
# ~/.config/hypr/hyprland/env.conf
env = AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2
```

### 2. Stuck / Frozen Cursor Plane Fix
NVIDIA DRM hardware cursor plane often hangs or freezes in the middle of the screen. We force software cursor fallback:
```ini
# ~/.config/hypr/hyprland/input.conf
cursor {
    no_hardware_cursors = true
    hotspot_padding = 1
}
```

### 3. SDDM Single Session Cleanup
Prevents duplicate entries (`Hyprland` and `Hyprland (uwsm-managed)`) on the login screen by backing up the redundant wrapper:
```bash
sudo mv /usr/share/wayland-sessions/hyprland-uwsm.desktop /usr/share/wayland-sessions/hyprland-uwsm.desktop.bak
```

### 4. System-Wide Dark Mode
- **GTK 3 & 4:** Configured with `adw-gtk3-dark` and `gtk-application-prefer-dark-theme = 1`.
- **Qt & KDE apps:** Configured with `ColorScheme=BreezeDark` in `~/.config/kdeglobals`.

### 5. Cross-Desktop Keyring Synchronization (No Account Logouts)
When switching between KDE Plasma and Hyprland, Chromium-based browsers (Brave/Chrome) and terminal credentials (`gh`, Git) previously logged out because KDE uses **KWallet 6** (`kwalletd6`), while standalone compositors default to an empty GNOME Keyring.

**The Solution Implemented:**
1. **Brave Configuration:** In `~/.config/brave-flags.conf`, explicitly set `--password-store=kwallet6` so Brave always uses KWallet across all desktop sessions.
2. **Hyprland Startup:** In `~/.config/hypr/hyprland/execs.conf`, initialize `/usr/libexec/pam_kwallet_init`, `/usr/bin/kwalletd6`, and `/usr/libexec/kf6/polkit-kde-authentication-agent-1`.
*Result: All browser sessions, Google accounts, GitHub tokens, and terminal CLI logins remain seamlessly authenticated across both KDE and Hyprland.*

### 6. Visual Material Alt+Tab Window Switcher
Replaces silent in-workspace cycling with a full visual **Material-themed window switcher** across all workspaces using Rofi:
```ini
bind = ALT, Tab, exec, rofi -show window -theme material
bind = Super, Tab, exec, rofi -show window -theme material
```

---

## ⌨️ Shortcuts & Keybindings Reference

### Window & Application Management
| Shortcut | Action |
| :--- | :--- |
| **`Alt + F4`** or **`Super + Q`** / **`Super + W`** | Close active window |
| **`Alt + Tab`** or **`Super + Tab`** | Switch to next window |
| **`Shift + Alt + Tab`** | Switch to previous window |
| **`Super + Space`** or **`Super`** or **`Super + A`** | Open Application Launcher |
| **`Super + Enter`** / **`Ctrl + Alt + T`** or **`Super + T`** | Open Terminal |
| **`Super + E`** | Open File Explorer (`thunar` / `dolphin`) |
| **`Super + B`** | Open Browser (`firefox` / `brave`) |
| **`Super + C`** | Open Code Editor (`VS Code`) |
| **`F11`** or **`Super + F`** | Toggle Fullscreen |
| **`Super + Alt + Space`** | Toggle Floating mode |

### Mouse & Touchpad Controls
| Action | Binding |
| :--- | :--- |
| **Move Window** | Hold `Super` OR `Alt` + Left Click & Drag |
| **Resize Window** | Hold `Super` OR `Alt` + Right Click & Drag |
| **Touchpad Tap-to-Click** | 1 Finger = Left Click, 2 Fingers = Right Click, 3 Fingers = Middle Click |
| **Switch Workspaces** | Hold `Super` + Scroll Wheel Up/Down |

### System & Control Panels
| Shortcut | Action |
| :--- | :--- |
| **`Super + N`** | Slide out Caelestia Quick Settings Drawer |
| **`Ctrl + Alt + Delete`** | Session / Power / Reboot Menu |
| **`Super + L`** | Lock Screen |
| **`PrtScn`** | Full Screenshot |
| **`Super + Shift + S`** | Region / Snip Screenshot |
| **`Super + V`** | Clipboard History Manager |

---

## 🖥️ Modular Settings Apps
Unlike KDE Plasma which relies on a monolithic `systemsettings` daemon, Hyprland uses modular Wayland tools:
- **Displays & Scaling:** `wdisplays`
- **Audio & Sinks:** `pavucontrol`
- **Bluetooth:** `blueman-manager`
- **Network & Wi-Fi:** `nm-connection-editor`
- **Quick Toggles:** Press `Super + N` (or click right edge of screen) for Caelestia drawer.
