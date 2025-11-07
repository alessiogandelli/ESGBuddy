# 🔐 Configuration Guide

## Setting Up Your Backend URL (Private)

Your ngrok or backend URL is now kept private and **NOT** committed to GitHub!

### First Time Setup:

1. **Your URL is already configured** in `lib/config/local_config.dart` (this file is in `.gitignore`)

2. **For team members**: Copy the example file:
   ```bash
   cp lib/config/local_config.example.dart lib/config/local_config.dart
   ```
   Then edit `lib/config/local_config.dart` and add your backend URL:
   ```dart
   class LocalConfig {
     static const String backendUrl = 'https://your-ngrok-url.ngrok-free.app';
   }
   ```

### Switching Between Mock and Real Backend:

In `lib/main.dart`:

**For Mock Data (default, no backend needed):**
```dart
final repository = MockEsgRepository();
```

**For Real Backend:**
```dart
// Uncomment these imports:
import 'config/app_config.dart';
import 'data/api_service.dart';
import 'data/esg_repository.dart';

// Use this in main():
final apiService = ApiService(baseUrl: AppConfig.baseUrl);
final repository = EsgRepository(apiService: apiService);
```

## 🎨 Customizing App Appearance

All styling is centralized in `lib/config/app_theme.dart`. Change the entire app's look by editing this one file!

### Change Primary Color:
```dart
static const Color primaryColor = Colors.blue; // Change from green
```

### Change Category Colors:
```dart
static const Color environmentalColor = Colors.teal;
static const Color socialColor = Colors.indigo;
static const Color governanceColor = Colors.deepPurple;
```

### Change Score Thresholds:
```dart
static Color getScoreColor(double score) {
  if (score >= 90) return highScoreColor;  // Change threshold
  if (score >= 70) return mediumScoreColor;
  return lowScoreColor;
}
```

### Change Spacing:
```dart
static const double paddingLarge = 20.0; // Increase spacing
static const double borderRadiusMedium = 16.0; // Rounder corners
```

### Change Fonts:
Modify the text style methods in `AppTheme`:
```dart
static TextStyle headlineStyle(BuildContext context) {
  return const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );
}
```

## 📁 Key Files

- `lib/config/local_config.dart` - Your private backend URL (not in git)
- `lib/config/local_config.example.dart` - Template for team members
- `lib/config/app_theme.dart` - All styling in one place
- `lib/config/app_config.dart` - App configuration (uses local_config)
- `lib/main.dart` - Switch between mock/real data here

## ✅ What's Protected

The `.gitignore` file now includes:
```
# Local configuration (keep secrets safe)
lib/config/local_config.dart
```

Your ngrok URL will never be pushed to GitHub! 🔒
