# Noctalia Timer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans or superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a standalone Git/GitHub repository for `noctalia-timer` with sound alarm support (`alarm.mp3` / custom audio) and fast time presets (`1m`, `5m`, `15m`, `25m`, `45m`) on the panel.

**Architecture:** Luau/TOML plugin for Noctalia Shell. `service.luau` manages countdown and triggers audio on zero via `pw-play` fallback. `panel.luau` provides numeric input + quick preset buttons.

**Tech Stack:** Luau, TOML, Noctalia Shell Plugin API v3, Git, GitHub CLI (`gh`).

---

### Task 1: Update plugin.toml metadata and configuration settings

**Files:**
- Modify: `plugin.toml`

- [ ] **Step 1: Update version, panel height, and add sound & preset settings**
```toml
# In plugin.toml:
# Update version = "1.3.0"
# In [[panel]], set width = 340, height = 320
# Add settings for sound_enabled, custom_sound_path, presets
```

- [ ] **Step 2: Verify TOML syntax**
Run: `python3 -c 'import tomllib; tomllib.load(open("plugin.toml", "rb"))'`
Expected: Exit 0 (Valid TOML).

- [ ] **Step 3: Commit**
```bash
git add plugin.toml
git commit -m "feat(config): add sound and presets settings to plugin.toml"
```

---

### Task 2: Implement Sound Playback in service.luau

**Files:**
- Modify: `service.luau`

- [ ] **Step 1: Add sound config reader and audio trigger in notifyUser**
Read `sound_enabled` and `custom_sound_path`. In `notifyUser()`, emit `noctalia.notify` and execute `pw-play` on the alarm audio file.

- [ ] **Step 2: Verify service syntax and functions**
Run: `luau-analyze service.luau 2>&1 || true`
Expected: Clean syntax.

- [ ] **Step 3: Commit**
```bash
git add service.luau
git commit -m "feat(service): add sound notification playback on timer completion"
```

---

### Task 3: Implement Quick Presets UI in panel.luau

**Files:**
- Modify: `panel.luau`

- [ ] **Step 1: Add preset buttons row and click handler**
Render quick buttons (`1m`, `5m`, `15m`, `25m`, `45m`) above the controls. Clicking a preset sets `timer.remaining` and updates the formatted time display.

- [ ] **Step 2: Verify panel syntax**
Run: `luau-analyze panel.luau 2>&1 || true`
Expected: Clean syntax.

- [ ] **Step 3: Commit**
```bash
git add panel.luau
git commit -m "feat(panel): add quick time preset buttons"
```

---

### Task 4: Update Translations and Synchronize Plugin

**Files:**
- Modify: `translations/en.json`
- Modify: `translations/es.json` (or other translations)
- Sync to: `/home/rousseau/.local/state/noctalia/plugins/materialized/official/timer`

- [ ] **Step 1: Add translation keys for sound and presets**
- [ ] **Step 2: Sync files to materialized directory for live usage**
- [ ] **Step 3: Commit**
```bash
git add translations/
git commit -m "feat(i18n): add translation keys for sound and presets"
```

---

### Task 5: Initialize Git Repository and Push to GitHub

**Files:**
- Create: `.gitignore`
- Modify: `README.md`

- [ ] **Step 1: Create .gitignore and update README**
- [ ] **Step 2: Initialize git repo and make initial commit**
- [ ] **Step 3: Create GitHub repo CodeLoverKawai/noctalia-timer and push**
Run: `gh repo create noctalia-timer --public --source=. --push`
