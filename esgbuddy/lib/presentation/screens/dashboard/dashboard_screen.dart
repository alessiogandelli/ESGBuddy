import 'package:esgbuddy/presentation/screens/dashboard/widgets/dashboard_hero.dart';
import 'package:esgbuddy/presentation/screens/dashboard/widgets/dashboard_title.dart';
import 'package:flutter/material.dart';
import '../../../models/company_esg_data.dart';


class DashboardScreen extends StatelessWidget {
  final CompanyESGData company;

  const DashboardScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardTitle(company: company),
                DashboardHero(company: company),
                //DashboardBody(company: company),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
