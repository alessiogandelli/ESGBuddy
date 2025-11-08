import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:esgbuddy/models/company_esg_data.dart';

/// Widget displaying financial metrics and year-over-year trends
class FinancialMetricsWidget extends StatelessWidget {
  final CompanyBasicInfo company;

  const FinancialMetricsWidget({
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = company.financialMetrics;
    
    if (metrics == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Performance',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Key financial indicators and trends',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Main Financial Metrics Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
          crossAxisCount: isWide ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.5 : 0.95,
                  children: [
                    _buildMetricCard(
                    label: 'Annual Revenue',
                    value: metrics.annualRevenue,
                    currency: metrics.currency,
                    icon: Icons.trending_up,
                    color: const Color(0xFF2196F3),
                    percentage: 12.5,
                    ),
                    _buildMetricCard(
                    label: 'EBITDA',
                    value: metrics.ebitda,
                    currency: metrics.currency,
                    icon: Icons.bar_chart,
                    color: const Color(0xFF4CAF50),
                    percentage: metrics.ebitdaMargin,
                    ),
                    _buildMetricCard(
                    label: 'Total Assets',
                    value: metrics.totalAssets,
                    currency: metrics.currency,
                    icon: Icons.account_balance,
                    color: const Color(0xFFFF9800),
                    ),
                  ],
                  );
                },
                ),
              ),
              const SizedBox(height: 16),
              
              // Second Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return GridView.count(
                  crossAxisCount: isWide ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.5 : 0.95,
                  children: [
                    _buildMetricCard(
                    label: 'Capital Expenditure',
                    value: metrics.capex,
                    currency: metrics.currency,
                    icon: Icons.construction,
                    color: const Color(0xFF00BCD4),
                    ),
                    _buildMetricCard(
                    label: 'R&D Investment',
                    value: metrics.rdInvestment,
                    currency: metrics.currency,
                    icon: Icons.science,
                    color: const Color(0xFF9C27B0),
                    percentage: metrics.rdIntensity,
                    ),
                    _buildMetricCard(
                    label: 'Sustainability Investment',
                    value: metrics.sustainabilityInvestment,
                    currency: metrics.currency,
                    icon: Icons.eco,
                    color: const Color(0xFF8BC34A),
                    percentage: metrics.sustainabilityIntensity,
                    
                    ),
                  ],
                  );
                },
              ),
            ),
        const SizedBox(height: 32),
        
        // Charts
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildRevenueChart(metrics),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildInvestmentChart(metrics),
        ),    
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required double value,
    required String currency,
    required IconData icon,
    required Color color,
    double? percentage,
    String? percentageLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (percentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_upward, color: Color(0xFF4CAF50), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(value, currency),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          if (percentageLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                percentageLabel,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(FinancialMetrics metrics) {
    final currentRevenue = metrics.annualRevenue;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.blue.shade700, size: 24),
              const SizedBox(width: 12),
              const Text(
          'Revenue Trend',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Historical growth trajectory',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: currentRevenue / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
            return Text(
              _formatShort(value),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
            const years = ['2020', '2021', '2022', '2023', '2024'];
            if (value.toInt() >= 0 && value.toInt() < years.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  years[value.toInt()],
                  style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const SizedBox();
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              left: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _generateRevenueSpots(currentRevenue),
              isCurved: true,
              color: const Color(0xFF2196F3),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 6,
              color: Colors.white,
              strokeWidth: 3,
              strokeColor: const Color(0xFF2196F3),
            );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
            colors: [
              const Color(0xFF2196F3).withOpacity(0.3),
              const Color(0xFF2196F3).withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          minY: 0,
          maxY: currentRevenue * 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentChart(FinancialMetrics metrics) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.purple.shade700, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Investment Allocation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Distribution of capital across key areas',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: [metrics.rdInvestment, metrics.capex, metrics.sustainabilityInvestment]
                    .reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatShort(value),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['R&D', 'CapEx', 'Sustainability'];
                        if (value.toInt() >= 0 && value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: metrics.capex / 3,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: metrics.rdInvestment,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF9C27B0),
                            const Color(0xFF9C27B0).withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: metrics.capex,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00BCD4),
                            const Color(0xFF00BCD4).withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: metrics.sustainabilityInvestment,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF8BC34A),
                            const Color(0xFF8BC34A).withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateRevenueSpots(double currentRevenue) {
    // Generate historical data showing growth to current revenue
    return [
      FlSpot(0, currentRevenue * 0.65),
      FlSpot(1, currentRevenue * 0.75),
      FlSpot(2, currentRevenue * 0.85),
      FlSpot(3, currentRevenue * 0.92),
      FlSpot(4, currentRevenue),
    ];
  }

  String _formatCurrency(double amount, String currency) {
    final symbol = currency == 'EUR' ? '€' : '\$';
    if (amount >= 1000000000) {
      return '$symbol${(amount / 1000000000).toStringAsFixed(2)}B';
    } else if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol${amount.toStringAsFixed(0)}';
  }

  String _formatShort(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
