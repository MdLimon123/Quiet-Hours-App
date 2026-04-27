# 📖 Authentication Code Reference

## Common Code Patterns

### 1. **Initialize Auth in Your Screen**

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  void dispose() {
    authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Your UI here
  }
}
```

### 2. **Handle Sign In**

```dart
Future<void> handleSignIn() async {
  final authController = Get.find<AuthController>();
  
  // Clear previous errors
  authController.clearError();
  
  // Sign in
  await authController.signIn();
  
  // Check if signed in successfully
  if (authController.errorMessage.value.isEmpty) {
    // Success! Navigation happens automatically
  }
}
```

### 3. **Handle Sign Up**

```dart
Future<void> handleSignUp() async {
  final authController = Get.find<AuthController>();
  
  // Error will be shown if validation fails
  await authController.signUp();
  
  // If successful, user redirected to onboarding
}
```

### 4. **Get Current User**

```dart
// Get current Firebase user
final sessionController = Get.find<SessionController>();
final currentUser = sessionController.getCurrentUser();

if (currentUser != null) {
  print('User Email: ${currentUser.email}');
  print('User UID: ${currentUser.uid}');
} else {
  print('No user logged in');
}
```

### 5. **Get User Profile**

```dart
Obx(() {
  final profile = Get.find<SessionController>().profile.value;
  
  if (profile != null) {
    return Text('Welcome, ${profile.name}!');
  } else {
    return const Text('Loading profile...');
  }
})
```

### 6. **Watch Authentication State Changes**

```dart
@override
void initState() {
  super.initState();
  
  final sessionController = Get.find<SessionController>();
  
  sessionController.profile.listen((profile) {
    if (profile == null) {
      // User logged out
      print('User logged out');
      Get.offAllNamed('/sign-in');
    } else {
      // User logged in
      print('User logged in: ${profile.name}');
    }
  });
}
```

### 7. **Handle Logout**

```dart
Future<void> handleLogout() async {
  final sessionController = Get.find<SessionController>();
  
  // Confirm logout
  Get.dialog(
    AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            
            // Logout
            await sessionController.logout();
            
            // Navigate to Sign In
            Get.offAllNamed('/sign-in');
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
```

## Form Input Handling

### **Email Input**

```dart
TextField(
  controller: authController.emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    hintText: 'your@email.com',
    prefixIcon: const Icon(Icons.email_outlined),
    errorText: _validateEmail(),
  ),
  onChanged: (value) {
    setState(() {}); // Update validation
  },
)

String? _validateEmail() {
  final email = authController.emailController.text;
  if (email.isEmpty) return 'Email required';
  if (!GetUtils.isEmail(email)) return 'Invalid email';
  return null;
}
```

### **Password Input**

```dart
Obx(() {
  return TextField(
    controller: authController.passwordController,
    obscureText: !authController.isPasswordVisible.value,
    decoration: InputDecoration(
      hintText: '••••••••',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          authController.isPasswordVisible.value
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: authController.togglePasswordVisibility,
      ),
    ),
  );
})
```

## Error Handling

### **Display Errors**

```dart
Obx(() {
  if (authController.errorMessage.value.isNotEmpty) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              authController.errorMessage.value,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  return const SizedBox.shrink();
})
```

### **Handle Specific Errors**

```dart
Future<void> signInWithErrorHandling() async {
  try {
    await authController.signIn();
  } catch (e) {
    final error = e.toString().toLowerCase();
    
    if (error.contains('not-found')) {
      // Email not registered
      showSnackbar('Email not found. Please sign up first.');
    } else if (error.contains('wrong-password')) {
      // Wrong password
      showSnackbar('Incorrect password. Please try again.');
    } else if (error.contains('too-many-requests')) {
      // Too many attempts
      showSnackbar('Too many login attempts. Try again later.');
    } else {
      // Other errors
      showSnackbar('Login failed. Please try again.');
    }
  }
}
```

## State Management

### **Loading State**

```dart
Obx(() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: authController.isLoading.value
          ? null
          : () => authController.signIn(),
      child: authController.isLoading.value
          ? const CircularProgressIndicator()
          : const Text('Sign In'),
    ),
  );
})
```

### **Multiple Observables**

```dart
Obx(() {
  final isLoading = authController.isLoading.value;
  final hasError = authController.errorMessage.value.isNotEmpty;
  const isPasswordVisible = authController.isPasswordVisible.value;
  
  return Column(
    children: [
      // UI widgets that depend on these values  
    ],
  );
})
```

## Navigation

### **Programmatic Navigation**

```dart
// Go to next screen
Get.toNamed('/sign-up');

// Go and replace
Get.offNamed('/shell');

// Clear history and go to
Get.offAllNamed('/shell');

// Go back
Get.back();
```

### **Navigation with Arguments**

```dart
// Send data
Get.toNamed('/profile', arguments: {'userId': 123});

// Receive data
final userId = Get.arguments['userId'];
```

## Using AuthService Directly

### **Manual Operations** (Usually not needed)

```dart
final authService = AuthService();

// Sign up manually
try {
  final user = await authService.signUp(
    email: 'user@example.com',
    password: 'Password123!',
    name: 'John Doe',
  );
  print('User created: ${user?.uid}');
} catch (e) {
  print('Error: $e');
}

// Get user profile
final profile = await authService.getUserProfile(uid);

// Reset password
await authService.resetPassword('user@example.com');

// Sign out
await authService.signOut();
```

## Testing Examples

### **Test Sign Up**

```dart
test('Sign up with valid credentials', () async {
  final authController = AuthController();
  
  authController.nameController.text = 'John Doe';
  authController.emailController.text = 'john@example.com';
  authController.passwordController.text = 'ValidPass123!';
  authController.confirmPasswordController.text = 'ValidPass123!';
  
  await authController.signUp();
  
  expect(authController.errorMessage.value, isEmpty);
});

test('Sign up with weak password', () async {
  final authController = AuthController();
  
  authController.passwordController.text = 'weak';
  
  await authController.signUp();
  
  expect(
    authController.errorMessage.value,
    contains('strong'),
  );
});
```

## Best Practices

### ✅ DO:

```dart
// 1. Use Obx for reactive UI
Obx(() => Text(authController.errorMessage.value))

// 2. Dispose controllers properly
@override
void dispose() {
  authController.dispose();
  super.dispose();
}

// 3. Use Get.put only once
if (!Get.isRegistered<AuthController>()) {
  Get.put(AuthController());
}

// 4. Clear sensitive data on logout
authController.clearFormFields();
```

### ❌ DON'T:

```dart
// 1. Don't access controller state outside Obx
Text(authController.isLoading.value) // Will not update

// 2. Don't recreate controllers repeatedly
Get.put(AuthController()); // Avoid this in build()

// 3. Don't forget to dispose controllers
// Leads to memory leaks

// 4. Don't log sensitive user data
print("Password: ${password}"); // Never!
```

---

**Version**: 1.0
**Last Updated**: April 2026
