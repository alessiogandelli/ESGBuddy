# Stakeholder Screen Refactoring Summary

## Overview
The monolithic 1673-line `stakeholder_screen.dart` has been refactored into modular, reusable widgets for better maintainability and code organization.

## File Structure

```
/lib/presentation/screens/stakeholder/
├── stakeholder_screen.dart (original - ~1673 lines)
├── stakeholder_screen_refactored.dart (new - ~115 lines)
└── widgets/
    ├── common_widgets.dart (400+ lines)
    ├── sdg_selector.dart (80+ lines)
    ├── financial_metrics.dart (250+ lines)
    ├── environmental_metrics.dart (240+ lines)
    ├── social_metrics.dart (350+ lines)
    └── governance_metrics.dart (130+ lines)
```

## Module Descriptions

### 1. **common_widgets.dart** (Reusable UI Components)
Contains shared widgets used across all metric sections:
- `StakeholderHeader` - Gradient header with title and subtitle
- `SectionTitle` - Section headers with icon
- `NoDataCard` - Empty state message display
- `MetricCardSimple` - Basic metric card with icon and value
- `MetricCardWithChart` - Metric card with embedded chart
- `FinancialMetricCard` - Financial card with optional benchmark

**Usage:** Import and use in any screen that needs ESG metric displays.

### 2. **sdg_selector.dart** (SDG Selection)
Manages Sustainable Development Goal selection:
- `SdgSelector` - Horizontal scrollable SDG chip list
- `SdgChip` - Individual SDG button with color coding
- `_getSdgColor()` - Official SDG color mapping

**Props:**
- `selectedSdg`: Currently selected SDG
- `onSdgChanged`: Callback when selection changes

### 3. **financial_metrics.dart** (Financial Data)
Displays company financial performance:
- Revenue, EBITDA, Total Assets, Sustainability Investment cards
- 5-year revenue trend chart (LineChart)
- Investment allocation breakdown (BarChart: R&D vs CapEx vs Sustainability)
- Industry benchmark comparisons

**Props:**
- `company`: CompanyBasicInfo containing FinancialMetrics

### 4. **environmental_metrics.dart** (Environmental ESG Metrics)
Shows environmental performance indicators:
- Energy Consumption (LineChart - decreasing trend)
- GHG Emissions Breakdown (BarChart - Scope 1/2/3)
- Water Withdrawal (LineChart - decreasing trend)
- Renewable Energy Percentage (LineChart - increasing trend)

**Props:**
- `environmental`: EnvironmentalTopics with energy, water, waste, materials data

**Charts:** Uses fl_chart LineChart and BarChart with customized axes

### 5. **social_metrics.dart** (Social ESG Metrics)
Displays workforce and well-being metrics:
- Total Employees & Turnover Rate
- Women in Workforce % & Women in Leadership %
- 5-year employee growth trend (LineChart)
- Gender diversity trend (LineChart)
- Lost Time Injury Rate & Safety Incidents
- 5-year safety performance (LineChart)

**Props:**
- `social`: SocialTopics with workforce, health/safety, training, diversity data

### 6. **governance_metrics.dart** (Governance ESG Metrics)
Shows corporate governance structure:
- Board Size & Independent Directors %
- Women on Board % & Meeting Attendance %
- Employee Ethics Training % & Violations Reported
- Suppliers Audited % & Remediation Cases
- Privacy Incidents count

**Props:**
- `governance`: GovernanceTopics with board, ethics, privacy, supply chain data

## Updated Main Screen (`stakeholder_screen_refactored.dart`)

The new main screen is **~115 lines** (reduced from 1673) and:

1. **Imports all widget modules** at the top
2. **Maintains state management** for SDG selection
3. **Passes data to child widgets** via props
4. **Orchestrates layout** without implementing metric logic
5. **Handles company selection** dropdown

### Structure:
```dart
Column(
  children: [
    StakeholderHeader(),              // Fixed import
    CompanySelector(),                // Dropdown
    SdgSelector(),                    // With onChanged callback
    FinancialMetricsWidget(),         // Passes basicInfo
    EnvironmentalMetricsWidget(),     // Passes environmental topics
    SocialMetricsWidget(),            // Passes social topics
    GovernanceMetricsWidget(),        // Passes governance topics
  ],
)
```

## Key Design Decisions

### 1. **Separation of Concerns**
- UI components (`common_widgets.dart`)
- Feature-specific widgets (financial, environmental, etc.)
- Main orchestrator (`stakeholder_screen_refactored.dart`)

### 2. **Chart Consolidation**
- Each metric widget contains its own chart builders
- Uses fl_chart LineChart and BarChart
- Hardcoded demo data for 5-year trends
- Real data integration ready (just update chart spot/bar data)

### 3. **Error Handling**
- Try-catch blocks in each metric widget
- Graceful fallback to NoDataCard
- No app crashes on missing data

### 4. **Responsive Design**
- Maintained responsive layout in main screen
- Desktop/mobile awareness preserved
- Padding and spacing consistent across modules

### 5. **Props Pattern**
- Widgets receive required data via constructor
- No direct access to global state
- Easy to test and reuse

## Migration Path

To use the refactored version:

1. **Replace imports** in `main_navigation_screen.dart`:
   ```dart
   // OLD
   import 'screens/stakeholder/stakeholder_screen.dart';
   
   // NEW  
   import 'screens/stakeholder/stakeholder_screen_refactored.dart';
   ```

2. **Keep original file** for reference (or delete if confident)

3. **Run dart fix** to catch any issues:
   ```bash
   dart fix --apply
   ```

## Benefits

✅ **Maintainability**: Each widget has single responsibility
✅ **Reusability**: Widget can be used in other screens
✅ **Testability**: Smaller widgets easier to unit test
✅ **Readability**: Main screen code is concise (~115 lines)
✅ **Performance**: No performance degradation vs monolithic file
✅ **Scalability**: Easy to add new metric types

## Compilation Status

All files compile with **0 errors**:
- ✅ common_widgets.dart
- ✅ sdg_selector.dart
- ✅ financial_metrics.dart
- ✅ environmental_metrics.dart
- ✅ social_metrics.dart
- ✅ governance_metrics.dart
- ✅ stakeholder_screen_refactored.dart

## Future Improvements

1. **Data Integration**: Replace hardcoded chart data with real metrics from `CompanyESGData`
2. **SDG Filtering**: Filter metrics based on selected SDG
3. **Chart Animation**: Add entry animations to charts
4. **Export Functionality**: Add PDF/CSV export for reports
5. **Comparison View**: Side-by-side company comparison mode
6. **Time Range Selection**: Allow custom year ranges for charts

## File Line Count Summary

| File | Lines | Type |
|------|-------|------|
| stakeholder_screen.dart (original) | 1673 | Monolithic |
| stakeholder_screen_refactored.dart | 115 | Main Screen |
| common_widgets.dart | 400+ | Shared Components |
| sdg_selector.dart | 80+ | Feature Widget |
| financial_metrics.dart | 250+ | Feature Widget |
| environmental_metrics.dart | 240+ | Feature Widget |
| social_metrics.dart | 350+ | Feature Widget |
| governance_metrics.dart | 130+ | Feature Widget |
| **Total Refactored** | **~1565** | **Modular** |

**Result**: Improved maintainability with similar total lines but much better organization.
