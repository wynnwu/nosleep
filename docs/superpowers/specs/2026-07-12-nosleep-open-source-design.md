# nosleep, open-source packaging design

Date: 2026-07-12 · Status: approved

## Goal

Publish the existing `nosleep` script (toggle macOS `pmset disablesleep` with
optional auto-off timer and colored owl notifications) as an installable
open-source tool under `github.com/wynnwu/nosleep`.

## Decisions

- **Source repo:** `wynnwu/nosleep`, standalone. Related to but independent of
  `wynnwu/agent-m`; the two cross-promote in their READMEs ("Need to keep your
  Mac awake? Try nosleep. Need to watch your agents? Try Agent-M.").
- **Install paths:** both Homebrew (`brew install wynnwu/tap/nosleep`, formula
  in a new `wynnwu/homebrew-tap` repo) and a curl one-liner (`install.sh`).
  The tap can later also serve Agent-M.
- **License:** MIT.
- **Extras:** ShellCheck CI + macOS smoke test (GitHub Actions), demo image in
  the README (SVG terminal mock), man page `nosleep.1`.

## Repo layout

```
nosleep                    # the script (adds VERSION, help, version subcommands)
install.sh                 # curl installer; local-clone aware; ~/.local/bin or /usr/local/bin
README.md                  # demo image, install, usage, how-it-works, warnings, Agent-M plug
LICENSE                    # MIT
man/nosleep.1              # man page
assets/demo.svg            # owl notification demo
.github/workflows/ci.yml   # shellcheck (ubuntu) + no-sudo smoke test (macos)
```

## Release process

1. Tag `vX.Y.Z` on `wynnwu/nosleep`, push tag, create GitHub release.
2. `curl -sL https://github.com/wynnwu/nosleep/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256`
3. Bump `url` + `sha256` in `homebrew-tap/Formula/nosleep.rb`, push.

## Behavior notes (unchanged from the local script)

- Timed mode launches a detached root process at invocation time (while sudo
  credentials are fresh); it needs no password when it fires.
- New state changes always cancel the pending timer first, timers replace,
  never stack. Pidfile: `/tmp/nosleep-timer.pid` ("pid deadline-epoch").
- `disablesleep` persists across reboots; the timer does not (documented
  warning in README and man page).
