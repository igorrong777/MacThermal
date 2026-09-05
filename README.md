# MacThermal

A tiny native macOS menu bar utility for monitoring system thermal state.

**Tiny. Native. Private. Free.**

- No analytics
- No networking code
- No background polling
- No account
- No subscription
- No Dock icon
- Uses the native macOS thermal state API

## What it does

MacThermal shows the current macOS thermal state directly in the menu bar:

- Normal
- Elevated
- High
- Critical

It listens for macOS thermal state changes instead of continuously polling hardware sensors, keeping idle CPU usage close to zero.

## Build

Requirements:

- macOS
- Apple Command Line Tools / Swift

Build:

    ./build.sh

The app will be created at:

    /tmp/MacThermalBuild/MacThermal.app

Run:

    open /tmp/MacThermalBuild/MacThermal.app

## Privacy

MacThermal:

- does not contain networking code
- does not collect or store user data
- does not use analytics or telemetry
## License

MIT
