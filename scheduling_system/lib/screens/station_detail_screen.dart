// screens/station_detail_screen.dart (Updated requirements)
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/station.dart';
import '../models/employee.dart';
import 'main_layout.dart';
import 'employee_detail_screen.dart';

// Internal row model just for the Morning/Afternoon/Night shift tables
// below — kept separate from Employee since it's example data for now.
class _ShiftRow {
  final String id;
  final String name;
  final String position;
  final String time;

  const _ShiftRow({
    required this.id,
    required this.name,
    required this.position,
    required this.time,
  });
}

class StationDetailContent extends StatelessWidget {
  final Station station;
  final Function(ScreenType, {dynamic data}) onNavigate;

  const StationDetailContent({
    Key? key,
    required this.station,
    required this.onNavigate,
  }) : super(key: key);

  // NEW: Hardcoded required employees to 16
  static const int requiredEmployees = 16;

  // Kept for potential reuse elsewhere (e.g. a station list/summary screen)
  // even though the "Required Employees" / "Status" cards were removed
  // from this screen in favor of the Date card below.
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String get _formattedToday {
    final now = DateTime.now();
    return '${_months[now.month - 1]} ${now.day}, ${now.year}';
  }

  // Column widths for the ID | Name | Position | Time shift tables below.
  // ID is fixed/narrow; the rest flex to fill the card's width.
  static const Map<int, TableColumnWidth> _shiftColumnWidths = {
    0: FixedColumnWidth(80), // ID
    1: FlexColumnWidth(3),   // Name
    2: FlexColumnWidth(2),   // Position
    3: FlexColumnWidth(2),   // Time
  };

  // UPDATED: Get sorted employees by surname
  List<Employee> get assignedEmployees {
    final employees = DummyData.employees
        .where((e) => e.station == station.name)
        .toList();

    // Sort by surname alphabetically using formattedName
    employees.sort((a, b) {
      final aSurname = a.formattedName.split(',').first;
      final bSurname = b.formattedName.split(',').first;
      return aSurname.compareTo(bSurname);
    });

    return employees;
  }

  // NEW: Check if complete (16 employees)
  bool get isComplete => assignedEmployees.length >= requiredEmployees;

  // Example duty data for the Morning/Afternoon/Night tables below — 3
  // people per shift, cycled from DummyData.employees just to preview the
  // layout. Swap this out for real per-shift assignments once that data
  // exists on the Station/Schedule models.
  List<_ShiftRow> get _morningRows => _buildShiftRows('0600H - 1400H', 0);
  List<_ShiftRow> get _afternoonRows => _buildShiftRows('1400H - 2200H', 2);
  List<_ShiftRow> get _nightRows => _buildShiftRows('2200H - 0600H', 4);

  List<_ShiftRow> _buildShiftRows(String time, int offset) {
    final pool = DummyData.employees;
    return List.generate(3, (i) {
      final employee = pool[(offset + i) % pool.length];
      return _ShiftRow(
        id: employee.id.replaceFirst('EMP', ''),
        name: employee.name,
        position: i == 0 ? 'Head Guard' : 'Shift Guard',
        time: time,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Custom AppBar area - EXACTLY AS YOU DESIGNED
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                  onPressed: () => onNavigate(ScreenType.stationManagement),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        station.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Station'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1034A6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body - EXACTLY AS YOU DESIGNED
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Stats — Total Assigned + Date, evenly spaced
                  Row(
                    children: [
                      _buildStatCard(
                          'Date',
                          _formattedToday,
                          Icons.calendar_today
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                          'Total Assigned',
                          assignedEmployees.length.toString(),
                          Icons.people
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Section Title - EXACTLY AS YOU DESIGNED
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
                        'Assigned Employees',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Employee List — now grouped into Morning/Afternoon/Night
                  // shift tables instead of one flat list.
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShiftSection('Morning Shift', _morningRows),
                          _buildShiftDivider(),
                          _buildShiftSection('Afternoon Shift', _afternoonRows),
                          _buildShiftDivider(),
                          _buildShiftSection('Night Shift', _nightRows),
                        ],
                      ),
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

  Widget _buildStatCard(String label, String value, IconData icon, {bool isPositive = false}) {
    // UPDATED: Color logic for Complete vs Not Complete
    Color iconColor = const Color(0xFF1034A6);
    if (label == 'Status') {
      iconColor = isPositive ? Colors.green : Colors.orange;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // One shift block: subtitle, then a card-style table of example
  // ID / Name / Position / Time rows.
  Widget _buildShiftSection(String title, List<_ShiftRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Table(
            columnWidths: _shiftColumnWidths,
            border: TableBorder.all(
              color: Colors.grey[200]!,
              width: 1,
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              _buildShiftHeaderRow(),
              ...rows.map(_buildShiftDataRow),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildShiftHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6).withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      children: const [
        _ShiftHeaderCell('ID'),
        _ShiftHeaderCell('NAME'),
        _ShiftHeaderCell('POSITION'),
        _ShiftHeaderCell('TIME'),
      ],
    );
  }

  TableRow _buildShiftDataRow(_ShiftRow row) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            row.id,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            row.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(row.position, style: const TextStyle(fontSize: 13)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(row.time, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  // Thin grey separator with breathing room between shift sections —
  // same treatment used on the schedule detail screen.
  Widget _buildShiftDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 1,
      color: Colors.grey[300],
    );
  }
}

class _ShiftHeaderCell extends StatelessWidget {
  final String text;
  const _ShiftHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Color(0xFF1034A6),
        ),
      ),
    );
  }
}