// screens/headguardui/headguard_profile_screen.dart
import 'package:flutter/material.dart';
import '../login_screen.dart';

class HeadGuardProfileScreen extends StatelessWidget {
  HeadGuardProfileScreen({Key? key}) : super(key: key);

  final String guardName = 'Carlos Mendoza';
  final String role = 'Head Guard';
  final String initials = 'CM';

  final List<Map<String, dynamic>> personalInfo = [
    {
      'label': 'Employee ID',
      'value': 'HG-2024-001',
      'icon': Icons.badge_outlined,
    },
    {
      'label': 'Assigned Station',
      'value': 'Main Gate',
      'icon': Icons.location_on_outlined,
    },
    {
      'label': 'Shift',
      'value': 'Morning Shift',
      'icon': Icons.access_time,
    },
    {
      'label': 'Date Joined',
      'value': 'January 10, 2021',
      'icon': Icons.calendar_today_outlined,
    },
  ];

  final List<Map<String, dynamic>> contactInfo = [
    {
      'label': 'Email Address',
      'value': 'carlos.mendoza@secureguard.ph',
      'icon': Icons.email_outlined,
    },
    {
      'label': 'Phone Number',
      'value': '+63 917 123 4567',
      'icon': Icons.phone_outlined,
    },
  ];

  final List<Map<String, dynamic>> settings = [
    {
      'label': 'Notification Preferences',
      'icon': Icons.notifications_outlined,
      'trailing': '>',
    },
    {
      'label': 'Change Password',
      'icon': Icons.lock_outlined,
      'trailing': '>',
    },
    {
      'label': 'Language',
      'icon': Icons.language,
      'trailing': 'English >',
    },
    {
      'label': 'Appearance',
      'icon': Icons.dark_mode_outlined,
      'trailing': 'Light >',
    },
  ];

  final List<Map<String, dynamic>> support = [
    {
      'label': 'Privacy Policy',
      'icon': Icons.shield_outlined,
      'trailing': '>',
    },
    {
      'label': 'Terms of Service',
      'icon': Icons.description_outlined,
      'trailing': '>',
    },
    {
      'label': 'Help & Support',
      'icon': Icons.help_outline,
      'trailing': '>',
    },
    {
      'label': 'About SecureGuard',
      'icon': Icons.info_outline,
      'trailing': 'v2.1.0 >',
    },
  ];

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1034A6),
                      Color(0xFF1E4AD0),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guardName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                role,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 12),
              _buildInfoList(personalInfo),

              const SizedBox(height: 24),

              _buildSectionTitle('Contact'),
              const SizedBox(height: 12),
              _buildInfoList(contactInfo),

              const SizedBox(height: 24),

              _buildSectionTitle('Settings'),
              const SizedBox(height: 12),
              _buildSettingsList(settings),

              const SizedBox(height: 24),

              _buildSectionTitle('Support & Legal'),
              const SizedBox(height: 12),
              _buildSettingsList(support),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _handleLogout(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoList(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1034A6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'],
                          color: const Color(0xFF1034A6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['value'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: Colors.grey[200],
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSettingsList(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1034A6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'],
                          color: const Color(0xFF1034A6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item['label'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Text(
                        item['trailing'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
                if (index < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: Colors.grey[200],
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}