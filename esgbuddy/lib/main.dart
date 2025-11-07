import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'data/i_esg_repository.dart';
import 'data/mock_esg_repository.dart';
import 'presentation/screens/home_screen.dart';

// Uncomment these for real backend:
// import 'config/app_config.dart';
// import 'data/api_service.dart';
// import 'data/esg_repository.dart';

void main() {
  // Option 1: Mock data (for testing without backend) - CURRENTLY ACTIVE
  final IEsgRepository repository = MockEsgRepository();

  // Option 2: Real backend (uncomment and comment out mock above)
  // final IEsgRepository repository = EsgRepository(
  //   apiService: ApiService(baseUrl: AppConfig.baseUrl),
  // );

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
      debugShowCheckedModeBanner: false,
    );
  }
}
