# nosleep 1.1.0, clean mode design

Date: 2026-07-13 · Status: approved

## Goal

`nosleep clean` quits every Dock application except a user-managed whitelist -
the same effect as manually Cmd-Q-ing them, to cut power and network use
while the Mac runs lid-closed, then enables no-sleep.

## Commands

- `nosleep clean`, interactive quit flow, then No Sleep ON (indefinite).
- `nosleep 1h clean` / `nosleep clean 1h`, quit flow, then timed no-sleep.
  When the timer fires only sleep is restored; quit apps stay quit.
- `nosleep whitelist`, manage the whitelist.

## Rules

- **Dock apps only**: enumerated via System Events
  (`every process whose background only is false`); menu-bar/background apps
  are never touched. First use triggers macOS's one-time Automation
  permission prompt.
- **Protected, never quit**: Finder, and the host terminal detected from
  `$TERM_PROGRAM` (Terminal, iTerm2, VS Code, Ghostty, WezTerm).
- **Graceful quits**: `osascript 'tell application X to quit'` inside
  `ignoring application responses` so a save-dialog can't hang the script.
  Unsaved-work dialogs appear exactly as with a manual quit.
- **Warn + deselect**: clean lists the apps it will quit, all pre-selected;
  the user can toggle by number, (a)ll/(n)one, then (y) proceed or (q) abort.
  Abort does nothing at all (no sleep change).
- **First-run gate**: `nosleep clean` refuses to run until
  `nosleep whitelist` has been run and saved at least once (whitelist file
  exists, an empty saved whitelist counts).
- **Interactive only**: both `clean` and `whitelist` require a tty; they
  refuse to run piped/scripted so apps can never be quit by accident.

## Whitelist

- File: `$XDG_CONFIG_HOME/nosleep/whitelist` (default
  `~/.config/nosleep/whitelist`), one app name per line, `#` comments.
- Manager UI lists running Dock apps with `[x]` marks for whitelisted ones,
  plus whitelisted-but-not-running entries (removable). Header note: the list
  pulls from running apps, to whitelist a new app, launch it first.
  (s)ave writes the file; (q) cancels.

## Out of scope (deliberate)

- No `--yes` non-interactive mode.
- No restore/relaunch of quit apps after a timer.

## Release

Version 1.1.0: script, man page, README, CI smoke additions (non-tty and
first-run-gate failure paths), then RELEASING.md flow (tag → sha256 →
formula bump).
