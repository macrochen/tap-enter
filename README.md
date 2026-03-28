# Tap Enter

Tap Enter is a lightweight macOS menu bar app for sending a few high-frequency text snippets anywhere you can type.

It is designed for the "one key combo, instant send" workflow:

- up to five saved snippets
- one global shortcut per snippet
- optional auto-enter after typing
- login-at-startup support
- per-snippet timing controls for better compatibility

## Use Cases

Tap Enter is a good fit when you repeatedly send the same short replies, for example:

- "收到，我来处理。"
- "稍等一下，我马上回复你。"
- "谢谢！"
- "好的"
- "马上处理。"

If you need dozens of phrases, an input method phrase system is usually a better fit. Tap Enter is optimized for a very small set of ultra-frequent snippets.

## Features

- Menu bar app with no Dock icon
- Up to 5 snippets
- One global shortcut per snippet
- Default shortcuts: `Ctrl+Opt+Cmd+1...5`
- Optional auto-enter after typing
- Accessibility permission guidance
- Login item support
- Per-snippet send delay
- Per-snippet per-character interval tuning

## Requirements

- macOS 14+
- Accessibility permission enabled for the app

## Run In Xcode

1. Open [`Package.swift`](./Package.swift) in Xcode
2. Run the `TapEnter` scheme
3. Grant Accessibility permission when prompted

## Build A Standalone App

```bash
cd /Users/shi/workspace/my-skills/tap-enter
./scripts/build-app.sh
```

The generated app bundle will be created at:

- `/Users/shi/workspace/my-skills/tap-enter/dist/Tap Enter.app`

## Optional App Icon

If you want a custom icon:

1. Create an `.icns` file
2. Save it to `/Users/shi/workspace/my-skills/tap-enter/assets/AppIcon.icns`
3. Run `./scripts/build-app.sh` again

## How It Works

- Global shortcuts are registered with the macOS Carbon hot key API
- Text is injected through keyboard event simulation
- Sending prefers the current frontmost app and falls back to the last observed target app
- Login-at-startup uses `SMAppService`
- The generated bundle uses `LSUIElement=true`, so it behaves like a menu bar utility

## Limitations

- This app depends on macOS Accessibility permission
- Compatibility can vary slightly across chat apps, browsers, terminals, and editors
- Very long text may need a slightly higher send delay or per-character interval
- Login-at-startup works best when using the generated `.app` bundle

## Development

Build locally:

```bash
swift build
```

This repository also includes a GitHub Actions workflow that runs `swift build` on pushes to `main` and on pull requests.

## License

[MIT](./LICENSE)
