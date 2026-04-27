# 🎨 UI/UX Overview - Authentication Screens

## Visual Layout

### **Sign In Screen Layout**

```
┌─────────────────────────────────┐
│                                 │
│    [Gradient Background]        │
│    ┌─────────────────────────┐  │
│    │   🔒 [Icon Circle]      │  │
│    │                         │  │
│    │   Welcome Back          │  │
│    │   Sign in to Quiet      │  │
│    │   Hours                 │  │
│    └─────────────────────────┘  │
│                                 │
├─────────────────────────────────┤
│                                 │
│  Email Address                  │
│  ┌─────────────────────────────┐│
│  │ 📧 your@email.com        │  ││
│  └─────────────────────────────┘│
│                                 │
│  Password                       │
│  ┌─────────────────────────────┐│
│  │ 🔒 •••••••••  👁️           │  ││
│  └─────────────────────────────┘│
│                                 │
│  [Forgot Password?]             │
│                                 │
│  ┌─────────────────────────────┐│
│  │       📝 SIGN IN            │  ││
│  └─────────────────────────────┘│
│                                 │
│  ─────────────────────────────  │
│            or                   │
│  ─────────────────────────────  │
│                                 │
│  Don't have account? Sign Up    │
│                                 │
└─────────────────────────────────┘
```

### **Sign Up Screen Layout**

```
┌─────────────────────────────────┐
│                                 │
│    [Gradient Background]        │
│    ┌────────────────────────────│
│    │  👤 [Icon Circle]          │
│    │                            │
│    │  Create Account            │
│    │  Join the Quiet Hours      │
│    │  community                 │
│    └────────────────────────────│
│                                 │
├─────────────────────────────────┤
│                                 │
│  Full Name                      │
│  ┌─────────────────────────────┐│
│  │ 👤 John Doe              │  ││
│  └─────────────────────────────┘│
│                                 │
│  Email Address                  │
│  ┌─────────────────────────────┐│
│  │ 📧 john@example.com      │  ││
│  └─────────────────────────────┘│
│                                 │
│  Password                       │
│  ┌─────────────────────────────┐│
│  │ 🔒 •••••••••  👁️           │  ││
│  └─────────────────────────────┘│
│  [████░░░░░ Fair]               │
│                                 │
│  Confirm Password               │
│  ┌─────────────────────────────┐│
│  │ 🔒 •••••••••  👁️           │  ││
│  └─────────────────────────────┘│
│                                 │
│  📋 Password Requirements:       │
│     ✓ At least 6 characters     │
│     ✓ One uppercase letter      │
│     ✓ One lowercase letter      │
│     ✓ One number               │
│     ✗ One special character    │
│                                 │
│  ┌─────────────────────────────┐│
│  │    🔐 CREATE ACCOUNT        │  ││
│  └─────────────────────────────┘│
│                                 │
│  Already have account? Sign In  │
│  By signing up, you agree to    │
│  our Terms & Conditions         │
│                                 │
└─────────────────────────────────┘
```

### **Forgot Password Dialog**

```
┌──────────────────────────────────┐
│  Reset Password                  │
├──────────────────────────────────┤
│                                  │
│  Enter your email address and    │
│  we will send you password       │
│  reset instructions.             │
│                                  │
│  ┌────────────────────────────┐  │
│  │ your@email.com           │  │
│  └────────────────────────────┘  │
│                                  │
│  [Cancel]         [Send Link]    │
│                                  │
└──────────────────────────────────┘
```

## Color Scheme

### **Primary Colors**
```
Primary Blue:     #146C94 (Deep professional blue)
Dark Blue:        #0B2B40 (Header background)
Light Blue:       #D9EDF7 (Accent/Background)
Background:       #F4F8FB (Light neutral)
```

### **State Colors**
```
Success:          #4CAF50 (Green)
Error:            #F44336 (Red)
Warning:          #FFA726 (Orange)
Info:             #2196F3 (Blue)
Disabled:         #BDBDBD (Gray)
```

### **Text Colors**
```
Primary Text:     #123247 (Almost black)
Secondary Text:   #666666 (Gray)
Hint Text:        #999999 (Light gray)
Error Text:       #F44336 (Red)
White Text:       #FFFFFF (On primary)
```

## Typography

### **Font Family**
- Font: Google Fonts - Hind Siliguri
- Language Support: Bengali & English


### **Font Sizes**
```
Headers:          28px, bold     (Welcome Back)
Titles:           24px, bold     (Create Account)
Subtitle:         14px, regular  (Join the community)
Labels:           14px, 600wt    (Email Address)
Inputs:           13px, regular  (user input)
Errors:           12px, 500wt    (error messages)
Hints:            13px, light    (placeholder text)
```

## Interactive Elements

### **Input Fields**
```
┌─────────────────────────┐
│ 🔒 ••••••••• 👁️        │  ← Suffix icon
│ [Icon] Password [Icon]  │  ← Prefix & Suffix
└─────────────────────────┘
   Border: Light gray       ← Appearance
   Focus: Blue #146C94      ← On focus
   Error: Red #F44336       ← On error
```

### **Buttons**

**Primary Button (Enabled)**
```
┌─────────────────────┐
│   SIGN IN           │  ← Text
└─────────────────────┘
Color: #146C94 (Blue)
Elevation: 2px elevated
Radius: 12px rounded
```

