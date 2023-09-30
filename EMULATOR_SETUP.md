# Firebase Local Emulator Setup Instructions
The Firebase local emulator suite is made of binaries that run locally to create an almost full fledged environment which enables local development, unit testing, prototyping and continuous integration. 

# Why use an Emulator?
- Fastest, no-cost way to safely develop with Firebase
- Helps developers to run their projects locally 
- Facilitates Continuous Integration and Development
- Enables developers to commit changes to production after local testing
- Helps to test rules changes locally
  
# Setup 
## Pre-Install 
- Before installing Emulator Suite you will need Node.js and JAVA JDK. 
- Navigate to terminal 
- Install Node.js version 8.0 or higher either using one of the package managers below or directly through [macOS Installer](https://nodejs.org/en/#home-downloadhead).
  - Using nvm:
    ```sh
    nvm install node
    ```
  - Using homebrew:
    ```sh
    brew install node
    ```
  - Using Macports:
    ```sh
    port install nodejs<major version>
    ```
- Install Java JDK version 11 or higher. Find installation instructions [here](https://docs.oracle.com/en/java/javase/20/install/installation-jdk-macos.html)
- Install Firebase CLI 
  ```sh
  $ npm install -g firebase-tools  
  ```
- Login to firebase 
  ```sh
  npm install -g firebase-tools
  ```

# Installation Instructions
- Find detailed instructions on how to setup Firebase Local Emulator [here](https://peterfriese.github.io/MakeItSo/tutorials/makeitso/02-developing-locally-with-the-emulator-suite/)

# Usage Instructions
- Refer to this [video](https://www.youtube.com/watch?v=pkgvFNPdiEs) to get acquainted with the Firebase Emulator UI.
- Refer to this [video](https://www.youtube.com/watch?v=kVaNbNEa1Zk) for instructions on how to connect the front-end of the application to the local emulator suite. Following the official documentation gets a bit tricky in this part and this video helps offer clarity. 

# Execution Details
- Navigate to terminal and the directory where you want to clone the project
- Clone Basic-Car-Maintenance github repository
```sh
git clone https://github.com/mikaelacaron/Basic-Car-Maintenance
```
- Install dependencies with npm
```sh
npm intall
```
- Execute application locally 
```sh
firebase emulators:start --project=demo-Basic-Car-Maintenance --import=seed
```
- The demo prefix in the project id tells firebase that you want to work completely offline. 
- This means firebase will substitute in configurations locally rather than fetching from the Firebase Console. 
- It is not possibe to create a project with the demo prefix in a firebase console.