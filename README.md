# Quiet Hours

Community-first Flutter app for neighborhood quiet requests.

## What is included
- GetX state management and route shell
- Anonymous Firebase Auth session bootstrap
- Firestore-backed user profile, quiet requests, and alert feed
- FCM topic subscription hooks for neighborhood notifications
- Local notification support for foreground alerts
- Bengali-first onboarding, dashboard, requests, alerts, and settings screens
- Demo mode fallback when Firebase is not configured yet

## Quick start
1. Run `flutter pub get`
2. Run `flutterfire configure`
3. Replace `lib/firebase_options.dart` with the generated file
4. Add `android/app/google-services.json`
5. Add `ios/Runner/GoogleService-Info.plist`
6. Deploy Firestore rules from `firestore.rules`
7. Run `flutter run`

## Firebase collections
- `users/{uid}`
- `quiet_requests/{requestId}`
- `community_alerts/{alertId}`

Detailed flow and production notes are in [docs/quiet_hours_architecture.md](docs/quiet_hours_architecture.md).
