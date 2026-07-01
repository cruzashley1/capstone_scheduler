// screens/headguardui/station_overview_screen.dart
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Dummy data
// ---------------------------------------------------------------------------
const String _stationName = 'Monumento';

const List<Map<String, dynamic>> _onDutyList = [
  {'name': 'Guard Martinez', 'shift': 'Morning Shift', 'time': '0600H - 1400H', 'post': 'Main Gate'},
  {'name': 'Guard Santos',   'shift': 'Morning Shift', 'time': '0600H - 1400H', 'post': 'North Wing'},
  {'name': 'Guard Reyes',    'shift': 'Afternoon Shift','time': '1400H - 2200H', 'post': 'South Entrance'},
  {'name': 'Guard Cruz',     'shift': 'Afternoon Shift','time': '1400H - 2200H', 'post': 'Lobby'},
  {'name': 'Guard Bautista', 'shift': 'Night Shift',   'time': '2200H - 0600H', 'post': 'Main Gate'},
  {'name': 'Guard Aquino',   'shift': 'Night Shift',   'time': '2200H - 0600H', 'post': 'Parking Area'},
  {'name': 'Guard Dela Cruz','shift': 'Morning Shift', 'time': '0600H - 1400H', 'post': 'Roof Deck'},
  {'name': 'Guard Ramos',    'shift': 'Night Shift',   'time': '2200H - 0600H', 'post': 'Basement'},
  {'name': 'Guard Torres',   'shift': 'Afternoon Shift','time': '1400H - 2200H', 'post': 'East Wing'},
  {'name': 'Guard Villanueva','shift': 'Morning Shift','time': '0600H - 1400H', 'post': 'Checkpoint A'},
  {'name': 'Guard Castillo', 'shift': 'Afternoon Shift','time': '1400H - 2200H', 'post': 'Checkpoint B'},
  {'name': 'Guard Flores',   'shift': 'Night Shift',   'time': '2200H - 0600H', 'post': 'Perimeter'},
];

const List<Map<String, dynamic>> _allEmployeeList = [
  ..._onDutyList,
  {'name': 'Guard Navarro',  'shift': 'Day Off', 'time': '—', 'post': '—'},
  {'name': 'Guard Mendoza',  'shift': 'Day Off', 'time': '—', 'post': '—'},
  {'name': 'Guard Lim',      'shift': 'Day Off', 'time': '—', 'post': '—'},
  {'name': 'Guard Garcia',   'shift': 'Day Off', 'time': '—', 'post': '—'},
  {'name': 'Guard Lopez',    'shift': 'Day Off', 'time': '—', 'post': '—'},
  {'name': 'Guard Dela Torre','shift': 'Day Off', 'time': '—', 'post': '—'},
];

const List<Map<String, dynamic>> _dayOffList = [
  {'name': 'Guard Navarro',   'nextDuty': 'Apr 13 · Sun', 'shift': 'Morning Shift'},
  {'name': 'Guard Mendoza',   'nextDuty': 'Apr 13 · Sun', 'shift': 'Afternoon Shift'},
  {'name': 'Guard Lim',       'nextDuty': 'Apr 14 · Mon', 'shift': 'Morning Shift'},
  {'name': 'Guard Garcia',    'nextDuty': 'Apr 14 · Mon', 'shift': 'Night Shift'},
  {'name': 'Guard Lopez',     'nextDuty': 'Apr 15 · Tue', 'shift': 'Morning Shift'},
  {'name': 'Guard Dela Torre','nextDuty': 'Apr 15 · Tue', 'shift': 'Afternoon Shift'},
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class StationOverviewScreen extends StatefulWidget {
  const StationOverviewScreen({Key? key}) : super(key: key);

  @override
  State<StationOverviewScreen> createState() => _StationOverviewScreenState();
}

class _StationOverviewScreenState extends State<StationOverviewScreen> {
  bool _nodExpanded = false;
  bool _allEmpExpanded = false;
  bool _dayOffExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1034A6), Color(0xFF1E4AD0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button + title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Station Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Station name banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_city_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              _stationName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Station Name',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick stat chips
                  Row(
                    children: [
                      _buildHeaderChip(
                        icon: Icons.shield_outlined,
                        label: '${_onDutyList.length} NOD',
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      _buildHeaderChip(
                        icon: Icons.people_outline,
                        label: '${_allEmployeeList.length} Emp.',
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      _buildHeaderChip(
                        icon: Icons.bedtime_outlined,
                        label: '${_dayOffList.length} Off',
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 1. No. of Duty
                    _buildExpandableSection(
                      title: 'No. of Duty',
                      subtitle: 'NOD',
                      count: _onDutyList.length,
                      accentColor: const Color(0xFF1034A6),
                      icon: Icons.shield_outlined,
                      isExpanded: _nodExpanded,
                      onTap: () => setState(() => _nodExpanded = !_nodExpanded),
                      child: _buildDutyList(_onDutyList),
                    ),
                    const SizedBox(height: 12),

                    // 2. All Employee in Station
                    _buildExpandableSection(
                      title: 'All Employee in Station',
                      subtitle: 'All Emp.',
                      count: _allEmployeeList.length,
                      accentColor: Colors.teal,
                      icon: Icons.people_outline,
                      isExpanded: _allEmpExpanded,
                      onTap: () => setState(() => _allEmpExpanded = !_allEmpExpanded),
                      child: _buildDutyList(_allEmployeeList),
                    ),
                    const SizedBox(height: 12),

                    // 3. On Day Off
                    _buildExpandableSection(
                      title: 'On Day Off',
                      subtitle: 'Day Off',
                      count: _dayOffList.length,
                      accentColor: Colors.orange,
                      icon: Icons.bedtime_outlined,
                      isExpanded: _dayOffExpanded,
                      onTap: () => setState(() => _dayOffExpanded = !_dayOffExpanded),
                      child: _buildDayOffList(_dayOffList),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildHeaderChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String subtitle,
    required int count,
    required Color accentColor,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
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
        children: [
          // ── Header row (tap to toggle) ──
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Expandable content ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: Colors.grey[100]),
                child,
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  // List for No. of Duty & All Employee
  Widget _buildDutyList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isDayOff = item['shift'] == 'Day Off';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDayOff
                      ? Colors.grey.withOpacity(0.1)
                      : const Color(0xFF1034A6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials(item['name'] as String),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDayOff ? Colors.grey : const Color(0xFF1034A6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDayOff ? 'Day Off' : '${item['shift']} · ${item['post']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDayOff)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1034A6).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['time'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1034A6),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Off',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // List for On Day Off
  Widget _buildDayOffList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials(item['name'] as String),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Next: ${item['nextDuty']} · ${item['shift']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Day Off',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}