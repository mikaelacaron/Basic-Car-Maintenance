# Contribution Guidelines
This document contains the rules and guidelines that developers are expected to follow, while contributing to this repository.

* All contributions must NOT add any SwiftLint warnings or errors. There is a GitHub action setup for any PRs to `dev`, and Xcode will show any warnings/errors.

# About the Project
This app was created for [Hacktoberfest](https://hacktoberfest.com/), to help beginners in iOS dev contribute to open source. It is an app to help keep track of your car maintenance activites. This project uses [Firebase](https://firebase.google.com), [Firestore](https://firebase.google.com/products/firestore), and Sign in With Apple.

### Project Status
This app will be deployed on the Apple App Store, available for iOS 17.0 or later, [Mikaela Caron](https://github.com/mikaelacaron) (the maintainer) will upload it to the App Store after Hacktoberfest.

# Getting Started
## Prerequisites
* Download Xcode 15.0 or later
* Install [SwiftLint](https://github.com/realm/SwiftLint) onto your machine via [Homebrew](https://brew.sh/)
   * This is not a requirement, but is preferred.
```sh
brew install swiftlint
```
* Set your Xcode settings correctly:
   * Open Xcode Settings `Cmd + ,`
   * Text Editing
   * Indentation tab
   * Prefer Indent using Spaces
   * Tab Width: 4
   * Indent Width: 4

## Start Here
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

* **Checkout** a new branch (from the `dev` branch) to work on an issue
* When your feature/fix is complete open a pull request, PR, from your feature branch to the `dev` branch
   * Use a descriptive PR title and fill out the entire PR template, do not delete any sections.

# Branches and PRs
* No commits should be made to the `main` branch directly. The `main` branch shall only consist of the deployed code
* Developers are expected to work on feature branches, and upon successful development and testing, a PR (pull request) must be opened to merge with `dev`
* Use kebab-case for branch names
✅ **Examples of valid branch names:**
   * 8123-fix-title-of-issue (issue number)
   * 8123-feature-name (issue number)
  
❌ **Examples of invalid branch names**:
   * username-testing
   * attemptToFixAuth
   * SomethingRandom

# Coding Style Guidelines
Developers should aim to write clean, maintainable, scalable and testable code. The following guidelines might come in handy for this:
* Swift: [Swift Best Practices](https://github.com/Lickability/swift-best-practices), by [Lickability](https://lickability.com)
