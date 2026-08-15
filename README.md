# LogClock

A tiny, always-on-top stopwatch for tracking time as you work — start it,
let it run in the background, and copy the elapsed time to your clipboard
in a ready-to-paste format (e.g. `1h 30m`) whenever you need it, for logging
work in Jira, timesheets, or anywhere else.

A native macOS menu bar app, built with SwiftUI.

## Features

- **Start / pause** a single running timer, with a big monospaced clock
  display
- **Copy time** — copies the elapsed time to your clipboard in a compact
  format, with a brief checkmark confirmation
- **Reset on copy** — optional setting to zero the timer out automatically
  right after copying, so you're ready for the next task
- **Pause on locked** — optional setting to auto-pause the timer when your
  screen locks, and resume it when you're back
- **Quit** — quick way to exit from the menu bar
- Small, unobtrusive window designed to sit out of the way while you work

## Settings

| Setting | Default | What it does |
|---|---|---|
| Reset on copy | On | Resets the timer to 0 right after copying the elapsed time |
| Pause on locked | On | Auto-pauses the timer when the screen locks, resumes on unlock |

Both settings persist between launches.

## Installation

1. Go to the [Releases](../../releases) page.
2. Download the latest `LogClock.dmg`.
3. Open the DMG and drag **LogClock** into your **Applications** folder.
4. Launch LogClock from Applications (or Spotlight). On first launch,
   macOS Gatekeeper may ask you to confirm you want to open it, since
   it's downloaded from the internet rather than the App Store —
   right-click the app and choose **Open** if it's blocked.

## Building from source

Open the Xcode project and run the `LogClock` scheme.

## License

Add your license here.
