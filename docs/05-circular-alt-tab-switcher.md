# Circular Alt-Tab & Radial Window Switchers for GNOME

On social media (Instagram Reels, TikTok, Reddit r/unixporn), several distinct "circular" window switching effects frequently go viral. Below are the exact extensions that provide these visual styles on GNOME.

---

## 1. Candidate 1: Fly-Pie (The True Circular / Radial Pie Menu)

![Fly-Pie Radial Menu](https://github.com/Schneegans/Fly-Pie/raw/main/docs/media/menu.png)

### What it is:
A literal circular (pie-shaped) marking menu. When you press a hotkey (e.g., `Ctrl+Space` or `Alt+Tab`), a circular wheel appears centered on your screen or cursor. Open windows, running applications, and workspaces are laid out as slices in a circle.

### Why it went viral on Instagram:
It looks futuristic, supports smooth fluid animations, and allows you to switch windows or launch tools with a quick directional mouse flick or gesture.

### How to Install:
1. Open **Extension Manager** (installed via `pacman -S extension-manager`).
2. Search for: **Fly-Pie** (by *Schneegans*).
3. Click **Install** and toggle **ON**.
4. In its settings, assign the trigger key to `Alt+Tab` or `Ctrl+Space` and select the **Running Applications / Windows** preset.

---

## 2. Candidate 2: Coverflow Alt-Tab (3D Curved Carousel)

### What it is:
Replaces the flat, boring default GNOME Alt-Tab switcher with a 3D Cover Flow / cylindrical carousel. Windows rotate towards you in 3D perspective with real-time live previews, window reflections, and looping animation.

### Why it went viral on Instagram:
It mimics the sleek macOS Cover Flow and classic Compiz 3D ring switchers. When you hold `Alt` and tap `Tab`, windows glide in a smooth 3D curved arc across the monitor.

### Key Settings to achieve the viral look:
- **Animation Style**: *Coverflow* or *Timeline*
- **Window Title**: Centered below the active window preview
- **Background Dim**: 60% dimming with blur
- **Looping**: Enabled (cycles in an infinite loop)

### How to Install:
```bash
# In Extension Manager:
# Search for: "Coverflow Alt-Tab" (by dsheeler)
```
Or install via GNOME Shell extensions CLI:
```bash
gnome-extensions enable coverflow-alt-tab@palatis.blogspot.com
```

---

## 3. Candidate 3: AATWS (Advanced Alt-Tab Window Switcher)

### What it is:
The most powerful and configurable window switcher for GNOME. Allows complete customization of:
- Grid layout or centered pill layout
- Window preview sizes
- Custom workspace filtering
- Quick search filtering (typing filters open windows instantly)

---

## 4. Complementary Visual Effects (Compiz Nostalgia)

To complete the retro-modern aesthetic seen on Instagram setups, pair the circular switcher with:
- **Burn My Windows**: 3D disintegrate / fire / hexagon window close animations.
- **Compiz Windows Effect (Wobbly Windows)**: Windows wobble smoothly like gelatin when dragged across the screen.

```bash
# Install via Extension Manager:
# 1. "Compiz windows effect"
# 2. "Burn My Windows"
```
