import 'package:flutter/material.dart';

class SdgInfo {
  final int number;
  final String name;
  final String description;
  final Color color;
  final IconData icon;

  const SdgInfo({
    required this.number,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class SdgHelper {
  static const Map<int, SdgInfo> _sdgData = {
    1: SdgInfo(
      number: 1,
      name: 'No Poverty',
      description: 'End poverty in all its forms everywhere',
      color: Color(0xFFE5243B),
      icon: Icons.volunteer_activism,
    ),
    2: SdgInfo(
      number: 2,
      name: 'Zero Hunger',
      description: 'End hunger, achieve food security and improved nutrition',
      color: Color(0xFFDDA63A),
      icon: Icons.restaurant,
    ),
    3: SdgInfo(
      number: 3,
      name: 'Good Health',
      description: 'Ensure healthy lives and promote well-being for all',
      color: Color(0xFF4C9F38),
      icon: Icons.favorite,
    ),
    4: SdgInfo(
      number: 4,
      name: 'Quality Education',
      description: 'Ensure inclusive and equitable quality education',
      color: Color(0xFFC5192D),
      icon: Icons.school,
    ),
    5: SdgInfo(
      number: 5,
      name: 'Gender Equality',
      description: 'Achieve gender equality and empower all women and girls',
      color: Color(0xFFFF3A21),
      icon: Icons.people,
    ),
    6: SdgInfo(
      number: 6,
      name: 'Clean Water',
      description: 'Ensure availability and sustainable management of water',
      color: Color(0xFF26BDE2),
      icon: Icons.water_drop,
    ),
    7: SdgInfo(
      number: 7,
      name: 'Clean Energy',
      description: 'Ensure access to affordable, reliable, sustainable energy',
      color: Color(0xFFFCC30B),
      icon: Icons.flash_on,
    ),
    8: SdgInfo(
      number: 8,
      name: 'Decent Work',
      description: 'Promote sustained, inclusive economic growth and work',
      color: Color(0xFFA21942),
      icon: Icons.work,
    ),
    9: SdgInfo(
      number: 9,
      name: 'Innovation',
      description: 'Build resilient infrastructure, promote innovation',
      color: Color(0xFFFD6925),
      icon: Icons.science,
    ),
    10: SdgInfo(
      number: 10,
      name: 'Reduced Inequalities',
      description: 'Reduce inequality within and among countries',
      color: Color(0xFFDD1367),
      icon: Icons.balance,
    ),
    11: SdgInfo(
      number: 11,
      name: 'Sustainable Cities',
      description: 'Make cities and human settlements inclusive and sustainable',
      color: Color(0xFFFD9D24),
      icon: Icons.location_city,
    ),
    12: SdgInfo(
      number: 12,
      name: 'Responsible Consumption',
      description: 'Ensure sustainable consumption and production patterns',
      color: Color(0xFFBF8B2E),
      icon: Icons.recycling,
    ),
    13: SdgInfo(
      number: 13,
      name: 'Climate Action',
      description: 'Take urgent action to combat climate change',
      color: Color(0xFF3F7E44),
      icon: Icons.eco,
    ),
    14: SdgInfo(
      number: 14,
      name: 'Life Below Water',
      description: 'Conserve and sustainably use the oceans and seas',
      color: Color(0xFF0A97D9),
      icon: Icons.waves,
    ),
    15: SdgInfo(
      number: 15,
      name: 'Life on Land',
      description: 'Protect, restore and promote sustainable use of ecosystems',
      color: Color(0xFF56C02B),
      icon: Icons.forest,
    ),
    16: SdgInfo(
      number: 16,
      name: 'Peace & Justice',
      description: 'Promote peaceful and inclusive societies for development',
      color: Color(0xFF00689D),
      icon: Icons.gavel,
    ),
    17: SdgInfo(
      number: 17,
      name: 'Partnerships',
      description: 'Strengthen the means of implementation and partnerships',
      color: Color(0xFF19486A),
      icon: Icons.handshake,
    ),
  };

  static SdgInfo? getInfo(int sdgNumber) {
    return _sdgData[sdgNumber];
  }

  static String getName(int sdgNumber) {
    return _sdgData[sdgNumber]?.name ?? 'SDG $sdgNumber';
  }

  static String getDescription(int sdgNumber) {
    return _sdgData[sdgNumber]?.description ?? '';
  }

  static Color getColor(int sdgNumber) {
    return _sdgData[sdgNumber]?.color ?? Colors.grey;
  }

  static IconData getIcon(int sdgNumber) {
    return _sdgData[sdgNumber]?.icon ?? Icons.flag;
  }
}
