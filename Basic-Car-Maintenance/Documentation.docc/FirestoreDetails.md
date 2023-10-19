## Firestore Collections

### _alerts_

The alerts collection contains system level alerts that will be visable to all users. The alerts
will only be displayed to the user once.

| Fields     | Firestore Type | Description                                                                            |
| ---------- | -------------- | -------------------------------------------------------------------------------------- |
| actionText | Text           | Indicates the text that will appear on the action button                               |
| actionURL  | Text           | Indicates the url that the user will be redirected to when the acton button is pressed |
| emojiIcon  | Text           | The emoji that will appear on the alert message                                        |
| id         | Text           | Identifies a specific alert                                                            |
| isOn       | Boolean        | Indicates if the alert is active                                                       |
| message    | Text           | The text content of the alert                                                          |
| title      | Text           | The name given to the alert                                                            |

### _maintainance_events_

Maintainance events collection contains the individual maintainance events that are associated
with a specific user.

| Fields    | Firestore Type | Description                                                                               |
| --------- | -------------- | ----------------------------------------------------------------------------------------- |
| id        | DocumentID     | The unique maintainance event identifier that will auto-populate your objects id property |
| userID    | Text           | Identifies the user associated with the maintainance event                                |
| title     | Text           | The customized name given to the maintainance event                                       |
| date      | Date           | The date that the maintainance event was created                                          |
| notes     | Text           | Extra details that the user want to provide about the maintainance event                  |
| vehicleID | Text           | Identifies the vehicle assocated with the maintainance event                              |

### _vehicles_

The vehicles collection contains all the vehicles associated with a specific user.

| Fields | Firestore Type | Description                                                                    |
| ------ | -------------- | ------------------------------------------------------------------------------ |
| id     | DocumentID     | The unique vehicle identifier that will auto-populate your objects id property |
| userID | Text           | Identifies the user associated with the vehicle                                |

| name | Text | Customized name given to vehicle entry
| make | Text | Indicates the brand of the vehicle
| model | Text | Indicates unique name associated with a specific brand
| year | Text | Indicates the year the vehicle was released by the manufacturer
| color | Text | Indicates the manifacturer color associated with the vehicle
| vin | Text | A unique vehicle identification number associated with the manufacturer
| licensePlateNumber | Text | The number assocaiated with a specific state license plate

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
