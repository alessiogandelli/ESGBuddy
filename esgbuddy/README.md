# ESG Buddy 🌱

A Flutter hackathon project with clean architecture for ESG (Environmental, Social, Governance) data management.

## ✨ Features

- Clean separation between data and presentation layers
- Easy to switch between n8n backend and real API
- Mock data support for rapid development
- Beautiful Material 3 UI
- Pull-to-refresh functionality
- Error handling with retry mechanism

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (UI, Screens, Widgets)              │
└─────────────────┬───────────────────────┘
                  │
                  │ Uses Repository
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  ┌──────────────────────────────────┐  │
│  │     EsgRepository (Interface)    │  │
│  └──────────────────────────────────┘  │
│         │                     │         │
│    ┌────▼────┐         ┌─────▼─────┐  │
│    │ Real API│         │ Mock Data │  │
│    │(n8n)    │         │           │  │
│    └─────────┘         └───────────┘  │
└─────────────────────────────────────────┘
                  │
                  │ Uses Models
                  │
┌─────────────────▼───────────────────────┐
│          Models Layer                   │
│   (EsgMetric, CompanyProfile)          │
└─────────────────────────────────────────┘
```

## 🚀 Quick Start

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Run with Mock Data (No Backend Needed)
Uncomment mock repository in `lib/main.dart`:
```dart
final esgRepository = MockEsgRepository();
```

Then run:
```bash
flutter run -d chrome
```

### 3. Run with n8n Backend
The app is pre-configured for n8n at:

Just run:
```bash
flutter run -d chrome
```

## 📁 Project Structure

```
lib/
├── config/
│   └── app_config.dart              # Backend URLs
├── models/
│   ├── esg_metric.dart              # ESG metric model
│   └── company_profile.dart         # Company model
├── data/
│   ├── api_service.dart             # HTTP client
│   ├── esg_repository.dart          # Real API repository
│   └── mock_esg_repository.dart     # Mock data repository
├── presentation/
│   └── screens/
│       └── home_screen.dart         # Main UI screen
└── main.dart                         # App entry point
```

## 🔄 Switching Data Sources

### Use Mock Data
```dart
// In lib/main.dart
final esgRepository = MockEsgRepository();
```

### Use n8n (Current Setup)
```dart
// In lib/main.dart
final apiService = ApiService(baseUrl: AppConfig.baseUrl);
final esgRepository = EsgRepository(apiService: apiService);
```

### Use Production Backend
```dart
// In lib/config/app_config.dart
static const String baseUrl = 'https://your-production-api.com';
```

## 📊 Expected API Format

### GET /companies
```json
[
  {
    "id": "1",
    "name": "Green Tech Inc",
    "industry": "Technology",
    "esg_score": 85.5,
    "description": "Sustainable tech company"
  }
]
```

### GET /metrics
```json
[
  {
    "id": "1",
    "name": "Carbon Emissions",
    "category": "Environmental",
    "value": 1250.5,
    "unit": "tons CO2",
    "timestamp": "2025-11-07T10:00:00Z"
  }
]
```

## 🎯 Why This Architecture?

- **Hackathon Ready**: Quick iterations without breaking things
- **Team Friendly**: Frontend and backend can work independently
- **Production Ready**: Scales to real-world applications
- **Flexible**: Easy to swap backends or add features
- **Testable**: Each layer can be tested independently

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Get running in 5 minutes
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture docs

## 🛠️ Tech Stack

- Flutter 3.9+
- Dart 3.0+
- Material 3
- HTTP package for networking

## 🤝 Contributing

This is a hackathon project! Feel free to:
1. Add new screens in `presentation/`
2. Add new models in `models/`
3. Extend repository functionality
4. Improve UI/UX

## 📝 License

MIT License - Do whatever you want with this code!
