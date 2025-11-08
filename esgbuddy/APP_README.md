# ESG Buddy - Flutter Dashboard

A simple Flutter dashboard for viewing ESG (Environmental, Social, Governance) sustainability reports.

## Features

- 📊 **Company List**: View all companies with their overall ESG scores
- 🎯 **Detailed Dashboard**: See comprehensive ESG metrics for each company
  - Overall ESG Score (0-100)
  - GRI Topic Scores (Environmental, Social, Governance)
  - UN SDG Alignment scores
  - Report quality metrics
- 📖 **Methodology Page**: Understand how scores are calculated
  - Scoring formula explanation
  - GRI topic standards breakdown
  - SDG mapping
  - Key performance metrics

## Backend Integration

This app connects to the ESG backend API at `https://esg.gandelli.dev/api`

### API Endpoints Used

- `GET /companies` - Fetch all companies
- `GET /companies/:id` - Get company by ID
- `GET /companies/by-code/:code` - Get company by code
- `GET /stats/summary` - Get summary statistics

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Internet connection (to access the backend API)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Architecture

```
lib/
├── config/
│   ├── app_config.dart      # API configuration
│   └── app_theme.dart       # App theme
├── data/
│   ├── api_service.dart     # HTTP client
│   ├── esg_repository.dart  # Data repository
│   └── i_esg_repository.dart # Repository interface
├── models/
│   ├── company_esg_data.dart    # Company data model
│   └── computed_report.dart     # Report models
└── presentation/
    └── screens/
        ├── company_list_screen.dart  # Main list view
        ├── dashboard_screen.dart     # Company details
        └── methodology_screen.dart   # Methodology docs
```

## Data Models

The app uses the following main models aligned with your backend:

- **CompanyESGData**: Complete company with ESG data
- **ComputedReport**: Computed ESG scores and metrics
- **TopicScore**: GRI topic-level scores
- **SdgScore**: UN SDG alignment scores

## Scoring System

Scores are calculated using:
- **40% Completeness**: % of required GRI disclosures provided
- **60% Performance**: Metric-based scoring against benchmarks

Topics include:
- GRI 302 (Energy), GRI 305 (Emissions)
- GRI 303 (Water), GRI 306 (Waste)
- GRI 403 (Health & Safety), GRI 404 (Training)
- GRI 405 (Diversity), GRI 205 (Anti-corruption)
- GRI 418/419 (Privacy), GRI 2 (Governance)
- GRI 308/414 (Supply Chain)

## Customization

To change the backend URL, edit `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String baseUrl = 'https://your-backend.com/api';
}
```

## License

ISC
