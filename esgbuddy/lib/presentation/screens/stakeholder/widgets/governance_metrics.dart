import 'package:flutter/material.dart';
import 'package:esgbuddy/models/topics_data.dart';
import 'common_widgets.dart';

/// Widget displaying governance ESG metrics
class GovernanceMetricsWidget extends StatelessWidget {
  final GovernanceTopics governance;

  const GovernanceMetricsWidget({
    required this.governance,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    try {
      final boardMetrics = governance.boardGovernance.metrics;

      widgets.addAll([
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Board Size',
                value: boardMetrics.boardSize.toStringAsFixed(0),
                icon: Icons.groups,
                color: const Color(0xFF9C27B0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Independent Directors',
                value: '${boardMetrics.independentDirectorsPct.toStringAsFixed(1)}%',
                icon: Icons.verified_user,
                color: const Color(0xFF673AB7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Women on Board',
                value: '${boardMetrics.boardGenderDiversityWomenPct.toStringAsFixed(1)}%',
                icon: Icons.woman,
                color: const Color(0xFFE91E63),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Meeting Attendance',
                value: '${boardMetrics.avgBoardAttendancePct.toStringAsFixed(1)}%',
                icon: Icons.event_available,
                color: const Color(0xFF00BCD4),
              ),
            ),
          ],
        ),
      ]);

      final ethicsMetrics = governance.ethicsAnticorruption.metrics;
      widgets.addAll([
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Employees Trained',
                value: '${ethicsMetrics.employeesTrainedCodeOfConductPct.toStringAsFixed(1)}%',
                icon: Icons.school,
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Violations Reported',
                value: ethicsMetrics.whistleblowerReports.toStringAsFixed(0),
                icon: Icons.info,
                color: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ]);

      final supplyChainMetrics = governance.supplyChain.metrics;
      widgets.addAll([
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Suppliers Audited',
                value: '${supplyChainMetrics.suppliersAuditedEsgPct.toStringAsFixed(1)}%',
                icon: Icons.fact_check,
                color: const Color(0xFF3F51B5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Remediation Cases',
                value: supplyChainMetrics.supplierEsgViolationsRemediated.toStringAsFixed(0),
                icon: Icons.check_circle,
                color: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ]);

      final privacyMetrics = governance.dataPrivacySecurity.metrics;
      widgets.addAll([
        const SizedBox(height: 16),
        MetricCardSimple(
          label: 'Privacy Incidents',
          value: privacyMetrics.dataBreaches.toStringAsFixed(0),
          icon: Icons.security,
          color: const Color(0xFFF44336),
        ),
      ]);
    } catch (e) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: NoDataCard('Unable to load governance metrics'),
      );
    }

    return Column(
      children: widgets.isEmpty
          ? [const NoDataCard('No governance metrics available')]
          : widgets,
    );
  }
}
