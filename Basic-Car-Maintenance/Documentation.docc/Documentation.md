# Basic-Car-Maintenance

A basic app to track your car's maintenance, like oil changes, tire rotation, etc.

## Overview

This app is open source for Hacktoberfest 2023! More documentation to be added soon!

## New Icon
The app icon contains a Car, Tools, and Gear

Icons have the following colors:

* Yellow #FFC91F
* Red #DA1918
* Blue #253AA7
* Black #000000
* Orange #F78616

## Firestore Collections

**_alerts_**  
The alerts collection contains system level alerts that will be visable to all users

| Fields    | Type    |
| --------- | ------- |
| actionTex | Text    |
| actionURL | Text    |
| emojiIcon | Text    |
| id        | Text    |
| isOn      | Boolean |
| message   | Text    |
| title     | Text    |

**_maintainance_events_**  
Maintainance events collection contains the individual maintainance events that are associated
with a specific user.

| Fields    | Type       |
| --------- | ---------- |
| id        | DocumentID |
| userID    | Text       |
| title     | Text       |
| date      | Date       |
| notes     | Text       |
| vehicleID | Text       |

**_vehicles_**  
The vehicles collection contains all the vehicles associated with a specific user.

| Fields             | Type       |
| ------------------ | ---------- |
| id                 | DocumentID |
| userID             | Text       |
| name               | Text       |
| make               | Text       |
| model              | Text       |
| year               | Text       |
| color              | Text       |
| vin                | Text       |
| licensePlateNumber | Text       |

## Firestore Rules

**alerts** : read-only for all users

**maintainance_events** : Authorized users can read and write to the
maintainance events collection that is associated with their user id.

**vehicles**: Authorized users can ready and write to vehicles collection that is associated with their user id.

```
rules_version = '1';
service cloud.firestore {
match /databases/{database}/documents {

        match /alerts/{document=\*\*} {
        allow read;
        }

        match /maintainance+events/{allPaths=**} {
        allow read, write: if request.auth != null;
        }

        match /vehicles/{allPaths=**} {
        allow read, write: if request.auth != null;
        }
    }

}
```
