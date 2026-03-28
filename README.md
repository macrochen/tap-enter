# Tap Enter

Tap Enter is a lightweight macOS utility for sending a few high-frequency text snippets anywhere you can type.

## MVP

- Menu bar app
- Up to five snippets
- One global shortcut per snippet
- Optional auto-enter after typing
- Accessibility permission guidance
- Default shortcuts are `Ctrl+Opt+Cmd+1...5`
- Supports login-item startup
- Per-snippet send delay and per-character interval tuning

## Run

1. Open `/Users/shi/workspace/my-skills/tap-enter/Package.swift` in Xcode
2. Run the `TapEnter` scheme
3. Grant Accessibility permission when prompted

## Build App Bundle

To produce a standalone `.app` bundle:

```bash
cd /Users/shi/workspace/my-skills/tap-enter
./scripts/build-app.sh
```

The generated app will be placed at:

- `/Users/shi/workspace/my-skills/tap-enter/dist/Tap Enter.app`

Optional custom icon support:

- Put `/Users/shi/workspace/my-skills/tap-enter/assets/AppIcon.icns` in place before building
- The bundle script will copy it automatically

## Notes

- The app uses keyboard event simulation, so it depends on macOS Accessibility permission.
- Global shortcut registration is implemented with the macOS Carbon hot key API.
- Login-at-startup uses `SMAppService`, which takes effect when the app is run as a bundled app.
- Sending prefers the current frontmost app and falls back to the last observed target app.
- The bundle script generates a menu-bar-style app by setting `LSUIElement` to `true`.
