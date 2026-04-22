# Quiet Hours Product + Engineering Flow

## Feature list

1. Neighborhood onboarding
   User sets name, lane/road/neighborhood, apartment label, notification preference.
2. Quiet request composer
   Reasons: study, sleeping baby, migraine, prayer, work call, elder rest.
3. Gentle neighbor feed
   Nearby active requests are shown in a respectful feed, not an alarmist one.
4. Community alerts inbox
   Requests also create a lightweight alert item for quick awareness.
5. My active request lifecycle
   User can create one, monitor remaining time, and end it manually.
6. Firebase/demo mode split
   App still runs before Firebase credentials are attached.
7. Topic-ready notifications
   Clients subscribe to neighborhood topics; backend can send scoped push.

## Suggested production flow

1. App launch
   - Initialize Firebase
   - Initialize local notifications
   - Anonymous sign-in
   - Load user profile
2. First-time user
   - Open onboarding
   - Save profile to `users/{uid}`
   - Subscribe device to neighborhood topic
3. Quiet request creation
   - User selects reason, duration, note
   - Write `quiet_requests/{id}`
   - Write `community_alerts/{id}`
   - Optionally trigger FCM push to topic `quiet_{neighborhoodId}`
4. Nearby users
   - Read active requests filtered by neighborhood
   - Read alerts filtered by neighborhood
   - Show local notifications for new incoming alerts while app is foregrounded
5. Request finish
   - User ends request or backend auto-expires it
   - `active` becomes `false`

## Recommended screens

1. Splash screen
   Session bootstrap + Firebase/demo state indicator.
2. Onboarding screen
   Profile setup, neighborhood join, notification toggle.
3. Home dashboard
   Current neighborhood status, quick actions, active request summary.
4. Create quiet request screen
   Reason, duration, note, preview.
5. Requests screen
   Live neighborhood quiet feed.
6. Alerts screen
   Human-friendly inbox of gentle community alerts.
7. Settings screen
   Profile edit, Firebase mode visibility, permission overview.

## Firebase structure

### `users/{uid}`
```json
{
  "uid": "firebase-auth-uid",
  "name": "রাইয়ান",
  "neighborhoodId": "banani-road-11",
  "neighborhoodLabel": "Banani Road 11",
  "apartmentLabel": "House 22, Flat B2",
  "notificationsEnabled": true,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### `quiet_requests/{requestId}`
```json
{
  "userId": "firebase-auth-uid",
  "requesterName": "রাইয়ান",
  "neighborhoodId": "banani-road-11",
  "reason": "study",
  "note": "আগামী ৪৫ মিনিট একটু কম শব্দে থাকলে উপকার হয়।",
  "startTime": "timestamp",
  "endTime": "timestamp",
  "active": true,
  "createdAt": "timestamp"
}
```

### `community_alerts/{alertId}`
```json
{
  "neighborhoodId": "banani-road-11",
  "requestId": "request-doc-id",
  "title": "নতুন শান্ত সময় অনুরোধ",
  "body": "একজন প্রতিবেশী পড়াশোনা চলছে কারণে কিছু সময় শব্দ কমাতে বলছেন।",
  "createdAt": "timestamp"
}
```

## Permissions

### Required now
- Notification permission
- Internet access
- Background remote notification capability on iOS

### Optional later
- Location permission if you want auto-detect neighborhood / geo-fencing
- Contacts permission if you ever invite building members directly

## Production notes

1. Replace placeholder `lib/firebase_options.dart` using `flutterfire configure`.
2. For true background push delivery, use FCM send from a trusted backend or Cloud Function.
3. Add a scheduled backend cleanup job for expired quiet requests.
4. Add moderation/reporting if the app scales beyond a single building or block.
5. Add App Check before public launch.
