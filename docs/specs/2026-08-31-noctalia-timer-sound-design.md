# Especificación de Diseño: Noctalia Timer con Soporte de Sonido

**Fecha:** 2026-08-31  
**Repositorio:** `CodeLoverKawai/noctalia-timer`  
**Ruta Local:** `/home/rousseau/Projects/noctalia-timer`  
**Plugin ID:** `noctalia/timer` (o `community/timer-sound`)

---

## 1. Propósito y Alcance
Proveer un repositorio independiente y versionado para el plugin **Timer de Noctalia Shell**, incorporando la funcionalidad de **alarma sonora al finalizar el conteo regresivo** (con toggle de activación y selector de sonido personalizado / predeterminado `alarm.mp3`).

---

## 2. Arquitectura de Archivos y Componentes

```
Projects/noctalia-timer/
├── plugin.toml           # Metadatos del plugin, widgets, settings (sound_enabled, custom_sound_path)
├── service.luau          # Lógica headless de conteo, estado reactivo y emisión de sonido con pw-play / API nativa
├── bar.luau              # Widget de barra superior
├── panel.luau            # Panel desplegable interactivo
├── desktop.luau          # Widget anclado en escritorio
├── alarm.mp3             # Audio de alarma predeterminado
├── translations/         # Traducciones multilingüe (en, es, etc.)
└── README.md             # Documentación de instalación y uso en Noctalia
```

---

## 3. Comportamiento y Configuración

### 3.1 Settings (`plugin.toml`)
- `sound_enabled` (`bool`, default: `true`): Permite activar/desactivar la alarma.
- `custom_sound_path` (`string`, default: `""`): Ruta a archivo de sonido personalizado (`.mp3`, `.wav`, `.ogg`). Si está vacío, usa `alarm.mp3`.

### 3.2 Lógica en `service.luau` (`notifyUser`)
Al llegar el contador a cero (`STATE == "NOTIFY"`):
1. Envía la notificación nativa `noctalia.notify(...)`.
2. Si `sound_enabled == true`:
   - Si `custom_sound_path` no está vacío: `pw-play "<custom_sound_path>"`.
   - Si está vacío: reproduce `alarm.mp3` local mediante `pw-play` o `noctalia.sound.play`.

---

## 4. Estrategia de Git y GitHub
- Inicializar git en `/home/rousseau/Projects/noctalia-timer`.
- Crear el repositorio público/privado en GitHub bajo la cuenta `CodeLoverKawai` mediante GitHub CLI (`gh repo create noctalia-timer --public --source=. --push`).
- Enlazar el plugin materializado en `~/.local/state/noctalia/plugins/materialized/` para pruebas en vivo.
