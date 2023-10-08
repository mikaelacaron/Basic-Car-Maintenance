# Contribution Guidelines
This document contains the rules and guidelines that developers are expected to follow, while contributing to this repository.

* All contributions must NOT add any SwiftLint warnings or errors. There is a GitHub action setup for any PRs to `dev`, and Xcode will show any warnings/errors.

# About the Project
This app was created for [Hacktoberfest](https://hacktoberfest.com/), to help beginners in iOS dev contribute to open source. It is an app to help keep track of your car maintenance activites. This project uses [Firebase](https://firebase.google.com), [Firestore](https://firebase.google.com/products/firestore), and Sign in With Apple.

### Project Status
This is a deployed app on the Apple App Store, available for iOS 17.0 or later. After Hacktoberfest, a new version will be created and pushed to the App Store by [Mikaela Caron](https://github.com/mikaelacaron) (the maintainer).

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
* **Fork** the repo to your profile
* **Clone** to your computer
* Setup the upstream remote on your local machine by running this command, in Terminal

```sh
git remote add upstream https://github.com/mikaelacaron/Basic-Car-Maintenance.git
```

* In the `Basic-Car-Maintenance.xcconfig` file, fill in your `DEVELOPMENT_TEAM` and `PRODUCT_BUNDLE_IDENTIFIER`.
   * You can find this by logging into the Apple Developer Portal
   * This works with both free or paid Apple Developer accounts. Do **NOT** run this app on a real device due to issues with the Sign in With Apple capability.
```
DEVELOPMENT_TEAM = ABC123
PRODUCT_BUNDLE_IDENTIFIER = com.mycompany.Basic-Car-Maintenance
```
* Build the project ✅

* **BEFORE** starting on an issue, comment on the issue you want to work on.
   * This prevents two people from working on the same issue. [Mikaela](https://github.com/mikaelacaron) (the maintainer) will assign you that issue, and you can get started on it.

* Checkout a new branch (from the `dev` branch) to work on an issue
   * The `feature-name` part of the branch can be shortened or omitted and you add your username instead

```sh
git checkout -b issueNumber-feature-name
```
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
