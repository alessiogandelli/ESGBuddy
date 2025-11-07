import 'package:flutter/material.dart';

/// Centralized theme and styling for the app
/// Change colors, fonts, and styles here to update the entire app
class AppTheme {
  // ========== COLORS ==========

  // Primary brand color
  static const Color primaryColor = Colors.green;
  static const int primaryColorShade = 700;

  // Category colors for ESG metrics
  static const Color environmentalColor = Colors.green;
  static const Color socialColor = Colors.blue;
  static const Color governanceColor = Colors.purple;
  static const Color defaultCategoryColor = Colors.grey;

  // Score indicator colors
  static const Color highScoreColor = Colors.green;
  static const Color mediumScoreColor = Colors.orange;
  static const Color lowScoreColor = Colors.red;

  // UI state colors
  static const Color errorColor = Colors.red;
  static Color errorIconColor = Colors.red.shade300;
  static Color secondaryTextColor = Colors.grey.shade600;
  static Color emptyStateIconColor = Colors.grey.shade400;
  static Color cardBackgroundColor = Colors.white;

  // ========== TEXT STYLES ==========

  static TextStyle headlineStyle(BuildContext context) {
    return Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold) ??
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }

  static TextStyle titleStyle(BuildContext context) {
    return Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  static TextStyle subtitleStyle(BuildContext context) {
    return Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold) ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  }

  static TextStyle bodyStyle(BuildContext context) {
    return TextStyle(color: secondaryTextColor);
  }

  static TextStyle secondaryTextStyle() {
    return TextStyle(color: secondaryTextColor, fontSize: 14);
  }

  static TextStyle smallTextStyle() {
    return TextStyle(color: secondaryTextColor, fontSize: 12);
  }

  // ========== DIMENSIONS ==========

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  static const double paddingXLarge = 24.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;

  static const double iconSizeSmall = 48.0;
  static const double iconSizeMedium = 64.0;

  static const double cardMargin = 12.0;

  // ========== THEME DATA ==========

  /// Get the main theme for the app
  static ThemeData getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF388E3C), // green[700]
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      ),
    );
  }

  // ========== HELPER METHODS ==========

  /// Get color based on ESG score
  static Color getScoreColor(double score) {
    if (score >= 80) return highScoreColor;
    if (score >= 60) return mediumScoreColor;
    return lowScoreColor;
  }

  /// Get color based on ESG category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'environmental':
        return environmentalColor;
      case 'social':
        return socialColor;
      case 'governance':
        return governanceColor;
      default:
        return defaultCategoryColor;
    }
  }

  /// Get icon based on ESG category
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'environmental':
        return Icons.eco;
      case 'social':
        return Icons.people;
      case 'governance':
        return Icons.gavel;
      default:
        return Icons.analytics;
    }
  }

  /// Create a score badge widget
  static Widget buildScoreBadge(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: getScoreColor(score),
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      child: Text(
        score.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Create a category icon container
  static Widget buildCategoryIcon(String category) {
    return Container(
      width: iconSizeSmall,
      height: iconSizeSmall,
      decoration: BoxDecoration(
        color: getCategoryColor(category).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
      child: Icon(getCategoryIcon(category), color: getCategoryColor(category)),
    );
  }
}
