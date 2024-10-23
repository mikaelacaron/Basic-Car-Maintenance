# Basic Car Maintenance
![Static Badge](https://img.shields.io/badge/status-active-brightgreen)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/mikaelacaron/Basic-Car-Maintenance/dev?logo=github)
![GitHub contributors](https://img.shields.io/github/contributors/mikaelacaron/Basic-Car-Maintenance)
[![first-timers-only](https://img.shields.io/badge/first--timers--only-friendly-blue.svg)](https://www.firsttimersonly.com/)
[![Unit Tests](https://github.com/mikaelacaron/Basic-Car-Maintenance/actions/workflows/unit-tests.yml/badge.svg?event=push)](https://github.com/mikaelacaron/Basic-Car-Maintenance/actions/workflows/unit-tests.yml)
[![Deploy DocC Documentation](https://github.com/mikaelacaron/Basic-Car-Maintenance/actions/workflows/docc.yml/badge.svg?branch=dev)](https://github.com/mikaelacaron/Basic-Car-Maintenance/actions/workflows/docc.yml)

![Alt](https://repobeats.axiom.co/api/embed/889ac81d440c882bb217c6ee7dda4601e0d8d6d9.svg "Repobeats analytics image")

Welcome to my open source app! It is ready for contributors for [Hacktoberfest](https://hacktoberfest.com/)! Use this app to gain experience getting started in open source for iOS and macOS development using Swift and SwiftUI.

# Getting Started
* Read the [Code of Conduct](https://github.com/mikaelacaron/Basic-Car-Maintenance/blob/dev/CODE_OF_CONDUCT.md)
* Read the [CONTRIBUTING.md](https://github.com/mikaelacaron/Basic-Car-Maintenance/blob/dev/CONTRIBUTING.md) guidelines
* Download Xcode 16.0 or later
* Browse the open [issues](https://github.com/mikaelacaron/Basic-Car-Maintenance/issues) and **comment** which you would like to work on
   * It is only one person per issue, except where noted.
* **Fork** this repo
* **Clone** the repo to your machine (do **not** open Xcode yet)
* In the same folder that contains the `Basic-Car-Maintenance.xcconfig.template`, run this command, in Terminal, to create a new Xcode configuration file (which properly sets up the signing information)

```sh
cp Basic-Car-Maintenance.xcconfig.template Basic-Car-Maintenance.xcconfig
```

* Open Xcode

* In the `Basic-Car-Maintenance.xcconfig` file, fill in your `DEVELOPMENT_TEAM` and `PRODUCT_BUNDLE_IDENTIFIER`.
   * You can find this by logging into the Apple Developer Portal
   * This works with both free or paid Apple Developer accounts. Do **NOT** run this app on a real device due to issues with the Sign in With Apple capability.
```
DEVELOPMENT_TEAM = ABC123
PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.Basic-Car-Maintenance
```

* Build the project ✅

* Setup the Firebase emulator, following the steps in [CONTRIBUTING.md](https://github.com/mikaelacaron/Basic-Car-Maintenance/blob/dev/CONTRIBUTING.md#setup-the-firebase-Emulator)

> [!WARNING]
> DO **NOT** skip setting up the emulators! or your app won't work

* Start the emulator with: `firebase emulators:start --import=./local-data --export-on-exit`
  * Be sure to be in the `backend` folder that contains the `firebase.json` file.

* **Checkout** a new branch, from the `dev` branch, to work on an issue

# Contributing
To start contributing, review [CONTRIBUTING.md](https://github.com/mikaelacaron/Basic-Car-Maintenance/blob/main/CONTRIBUTING.md). New contributors are always welcome to support this project.

:eyes: **Please be sure to comment on an issue you'd like to work on and [Mikaela Caron](https://github.com/mikaelacaron), the maintainer of this project, will assign it to you!** You can only work on **ONE** issue at a time.

Checkout any issue labeled `hacktoberfest` to start contributing.

> [!IMPORTANT]
> View the [GitHub Discussions](https://github.com/mikaelacaron/Basic-Car-Maintenance/discussions) for the latest information about the repo.

## Issue Labels
* `first-timers-only` is only for someone who has **not** contributed to the repo yet! (and is new to open source and iOS development)
* `good-first-issue` is an issue that's beginner level

Please choose an appropriate issue for your skill level

### Contributors
<a href="https://github.com/mikaelacaron/Basic-Car-Maintenance/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mikaelacaron/Basic-Car-Maintenance" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

## Star History

<a href="https://star-history.com/#mikaelacaron/Basic-Car-Maintenance&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=mikaelacaron/Basic-Car-Maintenance&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=mikaelacaron/Basic-Car-Maintenance&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=mikaelacaron/Basic-Car-Maintenance&type=Date" />
  </picture>
</a>


# License
This project is licensed under [Apache 2.0](https://github.com/mikaelacaron/Basic-Car-Maintenance/blob/main/LICENSE).
