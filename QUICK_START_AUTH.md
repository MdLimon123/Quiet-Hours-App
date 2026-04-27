# Quick Start Guide - Firebase Authentication

## 🚀 Quick Setup

### 1. **Start the App**
When users open the Quiet Hours app:
- If they're **not logged in** → They see the **Sign In screen**
- If they're **logged in** → App checks for profile → Takes them to **Main App** or **Onboarding**

### 2. **Sign Up Flow**
```
1. User taps "Sign Up" on Sign In screen
2. Fills: Name, Email, Password
3. Password validated in real-time
4. Confirms password match
5. Account created in Firebase Auth
6. User document created in Firestore
7. Redirected to Onboarding to complete profile
```

### 3. **Sign In Flow**
```
1. User enters email and password
2. Firebase validates credentials
3. User authenticated
4. Session loads user profile
5. User enters Main App
```

## 🎯 Key Components

### **Sign In Screen** (`sign_in_screen.dart`)
- Email input
- Password input with visibility toggle
- Forgot password link
- Error messages
- Sign Up link
- Professional UI

### **Sign Up Screen** (`sign_up_screen.dart`)
- Full name input
- Email input
- Password input with strength meter
- Confirm password input
- Requirements checklist
- Beautiful gradient header

### **Auth Controller** (`auth_controller.dart`)
Manages all authentication logic:
- Input validation
- Password strength checking
- Sign in/up requests
- Error handling
- Loading states

### **Auth Service** (`auth_service.dart`)
Firebase integration:
- User registration
- User login
- Password reset
- Profile management
- Error mapping

## 💡 Usage Examples

### **In Your Dart Code**

**Getting Auth Controller:**
```dart
final authController = Get.find<AuthController>();
// or
final authController = Get.put(AuthController());
```

**Sign In:**
```dart
await authController.signIn();
```

**Sign Up:**
```dart
await authController.signUp();
```

**Get Current User:**
```dart
final sessionController = Get.find<SessionController>();
final currentUser = sessionController.getCurrentUser();
```

**Logout:**
```dart
final sessionController = Get.find<SessionController>();
await sessionController.logout();
```

## 🔒 Password Requirements

Users must create strong passwords with:
- **Minimum 6 characters**
- **1 Uppercase letter** (A-Z)
- **1 Lowercase letter** (a-z)
- **1 Number** (0-9)
- **1 Special character** (!@#$%^&*)

Example: `MyPass123!`

## ✅ Validation Rules

### Sign Up Validation:
- ✓ Name: 2+ characters
- ✓ Email: Valid format
- ✓ Password: Meets strength requirements
- ✓ Confirm Password: Matches password

### Sign In Validation:
- ✓ Email: Valid format
- ✓ Password: 6+ characters

## 🎨 UI Features

### **Sign In Screen Features:**
- Header gradient with icon
- Email field with icon
- Password field with eye icon (show/hide)
- Forgot password dialog
- Error display box
- Loading spinner
- Sign up link

### **Sign Up Screen Features:**
- Header with welcome message
- Name field
- Email field
- Password field with strength indicator
- Confirm password field
- Requirements checklist
- Terms notice
- Error display
- Loading state

### **Real-time Feedback:**
```
Password Strength: [████░░░░░] Fair
✓ At least 6 characters
✓ One uppercase letter
✓ One lowercase letter
✓ One number
✗ One special character
```

## 🛠️ Error Handling

The app provides **user-friendly error messages**:

| Error | Message |
|-------|---------|
| Wrong password | "Incorrect password" |
| Email not found | "No user found with this email" |
| Email taken | "Email already registered" |
| Weak password | "Password is too weak" |
| Invalid email | "Invalid email address" |
| Too many attempts | "Too many attempts. Try again later" |

## 📱 Navigation Flow

```
Start App
   ↓
Check Firebase Auth Status
   ↓
Has Current User?
   ├─ YES → Validate Profile → Shell App
   └─ NO → Sign In Screen
            ↓
         Sign Up?
         ├─ YES → Sign Up Screen → Create Account → Onboarding
         └─ NO → Sign In → Load Profile
```

## 🔄 User Flow Example

### **New User:**
1. Opens app
2. Sees Sign In screen
3. Clicks "Sign Up"
4. Fills name, email, password
5. Account created
6. Redirected to Onboarding
7. Completes profile (neighborhood, apartment)
8. Enters main app

### **Returning User:**
1. Opens app
2. Enters credentials
3. Logged in successfully
4. Redirected to main app

## 🚨 Troubleshooting

### **"User not found"**
- ✓ Check email spelling
- ✓ Make sure account is created first (Sign Up)

### **"Wrong password"**
- ✓ Check password is correct
- ✓ Password is case-sensitive
- ✓ No accidental spaces

### **Password validation showing as weak**
- ✓ Add uppercase letter
- ✓ Add number
- ✓ Add special character (!@#$%^&*)

### **Firebase not configured**
- ✓ Check `firebase_options.dart` exists
- ✓ Run `flutterfire configure`
- ✓ Ensure Firebase project is set up

### **"Too many attempts"**
- ✓ Wait a few minutes
- ✓ Try on different email
- ✓ Check internet connection

## 🔐 Security Best Practices

✅ **DO:**
- Store passwords securely (handled by Firebase)
- Use HTTPS connections (handled by Firebase)
- Validate input on client and server
- Clear sensitive data on logout

❌ **DON'T:**
- Store passwords in text
- Log sensitive user data
- Share user credentials
- Disable password validation

## 📚 File Structure

```
lib/app/
├── services/
│   ├── auth_service.dart         ← Firebase Auth
│   └── local_storage_service.dart ← Local cache
├── controllers/
│   ├── auth_controller.dart       ← Auth logic
│   └── session_controller.dart    ← Session mgmt
├── ui/screens/
│   ├── sign_in_screen.dart        ← Sign In UI
│   ├── sign_up_screen.dart        ← Sign Up UI
│   └── settings_screen.dart       ← Logout option
└── routes/
    ├── app_routes.dart            ← Route constants
    └── app_pages.dart             ← Route definitions
```

## 🎓 Learning Resources

- **Firebase Auth Docs:** https://firebase.flutter.dev/docs/auth/overview
- **GetX Docs:** https://github.com/jonataslaw/getx
- **Flutter Forms:** https://flutter.dev/docs/cookbook/forms

## 📞 Support

For issues or questions:
1. Check error messages in the app
2. Review troubleshooting section
3. Check Firebase console for errors
4. Verify internet connection

---

**Status**: ✅ Ready for Development
**Last Updated**: April 2026
