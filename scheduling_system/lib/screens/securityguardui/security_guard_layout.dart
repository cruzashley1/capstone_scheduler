// screens/securityguardui/security_guard_layout.dart
import 'package:flutter/material.dart';
import 'security_dashboard_screen.dart';
import 'security_schedule_screen.dart';
import 'security_alerts_screen.dart';
import 'security_profile_screen.dart';

class SecurityGuardLayout extends StatefulWidget {
  final String username;

  const SecurityGuardLayout({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<SecurityGuardLayout> createState() => _SecurityGuardLayoutState();
}

class _SecurityGuardLayoutState extends State<SecurityGuardLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      SecurityDashboardScreen(username: widget.username),
      const SecurityScheduleScreen(),
      const SecurityAlertsScreen(),
      SecurityProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 0),
                _buildNavItem(Icons.calendar_today_outlined, 'Schedule', 1),
                _buildNavItem(Icons.notifications_outlined, 'Alerts', 2),
                _buildNavItem(Icons.person_outline, 'Profile', 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1034A6) : Colors.grey[400],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}