## Firestore Collections

### _alerts_

The alerts collection contains system level alerts that will be visible to all users. The alerts
will only be displayed to the user once.

| Fields     | Firestore Type | Description                                                                            |
| ---------- | -------------- | -------------------------------------------------------------------------------------- |
| actionText | Text           | Text that will appear on the action button                               |
| actionURL  | Text           | Url that the user will be redirected to when the action button is tapped |
| emojiIcon  | Text           | The emoji that will appear on the alert message                                        |
| id         | Text           | Identifies a specific alert                                                            |
| isOn       | Boolean        | Toggles if the alert is active. Only one alert will be active at a time.             |
| message    | Text           | Text content of the alert                                                          |
| title      | Text           | Name given to the alert                                                            |

### maintainance_events

Maintainance events collection contains the individual maintainance events that are associated
with a specific user.

| Fields    | Firestore Type | Description                                                                               |
| --------- | -------------- | ----------------------------------------------------------------------------------------- |
| id        | DocumentID     | Unique maintainance event identifier that will auto-populate your objects id property |
| userID    | Text           | Identifies the user associated with the maintainance event                                |
| title     | Text           | Customized name given to the maintainance event                                       |
| date      | Date           | Date that the maintainance event was created                                          |
| notes     | Text           | Extra details that the user want to provide about the maintainance event                  |
| vehicleID | Text           | Identifies the vehicle assocated with the maintainance event                              |

### vehicles

The vehicles collection contains all the vehicles associated with a specific user.

| Fields | Firestore Type | Description                                                                    |
| ------ | -------------- | ------------------------------------------------------------------------------ |
| id     | DocumentID     | Unique vehicle identifier that will auto-populate your objects id property |
| userID | Text           | Identifies the user associated with the vehicle                                |
| name | Text | Customized name given to vehicle entry
| make | Text | Indicates the brand of the vehicle
| model | Text | Unique name associated with a specific brand
| year | Text | Year the vehicle was released by the manufacturer
| color | Text | Manifacturer color associated with the vehicle
| vin | Text | A Unique vehicle identification number associated with the manufacturer
| licensePlateNumber | Text | Number assocaiated with a specific state license plate

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
        allow read, write: if request.auth != null && request.auth.uid == userId
;
        }

        match /vehicles/{allPaths=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId
;
        }
    }

}
```
