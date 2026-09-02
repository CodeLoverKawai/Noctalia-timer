--!nonstrict
-- Countdown timer service - the headless [[service]] entry.
--
-- The service owns the timer state and handles the countdown logic.
-- It publishes state changes to other entries via noctalia.state,
-- and listens for commands (START, PAUSE, RESET) from panel and bar.
--
--   noctalia.setUpdateInterval(ms)     set tick rate for countdown
--   noctalia.state.set(key, value)     publish state to other entries
--   noctalia.state.watch(key, fn)      react to commands from UI entries
--   noctalia.notify(title, body)       alert user when timer completes

noctalia.setUpdateInterval(1000)

local function formatTime(seconds)
  local m = seconds // 60
  local s = seconds % 60
  if m >= 60 then
    return `{m // 60}:{string.format("%02d", m % 60)}:{string.format("%02d", s)}`
  end
  return `{m}:{string.format("%02d", s)}`
end

---- Initialize state
noctalia.state.set("timer.state", "IDLE") -- IDLE, NOTIFY, RUNNING, PAUSED
noctalia.state.set("timer.remaining", 0)
noctalia.state.set("timer.formattedTime", "0")
-- The countdown total captured when the timer starts, so UI entries can render
-- a progress bar (remaining / duration). Reset to 0 when the timer is cleared.
noctalia.state.set("timer.duration", 0)

noctalia.state.watch("timer.remaining", function (value)
  noctalia.state.set("timer.formattedTime", formatTime(value))
end)

local function stopSound()
  if noctalia.runAsync then
    noctalia.runAsync("sh -c 'pkill -9 -f \"noctalia_alarm_loo[p]\" 2>/dev/null; pkill -9 -f \"noctalia_alarm_singl[e]\" 2>/dev/null; pkill -9 -x \"pw-play|paplay|pw-cat|pacat|mpv|aplay\" 2>/dev/null; killall -9 pw-play paplay pw-cat pacat mpv aplay 2>/dev/null || true' noctalia_alarm_killer")
  end
  if noctalia.sound and noctalia.sound.stop then
    pcall(function()
      noctalia.sound.stop("alarm")
    end)
  end
end

local function playAlarmSound()
  local soundEnabled = noctalia.getConfig("sound_enabled")
  if soundEnabled == nil then
    soundEnabled = true
  end

  if not soundEnabled then
    return
  end

  local customPath = noctalia.state.get("timer.custom_sound_path")
  if not customPath or customPath == "" then
    customPath = noctalia.getConfig("custom_sound_path")
  end
  local audioTarget = ""

  if customPath and customPath ~= "" then
    audioTarget = customPath
  else
    local dir = ""
    if type(noctalia.pluginDir) == "function" then
      dir = noctalia.pluginDir() or ""
    elseif type(noctalia.pluginDir) == "string" then
      dir = noctalia.pluginDir
    end

    if dir == "" then
      dir = "/home/rousseau/.local/state/noctalia/plugins/materialized/codeloverkawai/timer-sound"
    end
    audioTarget = `{dir}/alarm.mp3`
  end

  local repeatAlarm = noctalia.getConfig("repeat_alarm")
  if repeatAlarm == nil then
    repeatAlarm = true
  end

  local safePath = audioTarget:gsub('"', '\\"')

  if noctalia.runAsync then
    if repeatAlarm then
      -- Loop playback sequentially without overlapping (wait for each play to finish before looping)
      local loopCmd = `sh -c 'while true; do pw-play "$1" 2>/dev/null || paplay "$1" 2>/dev/null || mpv --no-video "$1" 2>/dev/null || break; done' noctalia_alarm_loop "{safePath}" &`
      noctalia.runAsync(loopCmd)
    else
      -- Single playback
      local singleCmd = `sh -c 'pw-play "$1" 2>/dev/null || paplay "$1" 2>/dev/null || mpv --no-video "$1" 2>/dev/null' noctalia_alarm_single "{safePath}" &`
      noctalia.runAsync(singleCmd)
    end
  elseif noctalia.sound and noctalia.sound.play then
    noctalia.sound.play("alarm")
  end
end

-- send notification and sound when timer finishes
local function notifyUser()
  noctalia.notify(noctalia.tr("ui.notify_title"), noctalia.tr("ui.notify_body"))
  playAlarmSound()
end

noctalia.state.watch("timer.cmd", function(cmd)
  if not cmd or cmd == "" then
    return
  end

  local actions = {
    PAUSE = function()
      stopSound()
      noctalia.state.set("timer.state", "PAUSED")
    end,
    START = function ()
      stopSound()
      local remaining = noctalia.state.get("timer.remaining")
      local STATE = noctalia.state.get("timer.state")

      if (STATE == "IDLE" or STATE == "PAUSED") and (remaining or 0) > 0 then
        -- Capture the total on a fresh start so progress bars have a baseline;
        -- leave it untouched when resuming from PAUSED.
        if STATE == "IDLE" then
          noctalia.state.set("timer.duration", remaining)
        end
        noctalia.state.set("timer.state", "RUNNING")
      end
    end,
    STOP = function ()
      stopSound()
      noctalia.state.set("timer.remaining", 0)
      noctalia.state.set("timer.duration", 0)
      noctalia.state.set("timer.state", "IDLE")
    end,
    RESET = function ()
      stopSound()
      noctalia.state.set("timer.remaining", 0)
      noctalia.state.set("timer.duration", 0)
      noctalia.state.set("timer.state", "IDLE")
    end
  }

  local action = actions[cmd]
  if action then
    action()
  else
    noctalia.log(`Unknown command: {cmd}`)
  end

  -- Clear command so subsequent identical commands always fire state watchers
  noctalia.state.set("timer.cmd", "")
end)

-- Stop any lingering processes on initialization
stopSound()

pcall(function()
  if noctalia.sound and noctalia.sound.load then
    noctalia.sound.load("alarm", "alarm.mp3", function(ok, err)
      if not ok and err then
        noctalia.log(`Failed to preload alarm sound: {err}`)
      end
    end)
  end
end)

function update()
  local STATE = noctalia.state.get("timer.state") or "IDLE"
  local remaining = noctalia.state.get("timer.remaining") or 0

  if STATE == "RUNNING" then
    if remaining > 0 then
      noctalia.state.set("timer.remaining", remaining - 1)
    else
      noctalia.state.set("timer.state", "NOTIFY")
      notifyUser()
    end
  end
end
