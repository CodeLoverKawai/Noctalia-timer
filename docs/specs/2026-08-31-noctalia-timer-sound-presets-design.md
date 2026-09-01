# Especificación de Diseño: Noctalia Timer (Presets Rápidos + Alarma Sonora)

**Fecha:** 2026-08-31  
**Repositorio:** `CodeLoverKawai/noctalia-timer`  
**Ruta:** `/home/rousseau/Projects/noctalia-timer`  
**Versión:** `1.3.0`

---

## 1. Objetivos del Proyecto
1. **Soporte de Sonido / Alarma:** Emitir sonido (`alarm.mp3` o archivo personalizado) al terminar la cuenta regresiva, con interruptor de activación en ajustes.
2. **Presets de Tiempos Rápidos:** Botones de acceso rápido en el panel (`1m`, `5m`, `15m`, `25m Pomodoro`, `45m`, etc.) para seleccionar y arrancar timers con un solo clic.
3. **Pulido Visual y UX:**
   - Panel redimensionado (`width = 340`, `height = 320`) para acomodar la fila de presets de forma estética.
   - Reseteo y validaciones limpias en `panel.luau` y `service.luau`.
4. **Repositorio Git Independiente:** Control de versiones conectado a GitHub (`CodeLoverKawai/noctalia-timer`) y sincronizado con `~/.local/state/noctalia/plugins/materialized/official/timer`.

---

## 2. Componentes y Modificaciones

### 2.1 Metadatos (`plugin.toml`)
- Incrementar versión a `1.3.0`.
- Configuración de panel: `height = 320`.
- Nuevos Settings globales / de panel:
  - `sound_enabled` (`bool`, default: `true`): Habilitar alarma sonora.
  - `custom_sound_path` (`string`, default: `""`): Audio personalizado opcional.
  - `presets` (`string`, default: `"1,5,15,25,45"`): Minutos de los botones rápidos.

### 2.2 Servicio Headless (`service.luau`)
- En `notifyUser()`:
  - Notificación de escritorio `noctalia.notify(...)`.
  - Si `sound_enabled`: reproducir `alarm.mp3` local mediante `pw-play` (o comando nativo).

### 2.3 Panel Interactivo (`panel.luau`)
- Fila visual de botones de presets (`ui.row` con variantes compactas).
- Al hacer clic en un preset (ej. `5m`): carga 300 segundos, actualiza el input y permite iniciar inmediatamente.

### 2.4 Traducciones (`translations/*.json`)
- Nuevas etiquetas para `sound_enabled`, `custom_sound_path`, presets y botones.
