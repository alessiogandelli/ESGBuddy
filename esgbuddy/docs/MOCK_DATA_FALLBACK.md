# Mock Data Fallback System

## Overview

The ESGBuddy app now includes an automatic fallback mechanism that uses mock data when the backend is unavailable. This ensures the app remains functional during development, testing, or when the backend server is down.

## How It Works

### Automatic Fallback

When any API call fails (network error, timeout, server down), the `EsgRepository` automatically:

1. Catches the error
2. Sets an internal flag to use mock data
3. Returns data from `MockEsgRepository` instead
4. Displays a visual banner to inform users

### Visual Indicators

- **Orange Banner**: Appears at the top of the screen when using mock data
- **Warning Icon**: Shows alongside the message "Backend unavailable - Using demo data"
- **Retry Button**: Allows users to attempt reconnecting to the backend

### Mock Data Content

The mock data includes a complete ESG report for "GreenTech Solutions S.p.A.":

- **Company Profile**: Technology sector company in Milan, Italy
- **Financial Metrics**: €58M revenue, €6.9M EBITDA, €800K sustainability investment
- **ESG Scores**: Overall score of 81.7/100
- **Topic Scores**: Covering GRI 302, 305, 303, 306, 403, 404, 405, 205, 308/414, 418/419
- **SDG Alignment**: Scores for SDGs 3, 4, 5, 6, 7, 8, 10, 12, 13, 16
- **Comprehensive Metrics**: Environmental, Social, and Governance data points

## Developer Usage

### Testing Without Backend

Simply start the app without a running backend - it will automatically use mock data after the first failed API call.

### Force Backend Reconnection

Users can click the "Retry" button in the orange banner to attempt reconnecting to the backend.

Developers can also programmatically reset:

```dart
repository.resetBackendStatus();
```

### Check Current Data Source

```dart
if (repository.isUsingMockData) {
  print('Currently using mock data');
} else {
  print('Currently using backend data');
}
```

## Configuration

### Update Mock Data

Edit `/lib/data/mock_esg_repository.dart` and modify the `_mockCompanyData` constant.

### Disable Fallback

To disable automatic fallback and show errors instead, modify `EsgRepository` to remove the try-catch fallback logic.

## Files Modified

- `lib/data/mock_esg_repository.dart` - Contains comprehensive mock ESG data
- `lib/data/esg_repository.dart` - Implements automatic fallback logic
- `lib/presentation/screens/main_navigation_screen.dart` - Shows visual indicator banner

## Benefits

1. **Development**: Work on UI/UX without needing backend running
2. **Testing**: Consistent test data for QA and demos
3. **Resilience**: App remains functional during backend outages
4. **User Experience**: Clear communication when using fallback data
5. **Demo Ready**: Always have data available for presentations

## Best Practices

- Mock data should mirror real data structure exactly
- Keep mock data up-to-date with schema changes
- Use realistic values that represent typical use cases
- Test both backend and mock data paths regularly
