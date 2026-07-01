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
                                () => onNavigate(ScreenType.availableManagement),
                          ),
                          _buildAnimatedCard(
                            'Absent Today',
                            stats['absentToday'].toString(),
                            Icons.warning_rounded,
                            const Color(0xFFEA580C),
                            'Needs replacement',
                                () => onNavigate(ScreenType.absentManagement),
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

  // UPDATED: now delegates to _HoverStatCard so the box can react to the
  // mouse (scale up + blue tinted glow) on hover. Signature unchanged so
  // every call site above still works as-is.
  Widget _buildAnimatedCard(String title, String value, IconData icon, Color color, String subtitle, VoidCallback? onTap) {
    return _HoverStatCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
      subtitle: subtitle,
      onTap: onTap,
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
// Hoverable version of the summary stat card. Same look as before at rest;
// on hover (desktop/web — touch devices won't trigger this) the card lifts
// off the page with its own accent color (no overlay tint or blue wash) and
// its icon badge fills in solid, the way a clean dashboard card "pops" on
// hover. Cards with no onTap (onTap == null) intentionally don't react to
// hover.
class _HoverStatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;
  final VoidCallback? onTap;

  const _HoverStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_HoverStatCard> createState() => _HoverStatCardState();
}

class _HoverStatCardState extends State<_HoverStatCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool canHover = widget.onTap != null;
    final bool active = _hovering && canHover;

    return MouseRegion(
      cursor: canHover ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 400),
          builder: (context, double entrance, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - entrance)),
              child: Opacity(
                opacity: entrance,
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            // Lift the whole card up a touch on hover instead of washing it
            // in a tinted overlay — reads as "raised off the page".
            transform: Matrix4.identity()
              ..translate(0.0, active ? -6.0 : 0.0)
              ..scale(active ? 1.012 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active ? widget.color.withOpacity(0.25) : Colors.transparent,
                width: 1.2,
              ),
              boxShadow: [
                // Soft, colored "contact" shadow that grows and drops lower
                // on hover, simulating the card lifting toward the light —
                // tinted with the card's own accent color, not a fixed blue.
                BoxShadow(
                  color: active ? widget.color.withOpacity(0.24) : widget.color.withOpacity(0.10),
                  blurRadius: active ? 26 : 10,
                  offset: active ? const Offset(0, 16) : const Offset(0, 4),
                ),
                if (active)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // Icon badge fills in solid on hover instead of
                          // the card itself washing in color.
                          color: active ? widget.color : widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.icon,
                          color: active ? Colors.white : widget.color,
                          size: 24,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: widget.color,
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
                        widget.value,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
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
}