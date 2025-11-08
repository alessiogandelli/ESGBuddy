import 'package:flutter/material.dart';

class CustomTopNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onDownload;

  const CustomTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.eco_rounded,
                color: const Color(0xFF4CAF50),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'ESGBuddy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          
          
          // Navigation Items
          Row(
            children: [
              _NavBarItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              const SizedBox(width: 8),
              _NavBarItem(
                icon: Icons.groups_rounded,
                label: 'Stakeholder',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              const SizedBox(width: 8),
              _NavBarItem(
                icon: Icons.trending_up_rounded,
                label: 'Improve',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Action buttons (download and settings)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: onDownload,
                color: Colors.grey.shade600,
                tooltip: 'Download',
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
