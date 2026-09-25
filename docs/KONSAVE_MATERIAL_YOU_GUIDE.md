# KDE Plasma 6 Konsave Profiles & Material You Rice Guide

This guide documents the multi-profile rice architecture on Fedora KDE Plasma 6 using **Konsave**, **KDE Material You Colors**, and **Panel Colorizer**.

---

## 🎨 Available Profiles

You have 3 fully configured profiles saved in Konsave:

| Profile Name | Aesthetic | Key Features |
|---|---|---|
| **`material-you-v1`** | **Google Material You (M3) / Caelestia** | Floating rounded pill island panels, dynamic wallpaper color extraction, KWin frosted glass blur, KdeControlStation quick settings drawer, Material 3 Dark theme. |
| **`my-real-rice`** | **Pristine Custom Rice** | Original custom top bar & dock, Starship Catppuccin mocha bubble prompt, fastfetch animations suite (`solar`, `saturn`, `dna`, `3body`), custom Start Menu icon, ColorFlow icons. |
| **`original-kde-clean`** | **Clean Fallback** | Stock KDE Plasma 6 Breeze setup. |

---

## ⚡ Instant Profile Switching

We provide an automated, instant switcher script [`switch-rice.sh`](file:///home/dj/Desktop/fedora-setup/switch-rice.sh):

```bash
cd ~/Desktop/fedora-setup

# Switch to Material You Rice:
./switch-rice.sh material-you-v1

# Revert to your original setup:
./switch-rice.sh my-real-rice

# Revert to stock clean KDE:
./switch-rice.sh original-kde-clean
```

The script automatically:
1. Calls `konsave -a <profile>`
2. Re-triggers KWin rendering effects via DBus (`qdbus-qt6 org.kde.KWin /KWin reconfigure`)
3. Restarts `plasma-plasmashell` without logging you out or closing open windows
4. Emits a desktop notification confirming the switch

---

## 🛠️ How Material You Is Configured

### 1. Dynamic Color Extraction (`kde-material-you-colors`)
- **Package**: `kde-material-you-colors` v2.2.0 (by Luis Bocanegra)
- **Config**: `~/.config/kde-material-you-colors/config.conf`
- **Spec**: Material 3 (2025 Spec, TonalSpot variant, dark mode)
- **Autostart**: `~/.config/autostart/kde-material-you-colors.desktop` automatically samples wallpaper transitions and adapts KDE colors, titlebars, and terminals in real-time.

### 2. Floating Island Pill Panels (`luisbocanegra.panel.colorizer`)
- **Applet**: Applet 55 on Containment 28 (Top Panel)
- **Preset**: `Rounded Widgets Floating`
- **Behavior**: Separates the top bar into 3 floating capsules:
  - **Left Pill**: Workspaces / Virtual Desktops
  - **Center Pill**: Modern Clock & Date
  - **Right Pill**: Hardware Sensors (CPU/GPU temps), System Tray, and Quick Settings

### 3. Quick Settings Drawer (`KdeControlStation`)
- **Applet**: Applet 59 on Containment 28
- Provides an Android 14 / ChromeOS style pull-down tile drawer for Wi-Fi, Bluetooth, Night Color, Volume, and Brightness.

### 4. Terminal Harmony
- **Starship Prompt**: Catppuccin mocha bubble pills (`~/.config/starship.toml`)
- **Fastfetch Commands**:
  - `solar` - Keplerian orbit logo
  - `saturn` - Golden Saturn logo
  - `sfw` - SFW anime art
  - `nsfw` - Braille art
  - `dna` - 2.5s animated DNA helix
  - `3body` - 3-Body orbital simulation
  - `ascii` - Help menu

---

## 💾 Backups & Export Packages

Archival `.knsv` packages exist in `/home/dj/Desktop/fedora-setup/`:
- `material-you-v1.knsv.knsv`
- `my-real-rice.knsv`
- `original-kde-clean.knsv.knsv`

Full raw filesystem tarball:
- `full-system-rice-backup-2026-09-25/current-full-rice-snapshot.tar.gz`
