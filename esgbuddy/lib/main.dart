import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/app_config.dart';
import 'data/api_service.dart';
import 'data/esg_repository.dart';
import 'providers/company_provider.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/methodology_screen.dart';

void main() {
  // Initialize repository with real backend connection
  final repository = EsgRepository(
    apiService: ApiService(baseUrl: AppConfig.baseUrl),
  );

  // Create global company provider
  final companyProvider = CompanyProvider(repository: repository);

  runApp(MainApp(repository: repository, companyProvider: companyProvider));
}

class MainApp extends StatelessWidget {
  final EsgRepository repository;
  final CompanyProvider companyProvider;

  const MainApp({super.key, required this.repository, required this.companyProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESG Buddy',
      theme: AppTheme.getTheme(),
      home: MainNavigationScreen(repository: repository),
      routes: {
        '/methodology': (context) => const MethodologyScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
