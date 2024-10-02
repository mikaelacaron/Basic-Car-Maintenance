# Firestore Collections

All about the Firebase Firestore data structure

![Firestore Diagram with sub-collections](FirestoreDiagram.png)

### alerts

The alerts collection contains system level alerts that will be visible to all users. The alerts
will only be displayed to the user once.

| Fields     | Firestore Type | Description |
| ---------- | -------------- | ----------- |
| actionText | Text           | Text that will appear on the action button
| actionURL  | Text           | URL that the user will be redirected to when the action button is tapped
| emojiIcon  | Text           | The emoji that will appear on the alert message
| id         | Text           | Identifies a specific alert
| isOn       | Boolean        | Toggles if the alert is active. Only one alert will be active at a time.
| message    | Text           | Text content of the alert
| title      | Text           | Main title given to the alert

### maintenance_events

Maintenance events collection contains the individual maintenance events that are associated
with a specific user.

| Fields    | Firestore Type | Description |
| --------- | -------------- | ----------- |
| id        | DocumentID     | Unique maintenance event identifier that is auto populated by Firestore
| userID    | Text           | Identifies the user associated with the maintenance event
| title     | Text           | Customized name given to the maintenance event
| date      | Date           | Date that the maintenance event was recorded
| notes     | Text           | Extra details about the maintenance event
| vehicleID | Text           | Identifies the vehicle associated with the maintenance event

### vehicles

The vehicles collection contains all the vehicles associated with a specific user.

| Fields             | Firestore Type | Description |
| ------------------ | -------------- | ----------- |
| id                 | DocumentID     | Unique vehicle identifier that is auto populated by Firestore
| userID             | Text           | Identifies the user associated with the vehicle
| name               | Text           | Customized name of the vehicle
| make               | Text           | The brand of the vehicle
| model              | Text           | Model of the vehicle for this brand
| year               | Text           | Year the vehicle was released by the manufacturer
| color              | Text           | Manufacturer color associated with the vehicle
| vin                | Text           | A Unique vehicle identification number associated with the manufacturer
| licensePlateNumber | Text           | Number associated with a specific license plate

## Firestore Rules

**alerts** : read-only for all users

**maintenance_events** : Authorized users can read and write to the maintenance events collection that is associated with their `userID`.

**vehicles**: Authorized users can ready and write to vehicles collection that is associated with their `userID`.

```
rules_version = '1';
service cloud.firestore {
match /databases/{database}/documents {

    match /alerts/{document=\*\*} {
    allow read;
    }

    match /maintenance_events/{allPaths=**} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /vehicles/{allPaths=**} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
        }
    }

}
```
