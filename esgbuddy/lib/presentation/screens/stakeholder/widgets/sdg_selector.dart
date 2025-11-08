import 'package:flutter/material.dart';

/// Widget for selecting sustainable development goals (SDGs)
class SdgSelector extends StatelessWidget {
  final String selectedSdg;
  final Function(String) onSdgChanged;

  const SdgSelector({
    required this.selectedSdg,
    required this.onSdgChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sdgList = [
      'SDG 1: No Poverty',
      'SDG 3: Good Health',
      'SDG 5: Gender Equality',
      'SDG 7: Affordable Energy',
      'SDG 8: Decent Work',
      'SDG 10: Reduced Inequality',
      'SDG 12: Responsible Consumption',
      'SDG 13: Climate Action',
      'SDG 15: Life on Land',
      'SDG 17: Partnerships',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Sustainable Development Goals',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: sdgList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final sdg = sdgList[index];
              return SdgChip(
                label: sdg,
                isSelected: selectedSdg == sdg,
                onTap: () => onSdgChanged(sdg),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual SDG selection chip
class SdgChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SdgChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sdgNumber = label.split(':')[0].replaceAll('SDG', '').trim();
    final sdgColor = _getSdgColor(int.tryParse(sdgNumber) ?? 1);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: sdgColor,
      side: BorderSide(
        color: isSelected ? sdgColor : Colors.grey.shade300,
        width: 2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  static Color _getSdgColor(int sdgNumber) {
    const sdgColors = {
      1: Color(0xFFE5243B), // No Poverty - Red
      3: Color(0xFF4C9F38), // Good Health - Green
      5: Color(0xFFDD3E39), // Gender Equality - Red
      7: Color(0xFFC6192B), // Affordable Energy - Red
      8: Color(0xFFA21E48), // Decent Work - Maroon
      10: Color(0xFFDD1C3B), // Reduced Inequality - Red
      12: Color(0xFFBF8B2E), // Responsible Consumption - Brown
      13: Color(0xFF3F7E44), // Climate Action - Green
      15: Color(0xFF56C596), // Life on Land - Green
      17: Color(0xFF0A97DA), // Partnerships - Blue
    };

    return sdgColors[sdgNumber] ?? const Color(0xFF999999);
  }
}
