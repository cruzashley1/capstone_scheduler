// screens/securityguardui/security_alerts_screen.dart
import 'package:flutter/material.dart';

class SecurityAlertsScreen extends StatefulWidget {
  const SecurityAlertsScreen({Key? key}) : super(key: key);

  @override
  State<SecurityAlertsScreen> createState() => _SecurityAlertsScreenState();
}

class _SecurityAlertsScreenState extends State<SecurityAlertsScreen> {
  int unreadCount = 2;

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Sudden Duty Call',
      'time': '8:45 AM',
      'description': 'Guard Martinez is unable to report. You are requested to cover the East Gate post today at 10:00 PM.',
      'icon': Icons.warning_amber_rounded,
      'iconColor': Colors.red,
      'iconBgColor': Colors.red.withOpacity(0.1),
      'isUnread': true,
      'type': 'urgent',
    },
    {
      'title': 'General Announcement',
      'time': 'Yesterday',
      'description': 'Mandatory safety briefing this Saturday, April 12 at 5:30 AM before shift. Attendance is required for all...',
      'icon': Icons.campaign_outlined,
      'iconColor': const Color(0xFF1034A6),
      'iconBgColor': const Color(0xFF1034A6).withOpacity(0.1),
      'isUnread': true,
      'type': 'announcement',
    },
    {
      'title': 'Schedule Updated',
      'time': 'Apr 9',
      'description': 'Your schedule for the week of April 14-20 has been updated. Please review your new assignments.',
      'icon': Icons.calendar_today_outlined,
      'iconColor': Colors.orange,
      'iconBgColor': Colors.orange.withOpacity(0.1),
      'isUnread': false,
      'type': 'schedule',
    },
    {
      'title': 'Uniform Reminder',
      'time': 'Apr 8',
      'description': 'All security personnel are reminded to wear the new uniform starting Monday, April 14. Collared ID must be visible at...',
      'icon': Icons.campaign_outlined,
      'iconColor': const Color(0xFF1034A6),
      'iconBgColor': const Color(0xFF1034A6).withOpacity(0.1),
      'isUnread': false,
      'type': 'announcement',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$unreadCount unread',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            unreadCount = 0;
                            for (var n in notifications) {
                              n['isUnread'] = false;
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: Colors.white.withOpacity(0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Mark all read',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
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
                      border: notification['isUnread']
                          ? Border.all(
                        color: const Color(0xFF1034A6).withOpacity(0.2),
                        width: 1.5,
                      )
                          : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: notification['iconBgColor'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            notification['icon'],
                            color: notification['iconColor'],
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification['title'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        notification['time'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      if (notification['isUnread']) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF1034A6),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notification['description'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}