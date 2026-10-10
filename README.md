# SwiftUI Feature Flags Demo

A small runnable project for the companion article, "Turn Off a Broken Feature Without an App Store Update. Here Is How Feature Flags Work."

One checkout screen with two feature flags. A promo banner that is on by default, and a new checkout button that is off by default. The app reads the real values from [`flags.json`](flags.json) in this repo, so you can watch remote values replace the defaults.

## What is inside

- `FeatureFlag` lists every flag in one enum, each with a safe default value
- `FeatureFlags` is one `@Observable` object that answers "is this flag on?" for the whole app, and remembers the last values it fetched
- `FeatureFlagSource` is a small protocol for wherever the values come from, with `RemoteFlagSource` reading a JSON file over the network
- `CheckoutView` reads the flags from the environment, with previews for each combination
- `FeatureFlagsTests` covers defaults, remote overrides, missing keys, failed requests and values surviving a relaunch, using Swift Testing

## Requirements

- Xcode 16 or later
- iOS 17 or later

## Run it

This project is set up for XcodeGen, a tool that turns a plain YAML file into a real Xcode project.

1. Install XcodeGen once, with Homebrew.

   brew install xcodegen

2. From this folder, generate the project.

   xcodegen generate

3. Open it.

   open FeatureFlagsDemo.xcodeproj

4. Pick an iPhone simulator and run. Run the tests with Cmd+U.

If you would rather not install XcodeGen, create a new Xcode project named FeatureFlagsDemo, iOS App, SwiftUI, Swift, with Swift Testing as the testing system. Delete its generated ContentView.swift, FeatureFlagsDemoApp.swift and test file, then add Sources/FeatureFlagsDemo to the app target and Tests/FeatureFlagsDemoTests to the test target. Set the deployment target to iOS 17.

On the very first launch with no network you will see the defaults, the yellow banner and "Go to checkout". Once `flags.json` loads, the banner disappears and the button changes to "Pay with one tap".

## Change the flags yourself

The app reads `flags.json` from this repo on GitHub, which only the repo owner can edit. To flip the flags yourself, serve the copy in your own clone from your Mac. The Simulator shares your Mac's network, so it can reach it on `localhost`.

1. From this folder, start a small local web server.

   python3 -m http.server 8000

2. In `FeatureFlagsDemoApp.swift`, change the URL to the local file.

   URL(string: "http://localhost:8000/flags.json")!

3. Run the app in the Simulator.
4. Edit `flags.json` and save it, for example set `"newCheckout"` to `false`.
5. Go to the Home screen with Cmd+Shift+H, then open the app again. The screen updates straight away, with no relaunch.

This only works in the Simulator, because a real iPhone cannot reach your Mac as `localhost`.

If you would rather try it with a real remote file, fork this repo and point the URL at the raw `flags.json` in your fork. GitHub caches raw files for a few minutes, so a change can take a short while to show up.
