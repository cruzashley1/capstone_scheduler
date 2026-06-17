// screens/reports_content.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/employee.dart';
import 'main_layout.dart';

class ReportsContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data})? onNavigate;

  const ReportsContent({
    Key? key,
    this.onNavigate,
  }) : super(key: key);

  @override
  State<ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<ReportsContent> {
  String _selectedPeriod = 'This Week';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'Custom Range'];

  // Track selected date and station
  String? _selectedDate;
  Map<String, dynamic>? _selectedDayData;
  String? _selectedStation;

  // Sample stations
  final List<String> _stations = ['Station 1', 'Station 2', 'Station 3', 'Station 4', 'Station 5'];

  @override
  Widget build(BuildContext context) {
    // Show station schedule view if station selected
    if (_selectedStation != null && _selectedDate != null) {
      return _buildStationScheduleView();
    }

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Header
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => widget.onNavigate?.call(ScreenType.dashboard),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports & Analytics',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'View schedule summaries and export data',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Period Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1034A6)),
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                      items: _periods.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPeriod = newValue!;
                          _selectedDate = null;
                          _selectedStation = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Row(
              children: [
                // Left: Schedule Summary Table
                Expanded(
                  flex: _selectedDate != null ? 1 : 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Statistics
                        Row(
                          children: [
                            _buildSummaryCard(
                              'Total Shifts',
                              '168',
                              'shifts scheduled',
                              Icons.calendar_today,
                              const Color(0xFF1034A6),
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              'Hours Covered',
                              '2,016',
                              'hours total',
                              Icons.access_time,
                              const Color(0xFF059669),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Schedule Summary Table
                        _buildCard(
                          title: 'Schedule Summary',
                          icon: Icons.table_chart,
                          action: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list, size: 18),
                            label: const Text('Filter'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF1034A6),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildTableHeader(),
                              const SizedBox(height: 8),
                              ..._buildTableRows(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right: Station Selection (shown when date selected)
                if (_selectedDate != null && _selectedStation == null)
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 24, top: 24, bottom: 24),
                      child: _buildStationSelectionView(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Station Schedule View (full screen when station selected)
  Widget _buildStationScheduleView() {
    // Dummy schedule data for the station
    final stationShifts = [
      {'start': '07:00', 'end': '19:00', 'name': 'Smith, John D.', 'type': 'Regular', 'signature': ''},
      {'start': '19:00', 'end': '07:00', 'name': 'Johnson, Sarah M.', 'type': 'Reliever', 'signature': ''},
      {'start': '07:00', 'end': '19:00', 'name': 'Chen, Mike L.', 'type': 'Regular', 'signature': ''},
      {'start': '19:00', 'end': '07:00', 'name': 'Davis, Emily R.', 'type': 'Regular', 'signature': ''},
    ];

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Header
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedStation = null; // Go back to station selection
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_selectedStation Schedule',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        _selectedDate!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Export PDF Button (kept as requested)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1034A6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Station Schedule Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Schedule Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1034A6).withOpacity(0.05),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'TIME START',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF1034A6),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'TIME END',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF1034A6),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'EMPLOYEE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF1034A6),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'TYPE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF1034A6),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'SIGNATURE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF1034A6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Schedule Rows
                      ...stationShifts.map((shift) {
                        final isRegular = shift['type'] == 'Regular';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  shift['start']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  shift['end']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: const Color(0xFF1034A6).withOpacity(0.1),
                                      child: Text(
                                        shift['name']!.substring(0, 1),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF1034A6),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        shift['name']!,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isRegular
                                        ? const Color(0xFFEDE9FE)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isRegular
                                          ? const Color(0xFF8B5CF6)
                                          : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                  child: Text(
                                    shift['type']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isRegular
                                          ? const Color(0xFF7C3AED)
                                          : const Color(0xFFD97706),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey[400]!),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      // Footer with summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ${stationShifts.length} shifts',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                _buildShiftCount('Regular', stationShifts.where((s) => s['type'] == 'Regular').length, const Color(0xFF7C3AED)),
                                const SizedBox(width: 16),
                                _buildShiftCount('Reliever', stationShifts.where((s) => s['type'] == 'Reliever').length, const Color(0xFFD97706)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCount(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$count $label',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Station Selection View (when date clicked, before station selected)
  Widget _buildStationSelectionView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1034A6).withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Station',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedDate!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      _selectedDayData = null;
                    });
                  },
                ),
              ],
            ),
          ),

          // Station List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final station = _stations[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedStation = station;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1034A6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF1034A6),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '4 shifts scheduled',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ... (keep all your existing methods: _buildSummaryCard, _buildCard, _buildTableHeader, _buildTableRows)

  Widget _buildSummaryCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1034A6), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              if (action != null) action,
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 2, child: Text('DAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 2, child: Text('SHIFTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 2, child: Text('FILLED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
        ],
      ),
    );
  }

  List<Widget> _buildTableRows() {
    final data = [
      {'date': '04/10/2026', 'day': 'Mon', 'shifts': '24', 'filled': '24', 'status': 'Complete'},
      {'date': '04/11/2026', 'day': 'Tue', 'shifts': '24', 'filled': '22', 'status': 'Partial'},
      {'date': '04/12/2026', 'day': 'Wed', 'shifts': '24', 'filled': '24', 'status': 'Complete'},
      {'date': '04/13/2026', 'day': 'Thu', 'shifts': '24', 'filled': '20', 'status': 'Partial'},
      {'date': '04/14/2026', 'day': 'Fri', 'shifts': '24', 'filled': '24', 'status': 'Complete'},
      {'date': '04/15/2026', 'day': 'Sat', 'shifts': '24', 'filled': '16', 'status': 'Weekend'},
      {'date': '04/16/2026', 'day': 'Sun', 'shifts': '24', 'filled': '16', 'status': 'Weekend'},
    ];

    return data.map((row) {
      final isComplete = row['status'] == 'Complete';
      final isWeekend = row['status'] == 'Weekend';
      final isSelected = _selectedDate == row['date'];

      return InkWell(
        onTap: () {
          setState(() {
            _selectedDate = row['date'];
            _selectedDayData = row;
            _selectedStation = null; // Reset station when new date selected
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1034A6).withOpacity(0.05) : null,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
              left: isSelected ? const BorderSide(color: Color(0xFF1034A6), width: 3) : BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(row['date']!, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))),
              Expanded(flex: 2, child: Text(row['day']!, style: TextStyle(fontSize: 13))),
              Expanded(flex: 2, child: Text(row['shifts']!, style: TextStyle(fontSize: 13))),
              Expanded(flex: 2, child: Text(row['filled']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? Colors.green.withOpacity(0.1)
                        : isWeekend
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    row['status']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isComplete
                          ? Colors.green
                          : isWeekend
                          ? Colors.blue
                          : Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}