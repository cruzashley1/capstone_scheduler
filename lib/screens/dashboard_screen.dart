import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/employee.dart';
import '../models/station.dart';
import '../widgets/summary_card.dart';
import 'main_layout.dart';
import 'employee_detail_screen.dart';

class DashboardContent extends StatelessWidget {
  final Function(ScreenType, {dynamic data}) onNavigate;

  const DashboardContent({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = DummyData.getDashboardStats();

    // Get dummy stations with attendance info
    final stationsWithAttendance = _getDummyStationsWithAttendance();

    // YOUR EXACT ORIGINAL CONTENT - NO CHANGES TO DESIGN
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Header - EXACTLY AS YOU DESIGNED
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, Administrator',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1034A6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: const Color(0xFF1034A6)),
                          const SizedBox(width: 8),
                          Text(
                            'April 8, 2026',
                            style: TextStyle(
                              color: const Color(0xFF1034A6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF1034A6),
                      child: const Text(
                        'AD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content - EXACTLY AS YOU DESIGNED
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Summary Cards - MODIFIED: Only 4 cards now
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.6,
                        children: [
                          _buildAnimatedCard(
                            'Total Employees',
                            stats['totalEmployees'].toString(),
                            Icons.people_alt_rounded,
                            const Color(0xFF1034A6),
                            '+12% from last month',
                                () => onNavigate(ScreenType.employeeList),
                          ),
                          _buildAnimatedCard(
                            'Total Stations',
                            stats['totalStations'].toString(),
                            Icons.location_city_rounded,
                            const Color(0xFF059669),
                            'All operational',
                                () => onNavigate(ScreenType.stationManagement),
                          ),
                          _buildAnimatedCard(
                            'Relievers Available',
                            stats['relieversAvailable'].toString(),
                            Icons.swap_horiz_rounded,
                            const Color(0xFFDC2626),
                            'On standby',
                                () => onNavigate(ScreenType.employeeList),
                          ),
                          _buildAnimatedCard(
                            'Absent Today',
                            stats['absentToday'].toString(),
                            Icons.warning_rounded,
                            const Color(0xFFEA580C),
                            'Needs replacement',
                            null,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Modern Section Header - MODIFIED: Changed to Recent Stations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1034A6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Recent Stations',  // CHANGED: Was 'Recent Employees'
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => onNavigate(ScreenType.stationManagement),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text('View All'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1034A6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF1034A6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Horizontal Station List - MODIFIED: Now shows stations
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stationsWithAttendance.length,
                      itemBuilder: (context, index) {
                        final stationData = stationsWithAttendance[index];
                        return _buildModernStationCard(stationData);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DUMMY DATA: Returns stations with attendance info mapped to existing Station model
  List<Map<String, dynamic>> _getDummyStationsWithAttendance() {
    return [
      {
        'station': Station(
          id: 'ST001',
          name: '5ht Avenue',
          location: 'Downtown',
          capacity: 20,
          isActive: true,
        ),
        'totalEmployees': 14,
        'absentCount': 2, // Has absent employees - attention needed
      },
      {
        'station': Station(
          id: 'ST002',
          name: 'Abad Santos',
          location: 'North District',
          capacity: 15,
          isActive: true,
        ),
        'totalEmployees': 16,
        'absentCount': 0, // All present
      },
      {
        'station': Station(
          id: 'ST003',
          name: 'Central Terminal',
          location: 'South District',
          capacity: 18,
          isActive: true,
        ),
        'totalEmployees': 15,
        'absentCount': 1, // Has absent employees
      },
      {
        'station': Station(
          id: 'ST004',
          name: 'Carriedo',
          location: 'Industrial Zone',
          capacity: 10,
          isActive: true,
        ),
        'totalEmployees': 16,
        'absentCount': 0,
      },
      {
        'station': Station(
          id: 'ST005',
          name: 'Vito Cruz',
          location: 'Highway 101',
          capacity: 8,
          isActive: true,
        ),
        'totalEmployees': 15,
        'absentCount': 1,
      },
    ];
  }

  // YOUR EXACT ORIGINAL METHODS - NO CHANGES
  Widget _buildAnimatedCard(String title, String value, IconData icon, Color color, String subtitle, VoidCallback? onTap) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 400),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NEW METHOD: Station card with attention needed status
  Widget _buildModernStationCard(Map<String, dynamic> stationData) {
    final Station station = stationData['station'] as Station;
    final int totalEmployees = stationData['totalEmployees'] as int;
    final int absentCount = stationData['absentCount'] as int;

    final bool needsAttention = absentCount > 0;
    final Color statusColor = needsAttention ? const Color(0xFFDC2626) : const Color(0xFF059669);
    final String statusText = needsAttention ? 'Attention Needed' : 'All Present';
    final IconData statusIcon = needsAttention ? Icons.warning_rounded : Icons.check_circle_rounded;

    return GestureDetector(
      onTap: () {
        onNavigate(ScreenType.stationManagement, data: station);
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          // Add subtle border highlight if attention needed
          border: needsAttention ? Border.all(color: const Color(0xFFDC2626).withOpacity(0.3), width: 1) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: needsAttention
                            ? [
                          const Color(0xFFDC2626),
                          const Color(0xFFDC2626).withOpacity(0.8),
                        ]
                            : [
                          const Color(0xFF1034A6),
                          const Color(0xFF1034A6).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.location_city_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          station.id,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 12,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Employee Count Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people_alt_rounded, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 6),
                            Text(
                              'Total Assigned:',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$totalEmployees',
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (needsAttention) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_rounded, size: 16, color: const Color(0xFFDC2626)),
                              const SizedBox(width: 6),
                              Text(
                                'Absent:',
                                style: TextStyle(
                                  color: const Color(0xFFDC2626),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$absentCount',
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}