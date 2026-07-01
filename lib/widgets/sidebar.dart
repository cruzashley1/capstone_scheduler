// widgets/sidebar.dart (Updated with 3 Tools items)
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Schedulr',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // Main Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuHeader('MAIN MENU'),
                _buildMenuItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                ),
                _buildMenuItem(
                  index: 1,
                  icon: Icons.people_outline,
                  label: 'Security Management',
                ),
                _buildMenuItem(
                  index: 2,
                  icon: Icons.location_on_outlined,
                  label: 'Station Management',
                ),

                const SizedBox(height: 24),
                _buildMenuHeader('TOOLS'),
                _buildMenuItem(
                  index: 3,
                  icon: Icons.calendar_today_outlined,
                  label: 'Auto Scheduler',
                ),
                _buildMenuItem(
                  index: 4,
                  icon: Icons.auto_fix_high,
                  label: 'AI SmartReplace',
                ),
                _buildMenuItem(
                  index: 5,
                  icon: Icons.bar_chart_outlined,
                  label: 'Reports',
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // Bottom Menu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBottomMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => onItemSelected(6),
                ),
                const SizedBox(height: 8),
                _buildBottomMenuItem(
                  icon: Icons.logout_outlined,
                  label: 'Log Out',
                  onTap: () {},
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => onItemSelected(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red[300] : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isLogout ? Colors.red[300] : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}