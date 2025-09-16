# Translation System Guide

## Overview

This Flutter app now supports bilingual functionality with English (en) and Somali (so) languages. The translation system is organized with clear markers to help developers identify which translations belong to which screens.

## Translation File Structure

Both `assets/translations/en.json` and `assets/translations/so.json` follow this organized structure:

```json
{
  "start_screen_name": "This translation section is for screen_name.dart",
  "translation_key": "Translation value",
  "another_key": "Another value",
  "end_screen_name": "End of screen_name.dart translations"
}
```

## Currently Supported Screens

### ✅ Fully Translated Screens

1. **user_profile.dart** - Patient profile with language switching
2. **doctor_profile_Screen.dart** - Doctor profile with language switching
3. **login_screen.dart** - Login screen with all text translated
4. **home_screen.dart** - Home screen with service cards and appointments

### 📝 Translation Sections Available

- User Profile Screen
- Doctor Profile Screen
- Login Screen
- Register Screen
- Home Screen
- Main Screen
- Notification Screen
- Change Password Screen
- Doctor Home Screen
- Doctor Appointment Screen
- Common Validations
- Common UI Elements

## How to Add Translations to New Screens

### Step 1: Import Required Packages

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans; // If using GetX
```

### Step 2: Add Language Controller (if needed)

```dart
final LanguageController languageController = Get.find<LanguageController>();
```

### Step 3: Replace Hardcoded Text

Replace hardcoded strings with `.tr()` calls:

```dart
// Before
Text("Welcome Back")

// After
Text("welcome_back".tr())
```

### Step 4: Add Language Selection (for profile screens)

Copy the `showLanguageSelection()` method from `user_profile.dart` or `doctor_profile_Screen.dart`.

### Step 5: Update Translation Files

Add your translations to both `en.json` and `so.json`:

```json
{
  "start_your_screen": "This translation section is for your_screen.dart",
  "your_key": "Your English Text",
  "another_key": "Another English Text",
  "end_your_screen": "End of your_screen.dart translations"
}
```

## Language Switching Features

### Current Implementation

- ✅ Patient profile screen has language switching
- ✅ Doctor profile screen has language switching
- ✅ Confirmation dialog before language change
- ✅ App restart notification
- ✅ Visual indicators for current language

### How Language Switching Works

1. User taps "Change Language" in profile
2. Modal shows available languages with current selection
3. User selects new language
4. Confirmation dialog appears
5. App restarts with new language applied

## Available Translation Keys

### Profile Screens

- `profile`, `personal_information`, `name`, `country`, `phone`, `email`
- `username`, `address`, `gender`, `age`, `settings`
- `change_profile_picture`, `change_password`, `change_language`
- `other`, `share_qr_code`, `share_apk`, `log_out`, `pending`

### Authentication

- `login`, `register`, `sign_in`, `sign_up`, `email_or_phone`
- `password`, `forgot_password`, `already_have_account`, `dont_have_account`

### Home Screen

- `welcome_back`, `appointments`, `consultation`, `hospital`
- `self_manage`, `my_treatment`, `laboratory`, `no_appointments_found`

### Common Validations

- `please_enter_email_or_username`, `please_enter_password`
- `password_must_be_6_characters`, `passwords_do_not_match`
- `registration_successful`, `enter_valid_email`

### Language System

- `language_selection`, `english`, `somali`, `confirm_language_change`
- `app_will_restart`, `apply`, `cancel`, `save`

## Next Steps

### Screens That Need Translation Support

1. `register_screen.dart` - Registration form
2. `main_screen.dart` - Main navigation
3. `notification_screen.dart` - Notifications
4. `change_password_screen.dart` - Password change
5. Doctor screens in `DoctorScreens/` folder
6. Patient screens in `patient/` folder
7. Component screens in `components/` folder

### How to Extend

1. Choose a screen to translate
2. Add import statements
3. Replace hardcoded text with `.tr()` calls
4. Add translations to both JSON files with proper markers
5. Test language switching functionality

## Best Practices

1. Always add translations to both `en.json` and `so.json`
2. Use descriptive translation keys
3. Group related translations with start/end markers
4. Test both languages thoroughly
5. Keep translation keys consistent across screens
6. Use common validation messages from the shared section

## File Locations

- English translations: `assets/translations/en.json`
- Somali translations: `assets/translations/so.json`
- Language controller: `lib/controllers/language_controller.dart`
- Example implementation: `lib/views/screens/patient/user_profile.dart`
