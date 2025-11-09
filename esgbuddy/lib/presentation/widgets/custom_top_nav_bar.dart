import 'package:flutter/material.dart';

class CustomTopNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onAbout;

  const CustomTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onDownload,
    this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

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
          
          // Desktop Navigation
          if (!isMobile) ...[
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
            
            // Action buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: onDownload,
                  color: Colors.grey.shade600,
                  tooltip: 'Download',
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onAbout,
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('About'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          // Mobile Navigation - Hamburger Menu
          if (isMobile) ...[
            Row(
              children: [
                if (onDownload != null)
                  IconButton(
                    icon: const Icon(Icons.download_rounded),
                    onPressed: onDownload,
                    color: Colors.grey.shade600,
                    tooltip: 'Download',
                  ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onSelected: (value) {
                    switch (value) {
                      case 'dashboard':
                        onTap(0);
                        break;
                      case 'stakeholder':
                        onTap(1);
                        break;
                      case 'improve':
                        onTap(2);
                        break;
                      case 'about':
                        onAbout?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'dashboard',
                      child: Row(
                        children: [
                          Icon(
                            Icons.dashboard_rounded,
                            color: currentIndex == 0 ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              color: currentIndex == 0 ? const Color(0xFF4CAF50) : Colors.black87,
                              fontWeight: currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'stakeholder',
                      child: Row(
                        children: [
                          Icon(
                            Icons.groups_rounded,
                            color: currentIndex == 1 ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Stakeholder',
                            style: TextStyle(
                              color: currentIndex == 1 ? const Color(0xFF4CAF50) : Colors.black87,
                              fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'improve',
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            color: currentIndex == 2 ? const Color(0xFF4CAF50) : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Improve',
                            style: TextStyle(
                              color: currentIndex == 2 ? const Color(0xFF4CAF50) : Colors.black87,
                              fontWeight: currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'about',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 12),
                          Text('About', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
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
