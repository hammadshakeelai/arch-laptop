# Software Catalog: Native Pacman & AUR Package Directory

This catalog maps every tool and application from your requested setup to its corresponding native Arch package (`pacman`) or Arch User Repository (`AUR`) package.

---

## 1. Development & Code Editors

| Application | Package Name | Source | Description |
| :--- | :--- | :--- | :--- |
| **VSCodium** | `vscodium-bin` | AUR | Open-source binary release of VS Code without telemetry |
| **Neovim** | `neovim` | Official Repo | Modern, extensible vim-fork with Lua plugins |
| **Vim** | `vim` | Official Repo | Classic terminal editor |
| **Sublime Text** | `sublime-text-4` | AUR | Lightweight, blazing fast code and text editor |
| **TeXstudio** | `texstudio` | Official Repo | Integrated writing environment for LaTeX documents |
| **GitHub Desktop** | `github-desktop-bin`| AUR | Official Electron GUI client for Git & GitHub |
| **pgAdmin 4** | `pgadmin4` / Container | AUR / Docker | Administration interface for PostgreSQL databases |

---

## 2. Terminals & Low-Level System Utilities

| Tool | Package Name | Source | Description |
| :--- | :--- | :--- | :--- |
| **Terminator** | `terminator` | Official Repo | Multi-pane grid terminal emulator |
| **Byobu** | `byobu` | Official Repo | Enhanced tmux/screen window manager and status bar |
| **GHex** | `ghex` | Official Repo | GNOME binary/hexadecimal file editor |
| **Htop** | `htop` | Official Repo | Interactive text-mode process viewer and monitor |
| **Baobab** | `baobab` | Official Repo | GNOME Disk Usage Analyzer (visual tree maps) |
| **GDM Settings** | `gdm-settings` | AUR | GUI customizer for the GNOME login screen |
| **Extension Manager** | `extension-manager` | Official Repo | Search, install, and manage GNOME Shell extensions |
| **Avahi** | `avahi`, `nss-mdns` | Official Repo | mDNS / Zeroconf service discovery for SSH and VNC |

---

## 3. Productivity, Media & Web

| Application | Package Name | Source | Description |
| :--- | :--- | :--- | :--- |
| **ONLYOFFICE** | `onlyoffice-bin` | AUR | Full MS Office compatible desktop document suite |
| **Spotify** | `spotify` | AUR | Native desktop streaming client |
| **Firefox** | `firefox` | Official Repo | Fast, private open-source web browser |
| **Chromium** | `chromium` | Official Repo | Open-source web engine and browser |
| **Google Earth Pro** | `google-earth-pro`| AUR | 3D interactive satellite map and terrain exploration |

---

## 4. Automated Installation

Run the complete software installer:
```bash
chmod +x scripts/08_install_all_software.sh
./scripts/08_install_all_software.sh
```