**Primary Button (Loading)**
```
┌─────────────────────┐
│     ⟳ (spinner)     │  ← Loading spinner
└─────────────────────┘
Disabled state
Color: Dimmed blue
```

**Primary Button (Disabled)**
```
┌─────────────────────┐
│   SIGN IN           │  ← Grayed out
└─────────────────────┘
Opacity: 50%
Not clickable
```

**Text Links**
```
"Sign Up" or "Forgot Password?"
Color: #146C94 (Blue)
Underline: On tap
Material Ripple: Yes
```

## Animation & Transitions

### **Page Transitions**
- Sign In ↔ Sign Up: Slide from right
- Sign Up → Onboarding: Slide from right
- Sign In → Splash: Fade out

### **Loading Indicator**
```
Circular Progress Indicator
┌─────────────┐
│     ⟳       │  ← Auto-rotating
│             │  
└─────────────┘
Duration: 1s per full rotation
Color: White (on blue background)
```

### **Error Animation**
```
Error container slides down
┌──────────────────────────────────┐
│ ⚠️ Error message appears here    │  ← Colored
└──────────────────────────────────┘
Animation: Fade in + slide
Duration: 300ms
```

### **Password Strength Animation**
```
[████░░░░░] Fair
 │││││
 └─ Fills as user types
    Real-time update
    Color changes with strength
```

## Responsive Design

### **Mobile (Portrait)**
```
Width: 100%
Padding: 24px horizontal
Safe area: Considered
Stacked: All elements vertical
```

### **Tablet (Landscape)**
```
Max width: 600px
Centered: Horizontally
Padding: 32px horizontal
Card-like layout: Often used
```

### **Screen Sizes Tested**
- ✓ 360px (Small phones)
- ✓ 411px (Standard phones)
- ✓ 600px (Tablets)
- ✓ 768px (Large tablets)

## Accessibility Features

### **Touch Targets**
```
Minimum size: 48x48dp
Buttons: Padding for tap
Links: Comfortable spacing
Icons: Clear and obvious
```

### **Color Contrast**
```
Text on background: AAA (High contrast)
Error messages: Red + Icon (Not color-only)
Border: Visible on all backgrounds
Icons: Distinguishable colors
```

### **Input Labels**
```
Always present: Not just placeholder
Descriptive: Clear purpose
Positioned: Above input
Associated: Linked via label
```

## Status States

### **Sign In States**

**Empty Form**
```
Buttons: Enabled
Errors: None
Progress: Hidden
Focus: On first field
```

**Filling Form**
```
Buttons: Enabled (if valid)
Errors: Real-time validation
Progress: Hidden
Labels: Visible
```

**Loading**
```
Buttons: Disabled  
Errors: Previous errors shown
Progress: Spinner visible
Inputs: Disabled
```

**Error State**
```
Buttons: Re-enabled
Errors: Shown in red box
Progress: Hidden
Inputs: Editable again
Focus: On error field
```

**Success**
```
Navigation: Automatic
Transition: Smooth
Data: Cleared
State: Reset
```

## Password Strength Indicator

### **Visual States**

**No Password**
```
[░░░░░]
Label: "No password"
Color: Gray
```

**Weak**
```
[█░░░░]
Label: "Weak"
Color: Red
```

**Fair**
```
[███░░]
Label: "Fair"
Color: Orange
```

**Good**
```
[████░]
Label: "Good"
Color: Yellow
```

**Strong**
```
[█████]
Label: "Strong"
Color: Green
```

## Error Message Styling

### **Display Format**
```
┌────────────────────────────────┐
│ ⚠️ Error message here           │
│                                │
│ Can span multiple lines if     │
│ needed for clarity             │
└────────────────────────────────┘

Background: Red with 10% opacity
Border: Red solid 1px
Icons: Error icon + message
Text: Bold, readable size
```

### **Common Error Messages**
```
"Please fill in all fields"
"Please enter a valid email"
"Password must be at least 6 characters"
"Passwords do not match"
"No user found with this email"
"Incorrect password"
"Email already registered"
"Too many attempts. Try again later"
```

## Dark Mode Support

### **Color Adjustments** (if implemented)
```
Background: Dark gray (#121212)
Cards: Slightly lighter (#1E1E1E)
Text: High contrast white
Borders: Lighter gray
Subtle gradient: Preserved but darker
```

## Performance Notes

### **Optimizations**
- All images cached
- Smooth 60 FPS animations
- Lazy loading where applicable
- Debounced input validation
- Minimal rebuilds with Obx

### **Size Optimization**
- Vector icons (not png)
- Optimized gradients
- Minimal dependencies
- Responsive layouts

---

## Quick Visual Reference

| Component | Color | Size | State |
|-----------|--------|------|-------|
| Header BG | Gradient (#0B2B40 → #146C94) | Full width | Static |
| Button | #146C94 | Full width × 52px | Enabled/Loading/Disabled |
| Input | White bg, gray border | Full width × 52px | Focus/Blur/Error |
| Label | #123247 | 14px | Always visible |
| Error Box | #F44336 bg | Full width | Show/Hide |
| Link Text | #146C94 | Auto | Normal/Tap |

---

**Design System**: Material Design 3  
**Brand Color**: #146C94  
**Typography**: Hind Siliguri (Google Fonts)  
**Animation**: Smooth 300ms transitions  
**Accessibility**: WCAG AA+
