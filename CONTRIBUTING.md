# Contribution Guidelines
This document contains the rules and guidelines that developers are expected to follow, while contributing to this repository.

* All contributions must NOT add any SwiftLint warnings or errors. There is a GitHub action setup for any PRs to `dev`, and Xcode will show any warnings/errors.

# About the Project
This app was created for [Hacktoberfest](https://hacktoberfest.com/), to help beginners in iOS dev contribute to open source. It is an app to help keep track of your car maintenance activites. This project uses [Firebase](https://firebase.google.com), [Firestore](https://firebase.google.com/products/firestore), and Sign in With Apple.

### Project Status
This app will be deployed on the Apple App Store, available for iOS 17.0 or later, [Mikaela Caron](https://github.com/mikaelacaron) (the maintainer) will upload it to the App Store after Hacktoberfest.

## 📁 Project Structure
```
Basic-Car-Maintenance/
├── .github/                                               # GitHub-specific configurations and templates
│   ├── CODEOWNERS                                         # Defines individuals responsible for code in repository
│   ├── FUNDING.yml                                        # Configuration for GitHub Sponsors funding
│   ├── ISSUE_TEMPLATE/                                    # Templates for creating GitHub issues
│   │   ├── bug-report.md                                  # Template for reporting bugs
│   │   ├── feature-request.md                             # Template for requesting new features
│   │   └── improve.md                                     # Template for suggesting improvements
│   ├── pull_request_template.md                           # Template for pull request submissions
│   └── workflows/                                         # GitHub Actions workflow configurations
│       ├── docc.yml                                       # Workflow for building DocC documentation
│       ├── issue-metrics.yml                              # Workflow for tracking issue statistics
│       ├── swiftlint.yml                                  # Workflow for Swift code linting
│       └── unit-tests.yml                                 # Workflow for running unit tests
├── .gitignore                                             # Specifies intentionally untracked files to ignore
├── .swiftlint.yml                                         # Configuration for Swift linting rules
├── Basic-Car-Maintenance-Tests/                           # Unit tests for the application
│   └── Shared/
│       └── Models/
│           └── ContributorTests.swift                     # Tests for Contributor model
├── Basic-Car-Maintenance-UITests/                         # UI tests for the application
│   └── BasicCarMaintenanceUITests.swift                   # UI test suite for the app
├── Basic-Car-Maintenance-Widget/                          # Widget extension for the app
│   ├── AppIntent.swift                                    # Defines app intents for widget interactions
│   ├── Assets.xcassets/                                   # Asset catalog for widget resources
│   ├── BasicCarMaintenanceWidget.swift                    # Main widget implementation
│   ├── BasicCarMaintenanceWidgetBundle.swift              # Widget bundle definition
│   ├── BasicCarMaintenanceWidgetEntryView.swift           # Entry view for widget display
│   ├── CarInfoWithMaintenanceEventsCount.swift            # View for showing maintenance count
│   ├── DataService.swift                                  # Service for providing data to the widget
│   ├── ErrorView.swift                                    # View for displaying errors in the widget
│   ├── Extensions/                                        # Extensions for widget functionality
│   │   ├── ConfigurationAppIntent+Demo.swift              # Demo data for configuration
│   │   └── MaintenanceEventsCountEntry+Demo.swift         # Demo entries for widget
│   ├── Info.plist                                         # Widget configuration information
│   ├── SmallMaintenanceEventsCountWidgetView.swift        # Small widget view implementation
│   └── VehicleAppEntity.swift                             # Entity representing vehicles in widgets
├── Basic-Car-Maintenance-WidgetExtension.entitlements     # Permission definitions for widget
├── Basic-Car-Maintenance.xcconfig.template                # Template for Xcode configuration
├── Basic-Car-Maintenance.xcodeproj/                       # Xcode project file container
├── Basic-Car-Maintenance.xctestplan                       # Test plan configuration
├── Basic-Car-Maintenance/                                 # Main application source code
│   ├── Assets.xcassets/                                   # Application asset catalog
│   ├── Basic_Car_Maintenance.entitlements                 # App permissions and entitlements
│   ├── Documentation.docc/                                # DocC documentation source files
│   │   ├── AppDesign.md                                   # Documentation about app architecture
│   │   ├── AppStoreListing.md                             # App Store description information
│   │   ├── Documentation.md                               # Main documentation landing page
│   │   ├── FirestoreCollections.md                        # Database structure documentation
│   │   ├── Images/                                        # Images used in documentation
│   │   ├── Tutorial Table of Contents.tutorial            # Structure of tutorials
│   │   ├── branch-updates.tutorial                        # Tutorial for branch management
│   │   └── getting-started.tutorial                       # Getting started tutorial
│   ├── Preview Content/                                   # Resources for SwiftUI previews
│   └── Shared/                                            # Shared code across the application
│       ├── BasicCarMaintenanceApp.swift                   # Main app entry point
│       ├── Dashboard/                                     # Dashboard feature module
│       │   ├── CSVEncoder.swift                           # CSV export functionality
│       │   ├── CarMaintenancePDFGenerator.swift           # PDF report generation
│       │   ├── ViewModels/                                # Dashboard view models
│       │   └── Views/                                     # Dashboard views
│       ├── GoogleService-Info.plist                       # Firebase configuration
│       ├── Info.plist                                     # App configuration information
│       ├── Localizable.xcstrings                          # App localization strings
│       ├── MainView/                                      # Main tab view feature module
│       │   ├── ViewModels/                                # Main view models
│       │   └── Views/                                     # Main view components
│       ├── Models/                                        # Data models for the application
│       │   ├── Action.swift                               # Model for user actions
│       │   ├── AlertItem.swift                            # Model for alert notifications
│       │   ├── AppIcon.swift                              # Model for customizable app icons
│       │   ├── Contributor.swift                          # Model for project contributors
│       │   ├── MaintenanceEvent.swift                     # Model for maintenance records
│       │   ├── OdometerReading.swift                      # Model for odometer data
│       │   └── Vehicle.swift                              # Model for vehicle information
│       ├── Odometer/                                      # Odometer tracking feature module
│       │   ├── ViewModels/                                # Odometer view models
│       │   └── Views/                                     # Odometer view components
│       ├── Onboarding/                                    # User onboarding feature module
│       │   └── Views/                                     # Onboarding view components
│       ├── PrivacyInfo.xcprivacy                          # Privacy declarations for App Store
│       ├── Settings/                                      # Settings feature module
│       │   ├── ViewModels/                                # Settings view models
│       │   └── Views/                                     # Settings view components
│       ├── Tips/                                          # In-app tips feature
│       │   └── ContributionTip.swift                      # Tip for contributing to the project
│       └── Utilities/                                     # Utility classes and extensions
│           ├── AnalyticsService.swift                     # Service for tracking app analytics
│           ├── Bundle+extension.swift                     # Extension for Bundle class
│           ├── Constants.swift                            # App-wide constants
│           ├── FirebaseAnalytics+Extension.swift          # Extensions for Firebase Analytics
│           ├── MeasurementSystem.swift                    # Support for different measurement units
│           └── PageDimension.swift                        # Utilities for page layout dimensions
├── CODE_OF_CONDUCT.md                                     # Community conduct guidelines
├── CONTRIBUTING.md                                        # Guidelines for contributing to the project
├── Configurations/                                        # Build configurations
│   ├── Project.xcconfig                                   # Main project configuration
│   ├── UITests.xcconfig                                   # UI tests configuration
│   ├── UnitTests.xcconfig                                 # Unit tests configuration
│   └── Widget.xcconfig                                    # Widget configuration
├── Gemfile                                                # Ruby dependencies for development tools
├── Gemfile.lock                                           # Locked versions of Ruby dependencies
├── LICENSE                                                # Project license information
├── README.md                                              # Project overview and documentation
├── backend/                                               # Backend infrastructure files
│   ├── .firebaserc                                        # Firebase project configuration
│   ├── .gitignore                                         # Backend-specific Git ignore rules
│   ├── firebase.json                                      # Firebase service configuration
│   ├── firestore.indexes.json                             # Firestore index definitions
│   └── firestore.rules                                    # Firestore security rules
├── build-docc.sh                                          # Script to build DocC documentation
└── fastlane/                                              # CI/CD automation configuration
    ├── .xcovignore                                        # Files to ignore in code coverage
    ├── Appfile                                            # App-specific fastlane configuration
    ├── Fastfile                                           # Fastlane workflow definitions
    ├── README.md                                          # Fastlane documentation
    └── enable-build-tool-plugins.json                     # Build tool plugin configuration
```
# Getting Started
## Prerequisites
* Download Xcode 16.0 or later
* Set your Xcode settings correctly:
   * Open Xcode Settings `Cmd + ,`
   * Text Editing
   * Indentation tab
   * Prefer Indent using Spaces
   * Tab Width: 4
   * Indent Width: 4
   * Xcode 16+
      * Check "Prefer Settings from EditorConfig"

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

## Setup the Firebase Emulator
We are going to set up the Firebase emulator to be able to load the data locally and not affect production. Please do not skip this step.
* Install [Homebrew](https://brew.sh/)
   * Package manager for macOS, to install more things
* Install Xcode command line tools with `xcode-select --install`
* `brew install nvm`
   * Installs node version manager, so you don't need to update the system node version
   * Add the executable to the $PATH via .zshrc or .bashrc file as prompted after installation, do **NOT** forget this! (and then restart your Terminal)
* `nvm install stable`
* `nvm use stable`
   * to download and use the latest stable version of node
* `brew install openjdk`
   * Add the executable to the $PATH via .zshrc or .bashrc file as prompted after installation, do **NOT** forget this! (and then restart your Terminal)
* `npm install -g firebase-tools`
   * Installs the Firebase tools for running the emulator


## Start Working on an Issue
* Anytime you run the project, first in Terminal `cd` to `backend` in the `Basic-Car-Maintenance` directory
   * this is the directory with the `firebase.json` file, you should see that if you type `ls`
* Run this command, which will start the emulators, and keep your data in `local-data` directory.
```sh
firebase emulators:start --import=./local-data --export-on-exit
```
   * Meaning when you start and stop the emulator your data will persist.
* Run the app
   * You should see your anonymous user in Authentication, and once you add new data, see it in Firestore emulator UI at: http://127.0.0.1:4000/firestore
   * If you don't see your user, delete the app from the simulator, and in the menu go to Device > Erase All Content and Settings (which resets your simulator), and try to run again
   * If you receive the following error when you launch the emulator: _'firebase-tools no longer supports Java version before 11. Please upgrade to Java version 11 or above to continue using the emulators.'_ The openJDK install failed and you will have to install the latest JDK manually. You can download the latest version here [JDK23](https://www.oracle.com/java/technologies/downloads/#jdk23-mac)
* **Checkout** a new branch (from the `dev` branch) to work on an issue
* When your feature / fix is complete open a pull request, PR, from your feature branch to the `dev` branch
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
