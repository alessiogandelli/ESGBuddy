import 'package:flutter/material.dart';

class MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isGood;
  final double? trend;

  const MetricRow(
    this.label,
    this.value, {
    super.key,
    this.isGood = false,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Row(
            children: [
              if (trend != null && trend != 0) ...[
                Icon(
                  trend! < 0 ? Icons.trending_down : Icons.trending_up,
                  color: trend! < 0 ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trend!.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: trend! < 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (isGood)
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
              if (isGood) const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
