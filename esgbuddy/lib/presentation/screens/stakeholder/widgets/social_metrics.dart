import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:esgbuddy/models/topics_data.dart';
import 'common_widgets.dart';

/// Widget displaying social ESG metrics
class SocialMetricsWidget extends StatelessWidget {
  final SocialTopics social;

  const SocialMetricsWidget({
    required this.social,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    try {
      final workforceMetrics = social.workforce.metrics;
      final totalEmployees = workforceMetrics.totalHeadcount;
      final turnoverRate = totalEmployees > 0
          ? ((workforceMetrics.departures / totalEmployees) * 100)
          : 0.0;

      widgets.addAll([
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Total Employees',
                value: _formatNumber(totalEmployees.toDouble()),
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Employee Turnover',
                value: '${turnoverRate.toStringAsFixed(1)}%',
                icon: Icons.transfer_within_a_station,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ]);

      final womenCount = workforceMetrics.employeesByGender['Female'] ?? 0;
      final womenPct = totalEmployees > 0 ? (womenCount / totalEmployees * 100) : 0;
      final womenLeadershipPct = totalEmployees > 0
          ? (workforceMetrics.womenInManagement / totalEmployees * 100)
          : 0;

      widgets.addAll([
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Women in Workforce',
                value: '${womenPct.toStringAsFixed(1)}%',
                icon: Icons.woman,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Women in Leadership',
                value: '${womenLeadershipPct.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.pink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        MetricCardWithChart(
          title: 'Employee Growth',
          subtitle: '5-year headcount trend',
          icon: Icons.people_outline,
          chart: _buildEmployeeChart(),
        ),
        const SizedBox(height: 16),
        MetricCardWithChart(
          title: 'Women Workforce %',
          subtitle: 'Gender diversity trend',
          icon: Icons.woman,
          chart: _buildDiversityChart(),
        ),
      ]);

      final healthSafetyMetrics = social.healthSafety.metrics;
      widgets.addAll([
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCardSimple(
                label: 'Lost Time Injury Rate',
                value: '${healthSafetyMetrics.ltir.toStringAsFixed(2)}',
                icon: Icons.health_and_safety,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCardSimple(
                label: 'Safety Incidents',
                value: healthSafetyMetrics.recordableInjuries.toStringAsFixed(0),
                icon: Icons.warning,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        MetricCardWithChart(
          title: 'Safety Performance',
          subtitle: 'LTIR over 5 years',
          icon: Icons.health_and_safety,
          chart: _buildSafetyChart(),
        ),
      ]);
    } catch (e) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: NoDataCard('Unable to load social metrics'),
      );
    }

    return Column(
      children: widgets.isEmpty
          ? [const NoDataCard('No social metrics available')]
          : widgets,
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  Widget _buildEmployeeChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const years = ['2020', '2021', '2022', '2023', '2024'];
                return Text(
                  value.toInt() < years.length ? years[value.toInt()] : '',
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 8500),
              FlSpot(1, 9200),
              FlSpot(2, 10100),
              FlSpot(3, 10800),
              FlSpot(4, 11500),
            ],
            isCurved: true,
            color: const Color(0xFF2196F3),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF2196F3),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        minY: 8000,
        maxY: 12000,
      ),
    );
  }

  Widget _buildDiversityChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const years = ['2020', '2021', '2022', '2023', '2024'];
                return Text(
                  value.toInt() < years.length ? years[value.toInt()] : '',
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 38),
              FlSpot(1, 39),
              FlSpot(2, 41),
              FlSpot(3, 43),
              FlSpot(4, 45),
            ],
            isCurved: true,
            color: const Color(0xFFE91E63),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFFE91E63),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        minY: 35,
        maxY: 50,
      ),
    );
  }

  Widget _buildSafetyChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const years = ['2020', '2021', '2022', '2023', '2024'];
                return Text(
                  value.toInt() < years.length ? years[value.toInt()] : '',
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3.2),
              FlSpot(1, 2.8),
              FlSpot(2, 2.4),
              FlSpot(3, 1.9),
              FlSpot(4, 1.5),
            ],
            isCurved: true,
            color: const Color(0xFFF44336),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFFF44336),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        minY: 1,
        maxY: 3.5,
      ),
    );
  }
}
