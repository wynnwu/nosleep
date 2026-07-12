# nosleep 🦉

Keep your Mac awake **with the lid closed**, with an auto-off timer so you don't cook your backpack.

<p align="center">
  <img src="assets/demo.svg" alt="nosleep demo, colored owl notifications for on, timed, and off states" width="620">
</p>

## Why

Closing a MacBook's lid forces sleep, every process gets suspended, mid-build, mid-download, mid-agent-run. App-level tools like `caffeinate` and Amphetamine hold *idle-sleep* assertions, which macOS simply ignores on clamshell sleep (always, on battery; and without an external display or extra helpers, on AC too).

The only switch that actually wins is `pmset disablesleep`, a root-level setting that blocks **all** system sleep. It's also easy to leave on by accident, which is how MacBooks end up hot in bags. `nosleep` wraps it with a toggle, a status view, and a self-disarming timer.

## Install

**Homebrew:**

```sh
brew install wynnwu/tap/nosleep
```

**curl:**

```sh
curl -fsSL https://raw.githubusercontent.com/wynnwu/nosleep/main/install.sh | bash
```

Or clone and run `./install.sh`. Installs a single bash script plus a man page; uninstall by deleting them (the installer prints the exact paths).

## Usage

| Command | Effect |
|---|---|
| `nosleep` | Toggle on/off |
| `nosleep on` | Stay awake until manually turned off 🔴 |
| `nosleep 30m` | Stay awake 30 minutes, then auto-restore 🟡 (also `45s`, `2h`) |
| `nosleep off` | Back to normal sleep 🟢 |
| `nosleep status` | Current state + time remaining |
| `nosleep clean` | Quit all Dock apps except your whitelist, then stay awake 🧹 |
| `nosleep 1h clean` | Same, and restore normal sleep after 1 hour |
| `nosleep whitelist` | Choose which apps survive a clean |
| `nosleep help` / `version` | The obvious |

A new duration **replaces** any pending timer, timers never stack. `nosleep 1h` followed by `nosleep 30m` means off in 30 minutes from the second call.

## Clean mode

Running lid-closed for hours? `nosleep clean` quits every Dock app except a whitelist you control, exactly as if you Cmd-Q'd them yourself, cutting power and network use before the long haul. Menu-bar apps, background agents, Finder, and the terminal you're running it from are never touched.

```sh
nosleep whitelist   # first time: pick the apps that survive (must be running to appear)
nosleep 8h clean    # quit the rest, stay awake 8 hours
```

`clean` always shows what it's about to quit and lets you deselect apps or abort; it refuses to run non-interactively. Quits are graceful, so apps with unsaved work show their normal save dialogs. After a timed clean, only sleep is restored, apps stay quit.

First use will trigger macOS's one-time Automation permission prompts (System Events to list apps, then one per app on the first quit). The whitelist lives in `~/.config/nosleep/whitelist`; note it's built from **currently running** apps, so launch an app before trying to whitelist it.

## How it works

State changes run `sudo pmset -a disablesleep`, so you'll be asked for your password (normal sudo caching applies). Timed mode also launches a detached **root** background process right then, it sleeps for the duration, then runs `pmset -a disablesleep 0`. Because it's already root, it needs no password later, and it survives closing the terminal. Cost while waiting: ~1-2 MB RAM, zero CPU.

## ⚠️ Warnings

- While on, your Mac stays fully awake with the lid closed **even on battery**. Don't bag it.
- `disablesleep` **persists across reboots**; the auto-off timer does not. If you reboot mid-timer, run `nosleep off` (or check `nosleep status`).
- macOS only. Requires an admin account (sudo).

## Related

Keeping your Mac awake so agents can work all night? Watch what they're doing with **[Agent-M](https://github.com/wynnwu/agent-m)**, a native menu-bar monitor for local Claude Code sessions.

## License

[MIT](LICENSE)
