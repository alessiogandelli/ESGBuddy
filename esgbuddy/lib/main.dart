import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/app_config.dart';
import 'data/i_esg_repository.dart';
import 'data/api_service.dart';
import 'data/esg_repository.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/company_list_screen.dart';
import 'presentation/screens/methodology_screen.dart';

void main() {
  // Real backend connection
  final IEsgRepository repository = EsgRepository(
    apiService: ApiService(baseUrl: AppConfig.baseUrl),
  );

  runApp(MainApp(repository: repository));
}

class MainApp extends StatelessWidget {
  final IEsgRepository repository;

  const MainApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESG Buddy',
      theme: AppTheme.getTheme(),
      home: HomeScreen(repository: repository),
      routes: {
        '/methodology': (context) => const MethodologyScreen(),
        '/companies': (context) => CompanyListScreen(repository: repository),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
