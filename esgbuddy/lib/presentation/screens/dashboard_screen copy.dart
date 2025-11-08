import 'package:flutter/material.dart';
import '../../models/company_esg_data.dart';
import '../widgets/dashboard_widgets/esg_hero_card.dart';
import '../widgets/dashboard_widgets/topic_scores_section.dart';
import '../widgets/dashboard_widgets/sdg_scores_section.dart';
import '../widgets/dashboard_widgets/report_quality_section.dart';
import '../widgets/dashboard_widgets/metric_section.dart';
import '../widgets/dashboard_widgets/metric_row.dart';

class DashboardScreen extends StatelessWidget {
  final CompanyESGData company;

  const DashboardScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.basicInfo.tradeName),
              Text(
                company.basicInfo.sector,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.assessment), text: 'Overview'),
              Tab(icon: Icon(Icons.eco), text: 'Environmental'),
              Tab(icon: Icon(Icons.people), text: 'Social'),
              Tab(icon: Icon(Icons.gavel), text: 'Governance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(context, isDesktop),
            _buildEnvironmentalTab(context),
            _buildSocialTab(context),
            _buildGovernanceTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ESG Hero Card with improved layout
          ESGHeroCard(company: company, isDesktop: isDesktop),
          const SizedBox(height: 24),

          // Topic Scores Section
          TopicScoresSection(
            topicScores: company.topicScores,
            isDesktop: isDesktop,
          ),
          const SizedBox(height: 24),

          // SDG Scores Section
          SdgScoresSection(sdgScores: company.sdgScores, isDesktop: isDesktop),
          const SizedBox(height: 24),

          // Report Quality
          ReportQualitySection(qa: company.report.qa, isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalTab(BuildContext context) {
    final env = company.topics.environmental;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MetricSection(
          title: 'Energy & Climate',
          icon: Icons.bolt,
          color: Colors.green.shade700,
          children: [
            MetricRow('Electricity Consumed', '${_formatNumber(env.energyClimate.metrics.electricityConsumedKwh)} kWh'),
            MetricRow('Renewable Energy', '${env.energyClimate.metrics.renewableEnergyPct.toStringAsFixed(1)}%'),
            MetricRow('Natural Gas', '${_formatNumber(env.energyClimate.metrics.naturalGasM3)} m³'),
            MetricRow('Diesel', '${_formatNumber(env.energyClimate.metrics.dieselLiters)} L'),
            const Divider(),
            MetricRow('Scope 1 Emissions', '${_formatNumber(env.energyClimate.metrics.scope1Tco2e)} tCO₂e'),
            MetricRow('Scope 2 (Market)', '${_formatNumber(env.energyClimate.metrics.scope2MarketTco2e)} tCO₂e'),
            MetricRow('Scope 2 (Location)', '${_formatNumber(env.energyClimate.metrics.scope2LocationTco2e)} tCO₂e'),
            MetricRow('Scope 3 (Selected)', '${_formatNumber(env.energyClimate.metrics.scope3SelectedTco2e)} tCO₂e'),
            const Divider(),
            MetricRow(
              'Energy Intensity', 
              '${env.energyClimate.metrics.energyIntensityKwhPerEurRevenue.toStringAsFixed(2)} kWh/€', 
              trend: env.energyClimate.metrics.yoyEnergyIntensityChangePct
            ),
            MetricRow(
              'Emissions Intensity', 
              '${env.energyClimate.metrics.emissionsIntensityTco2ePerMEur.toStringAsFixed(1)} tCO₂e/M€', 
              trend: env.energyClimate.metrics.yoyEmissionsIntensityChangePct
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Targets Section for Energy & Climate
        if (env.energyClimate.targets.targetYear > 0)
          MetricSection(
            title: 'Energy & Climate Targets',
            icon: Icons.flag,
            color: Colors.green.shade900,
            children: [
              MetricRow('Renewable Energy Target', '${env.energyClimate.targets.renewableEnergyTargetPct.toStringAsFixed(0)}% by ${env.energyClimate.targets.targetYear}'),
              MetricRow('Scope 1 & 2 Net Zero Target', '${env.energyClimate.targets.scope12NetZeroYear}'),
              MetricRow('Scope 3 Coverage Target', '${env.energyClimate.targets.scope3CoveragePctTarget.toStringAsFixed(0)}%'),
            ],
          ),
        const SizedBox(height: 16),
        
        MetricSection(
          title: 'Water & Effluents',
          icon: Icons.water_drop,
          color: Colors.blue.shade700,
          children: [
            MetricRow('Water Withdrawal', '${_formatNumber(env.water.metrics.waterWithdrawalM3)} m³'),
            MetricRow('Water Discharge', '${_formatNumber(env.water.metrics.waterDischargeM3)} m³'),
            MetricRow('Water Consumption', '${_formatNumber(env.water.metrics.waterConsumptionM3)} m³'),
            MetricRow('Water Recycled', '${_formatNumber(env.water.metrics.waterRecycledM3)} m³'),
            MetricRow(
              'Water Intensity', 
              '${env.water.metrics.waterIntensityM3PerEurRevenue.toStringAsFixed(5)} m³/€', 
              trend: env.water.metrics.yoyWaterIntensityChangePct
            ),
            MetricRow('Sites in Water-Stressed Areas', '${env.water.metrics.sitesInWaterStressedAreas}'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Waste Management',
          icon: Icons.delete_outline,
          color: Colors.orange.shade700,
          children: [
            MetricRow('Waste Generated', '${_formatNumber(env.waste.metrics.wasteGeneratedT)} tonnes'),
            MetricRow('Waste Diverted', '${_formatNumber(env.waste.metrics.wasteDivertedT)} tonnes'),
            MetricRow('Waste Disposed', '${_formatNumber(env.waste.metrics.wasteDisposedT)} tonnes'),
            MetricRow('Hazardous Waste', '${_formatNumber(env.waste.metrics.hazardousWasteT)} tonnes'),
            MetricRow('Recycling Rate', '${env.waste.metrics.recyclingRatePct.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Materials',
          icon: Icons.inventory_2_outlined,
          color: Colors.brown.shade700,
          children: [
            MetricRow('Paper Used', '${_formatNumber(env.materials.metrics.paperT)} tonnes'),
            MetricRow('Recycled Content (Paper)', '${env.materials.metrics.recycledContentPaperPct.toStringAsFixed(0)}%'),
            MetricRow('Plastic Packaging', '${_formatNumber(env.materials.metrics.plasticPackagingT)} tonnes'),
            MetricRow('Recyclable Packaging', '${env.materials.metrics.recyclablePackagingPct.toStringAsFixed(0)}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialTab(BuildContext context) {
    final social = company.topics.social;
    final female = social.workforce.metrics.employeesByGender['female'] ?? 0;
    final male = social.workforce.metrics.employeesByGender['male'] ?? 0;
    final total = social.workforce.metrics.totalHeadcount;
    final femalePct = total > 0 ? (female / total * 100).toStringAsFixed(0) : '0';
    final malePct = total > 0 ? (male / total * 100).toStringAsFixed(0) : '0';
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MetricSection(
          title: 'Workforce',
          icon: Icons.groups,
          color: Colors.purple.shade700,
          children: [
            MetricRow('Total Headcount', '${social.workforce.metrics.totalHeadcount}'),
            MetricRow('New Hires', '${social.workforce.metrics.newHires}'),
            MetricRow('Departures', '${social.workforce.metrics.departures}'),
            const Divider(),
            MetricRow('Female Employees', '$female ($femalePct%)'),
            MetricRow('Male Employees', '$male ($malePct%)'),
            MetricRow('Women in Management', '${social.workforce.metrics.womenInManagement}'),
            MetricRow('Women on Board', '${social.workforce.metrics.womenOnBoard}'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Health & Safety',
          icon: Icons.health_and_safety,
          color: Colors.red.shade700,
          children: [
            MetricRow('Total Hours Worked', '${_formatNumber(social.healthSafety.metrics.totalHoursWorked.toDouble())}'),
            MetricRow('Recordable Injuries', '${social.healthSafety.metrics.recordableInjuries}'),
            MetricRow('Lost Time Injuries', '${social.healthSafety.metrics.lostTimeInjuries}'),
            MetricRow('Fatalities', '${social.healthSafety.metrics.fatalities}', isGood: social.healthSafety.metrics.fatalities == 0),
            const Divider(),
            MetricRow('TRIR (Total Recordable Injury Rate)', '${social.healthSafety.metrics.trir.toStringAsFixed(2)}'),
            MetricRow('LTIR (Lost Time Injury Rate)', '${social.healthSafety.metrics.ltir.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Training & Development',
          icon: Icons.school,
          color: Colors.indigo.shade700,
          children: [
            MetricRow('Total Training Hours', '${_formatNumber(social.training.metrics.totalTrainingHours.toDouble())}'),
            MetricRow('Avg Hours per Employee', '${social.training.metrics.avgTrainingHoursPerEmployee.toStringAsFixed(1)}'),
            MetricRow('Training Investment', '€${_formatNumber(social.training.metrics.trainingInvestmentEur)}'),
            MetricRow('Employees Reviewed', '${social.training.metrics.employeesReviewedPct.toStringAsFixed(0)}%'),
            MetricRow('Internal Promotion Rate', '${social.training.metrics.internalPromotionRatePct.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Diversity & Equity',
          icon: Icons.diversity_3,
          color: Colors.pink.shade700,
          children: [
            MetricRow('Gender Pay Gap', '${social.diversityEquity.metrics.genderPayGapPct.toStringAsFixed(1)}%'),
            MetricRow('Employees with Disabilities', '${social.diversityEquity.metrics.employeesWithDisabilities}'),
          ],
        ),
      ],
    );
  }

  Widget _buildGovernanceTab(BuildContext context) {
    final gov = company.topics.governance;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MetricSection(
          title: 'Ethics & Anti-Corruption',
          icon: Icons.verified_user,
          color: Colors.teal.shade700,
          children: [
            MetricRow('Code of Conduct', gov.ethicsAnticorruption.metrics.codeOfConductExists ? 'Yes' : 'No', isGood: gov.ethicsAnticorruption.metrics.codeOfConductExists),
            MetricRow('Employees Trained (CoC)', '${gov.ethicsAnticorruption.metrics.employeesTrainedCodeOfConductPct.toStringAsFixed(0)}%', isGood: gov.ethicsAnticorruption.metrics.employeesTrainedCodeOfConductPct >= 90),
            MetricRow('Anti-Corruption Policy', gov.ethicsAnticorruption.metrics.antiCorruptionPolicyExists ? 'Yes' : 'No', isGood: gov.ethicsAnticorruption.metrics.antiCorruptionPolicyExists),
            MetricRow('Employees Trained (AC)', '${gov.ethicsAnticorruption.metrics.employeesTrainedAntiCorruptionPct.toStringAsFixed(0)}%', isGood: gov.ethicsAnticorruption.metrics.employeesTrainedAntiCorruptionPct >= 90),
            const Divider(),
            MetricRow('Whistleblower Reports', '${gov.ethicsAnticorruption.metrics.whistleblowerReports}'),
            MetricRow('Confirmed Corruption Incidents', '${gov.ethicsAnticorruption.metrics.confirmedCorruptionIncidents}', isGood: gov.ethicsAnticorruption.metrics.confirmedCorruptionIncidents == 0),
            MetricRow('Legal Fines', '€${_formatNumber(gov.ethicsAnticorruption.metrics.legalFinesEur)}', isGood: gov.ethicsAnticorruption.metrics.legalFinesEur == 0),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Data Privacy & Security',
          icon: Icons.security,
          color: Colors.deepPurple.shade700,
          children: [
            MetricRow('ISO 27001 Certified', gov.dataPrivacySecurity.metrics.iso27001Certified ? 'Yes' : 'No', isGood: gov.dataPrivacySecurity.metrics.iso27001Certified),
            MetricRow('GDPR Compliant', gov.dataPrivacySecurity.metrics.gdprCompliant ? 'Yes' : 'No', isGood: gov.dataPrivacySecurity.metrics.gdprCompliant),
            MetricRow('Data Breaches', '${gov.dataPrivacySecurity.metrics.dataBreaches}', isGood: gov.dataPrivacySecurity.metrics.dataBreaches == 0),
            MetricRow('Customer Records Compromised', '${gov.dataPrivacySecurity.metrics.customerRecordsCompromised}', isGood: gov.dataPrivacySecurity.metrics.customerRecordsCompromised == 0),
            MetricRow('Penetration Tests Conducted', '${gov.dataPrivacySecurity.metrics.penetrationTestsConducted}'),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Board Governance',
          icon: Icons.meeting_room,
          color: Colors.blueGrey.shade700,
          children: [
            MetricRow('Board Size', '${gov.boardGovernance.metrics.boardSize}'),
            MetricRow('Independent Directors', '${gov.boardGovernance.metrics.independentDirectorsPct.toStringAsFixed(0)}%'),
            MetricRow('Board Gender Diversity', '${gov.boardGovernance.metrics.boardGenderDiversityWomenPct.toStringAsFixed(0)}% women'),
            MetricRow('Average Board Attendance', '${gov.boardGovernance.metrics.avgBoardAttendancePct.toStringAsFixed(0)}%'),
            MetricRow('Sustainability Committee', gov.boardGovernance.metrics.sustainabilityCommitteeExists ? 'Yes' : 'No', isGood: gov.boardGovernance.metrics.sustainabilityCommitteeExists),
          ],
        ),
        const SizedBox(height: 16),
        MetricSection(
          title: 'Supply Chain',
          icon: Icons.local_shipping,
          color: Colors.amber.shade900,
          children: [
            MetricRow('Total Suppliers', '${gov.supplyChain.metrics.totalSuppliers}'),
            MetricRow('Suppliers Signed Code of Conduct', '${gov.supplyChain.metrics.suppliersSignedCocPct.toStringAsFixed(0)}%'),
            MetricRow('Suppliers Audited (ESG)', '${gov.supplyChain.metrics.suppliersAuditedEsgPct.toStringAsFixed(0)}%'),
            const Divider(),
            MetricRow('Local Suppliers', '${gov.supplyChain.metrics.localSuppliersPct.toStringAsFixed(0)}%'),
            MetricRow('Local Procurement Spend', '${gov.supplyChain.metrics.procurementSpendLocalPct.toStringAsFixed(0)}%'),
            const Divider(),
            MetricRow('Supplier ESG Violations', '${gov.supplyChain.metrics.supplierEsgViolations}'),
            MetricRow('Violations Remediated', '${gov.supplyChain.metrics.supplierEsgViolationsRemediated}', isGood: gov.supplyChain.metrics.supplierEsgViolations == gov.supplyChain.metrics.supplierEsgViolationsRemediated),
          ],
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(1);
    }
  }
}
