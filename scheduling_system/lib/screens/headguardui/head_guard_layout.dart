// screens/headguardui/head_guard_layout.dart
import 'package:flutter/material.dart';
import 'headguard_dashboard_screen.dart';
import 'headguard_schedule_screen.dart';
import 'headguard_report_screen.dart';
import 'headguard_alerts_screen.dart';
import 'headguard_profile_screen.dart';

class HeadGuardLayout extends StatefulWidget {
  final String username;

  const HeadGuardLayout({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<HeadGuardLayout> createState() => _HeadGuardLayoutState();
}

class _HeadGuardLayoutState extends State<HeadGuardLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HeadGuardDashboardScreen(username: widget.username),
      const HeadGuardScheduleScreen(),
      const HeadGuardReportScreen(),
      const HeadGuardAlertsScreen(),
      HeadGuardProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 0),
                _buildNavItem(Icons.calendar_today_outlined, 'Schedule', 1),
                _buildNavItem(Icons.assignment_outlined, 'Report', 2),
                _buildNavItem(Icons.notifications_outlined, 'Alerts', 3),
                _buildNavItem(Icons.person_outline, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1034A6).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1034A6) : Colors.grey[400],
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1034A6) : Colors.grey[400],
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}