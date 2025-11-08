# ESG Buddy - Clean Architecture Guide

## Overview
This app displays ESG (Environmental, Social, and Governance) data for companies. The architecture is designed to be simple, lean, and easy to understand.

## Application Flow

1. **App Start** (`main.dart`)
   - Creates the repository to fetch data from the API
   - Creates the `CompanyProvider` to manage global company state
   - Launches the `HomeScreen`

2. **Home Screen** (`home_screen.dart`)
   - Fetches the first company's data on load
   - Shows loading, error, or success states
   - Displays the `DashboardScreen` when data is ready

3. **Dashboard Screen** (`dashboard_screen.dart`)
   - Receives company data as a parameter
   - Displays all ESG metrics, scores, and reports

## Global Company Data Access

The company data is managed by `CompanyProvider` and can be accessed from anywhere in the app:

```dart
// The provider is passed down from main.dart
final companyProvider = ...; // initialized in main.dart

// Access company data
if (companyProvider.hasData) {
  final company = companyProvider.company;
  // Use company data anywhere
}

// Refresh data
await companyProvider.refresh();
```

## Key Files

### Core Application
- `lib/main.dart` - App entry point, initializes provider
- `lib/providers/company_provider.dart` - Global company state management

### Screens
- `lib/presentation/screens/home_screen.dart` - Main entry screen
- `lib/presentation/screens/dashboard_screen.dart` - Company ESG dashboard
- `lib/presentation/screens/methodology_screen.dart` - Methodology information

### Data Layer
- `lib/data/esg_repository.dart` - Data repository implementation
- `lib/data/api_service.dart` - HTTP API service
- `lib/data/i_esg_repository.dart` - Repository interface

### Models
- `lib/models/company_esg_data.dart` - Company and ESG data models
- `lib/models/computed_report.dart` - Report and scoring models

### Configuration
- `lib/config/app_config.dart` - App configuration
- `lib/config/app_theme.dart` - Theme configuration

## Adding New Features

To add a new screen that needs company data:

1. Pass the `CompanyProvider` to your new screen
2. Use `AnimatedBuilder` or `ListenableBuilder` to rebuild when data changes
3. Access company data via `companyProvider.company`

Example:
```dart
class NewScreen extends StatelessWidget {
  final CompanyProvider companyProvider;

  const NewScreen({required this.companyProvider});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: companyProvider,
      builder: (context, child) {
        final company = companyProvider.company;
        if (company == null) return CircularProgressIndicator();
        
        // Use company data here
        return Text(company.companyName);
      },
    );
  }
}
```

## Architecture Principles

1. **Simple State Management** - Using built-in ChangeNotifier, no external dependencies
2. **Single Source of Truth** - Company data lives in `CompanyProvider`
3. **Clean Separation** - Data layer, models, and presentation are separate
4. **Easy to Test** - Repository interface allows for easy mocking
5. **Minimal Dependencies** - Only `http` package for networking
