# Noctalia Timer Plugin ⏱️🔔

An enhanced countdown timer plugin for **Noctalia Shell**, featuring fast one-click presets, multi-entry UI (bar, panel, desktop widget), and audible sound alarms upon completion.

---

## ✨ Features

- **⏱️ Live Countdown:** Headless service driving synchronized states across bar, attached panel, and desktop widgets.
- **⚡ Fast Presets:** Instant one-click timer buttons in the panel (`1m`, `5m`, `15m`, `25m Pomodoro`, `45m`).
- **🔔 Sound Alarms:** Plays an audible alarm (`alarm.mp3`) when the countdown reaches 0:00 (powered by `pw-play` / PipeWire).
- **🎨 Configurable:** Toggle sound alerts and specify custom sound files via Noctalia settings.
- **🌐 Multilingual:** Full translations for English, Spanish, German, French, Arabic, Turkish, and Portuguese.

---

## 🚀 Installation & Usage

1. Clone or copy into your Noctalia plugins directory:
   ```bash
   cp -r . ~/.local/state/noctalia/plugins/materialized/official/timer/
   ```
2. Enable and place the `bar`, `panel`, or `desktop` widget in your Noctalia Shell settings.
3. Click any preset or enter a duration (e.g. `2500` for 25:00) and press **Start**.

---

## 📜 License

[MIT](LICENSE)
