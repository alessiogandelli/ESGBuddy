import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:esgbuddy/models/topics_data.dart';
import 'package:esgbuddy/models/company_esg_data.dart';
import 'common_widgets.dart';

/// Widget displaying environmental ESG metrics
class EnvironmentalMetricsWidget extends StatelessWidget {
  final EnvironmentalTopics environmental;
  final List<CompanyESGData> companyHistory;

  const EnvironmentalMetricsWidget({
    required this.environmental,
    required this.companyHistory,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    try {
      final metrics = environmental.energyClimate.metrics;
      widgets.addAll([
        MetricCardWithChart(
          title: 'Total Energy Consumption',
          subtitle: '${_formatNumber(metrics.electricityConsumedKwh)} kWh',
          icon: Icons.bolt,
          chart: _buildEnergyConsumptionChart(),
        ),
        const SizedBox(height: 16),
        MetricCardWithChart(
          title: 'GHG Emissions Breakdown',
          subtitle: 'Scope 1+2+3',
          icon: Icons.cloud,
          chart: _buildEmissionsBreakdownChart(metrics),
        ),
        const SizedBox(height: 16),
      ]);

      final waterMetrics = environmental.water.metrics;
      widgets.addAll([
        MetricCardWithChart(
          title: 'Water Withdrawal',
          subtitle: '${_formatNumber(waterMetrics.waterWithdrawalM3)} m³',
          icon: Icons.water_drop,
          chart: _buildWaterChart(),
        ),
        const SizedBox(height: 16),
      ]);
    } catch (e) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: NoDataCard('Unable to load environmental metrics'),
      );
    }

    return Column(
      children: widgets.isEmpty 
          ? [const NoDataCard('No environmental metrics available')]
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

  Widget _buildEnergyConsumptionChart() {
    if (companyHistory.length < 2) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Need multiple years of data',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final spots = <FlSpot>[];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var i = 0; i < companyHistory.length; i++) {
      final energy = companyHistory[i].topics.environmental.energyClimate.metrics.electricityConsumedKwh;
      spots.add(FlSpot(i.toDouble(), energy));
      if (energy < minY) minY = energy;
      if (energy > maxY) maxY = energy;
    }

    if (spots.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No energy data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Add some padding to min/max
    final padding = (maxY - minY) * 0.1;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY = maxY + padding;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatNumber(value),
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
               interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < companyHistory.length) {
                  return Text(
                    'FY${companyHistory[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 11),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFFFFC107),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFFFFC107),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        minY: minY,
        maxY: maxY,
      ),
    );
  }

  Widget _buildEmissionsBreakdownChart(EnergyClimateMetrics metrics) {
    return BarChart(
      BarChartData(
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
              reservedSize: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Scope 1', 'Scope 2', 'Scope 3'];
                return Text(
                  value.toInt() < labels.length ? labels[value.toInt()] : '',
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: metrics.scope1Tco2e, color: const Color(0xFFD32F2F), width: 20)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: metrics.scope2MarketTco2e, color: const Color(0xFFF57C00), width: 20)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: metrics.scope3SelectedTco2e, color: const Color(0xFFFBC02D), width: 20)]),
        ],
      ),
    );
  }

  Widget _buildWaterChart() {
    if (companyHistory.length < 2) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Need multiple years of data',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final spots = <FlSpot>[];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var i = 0; i < companyHistory.length; i++) {
      final water = companyHistory[i].topics.environmental.water.metrics.waterWithdrawalM3;
      spots.add(FlSpot(i.toDouble(), water));
      if (water < minY) minY = water;
      if (water > maxY) maxY = water;
    }

    if (spots.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No water data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Add some padding to min/max
    final padding = (maxY - minY) * 0.1;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY = maxY + padding;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatNumber(value),
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            
            sideTitles: SideTitles(
              showTitles: true,
               interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < companyHistory.length) {
                  return Text(
                    'FY${companyHistory[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 11),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade200)),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF03A9F4),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF03A9F4),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        minY: minY,
        maxY: maxY,
      ),
    );
  }
}
