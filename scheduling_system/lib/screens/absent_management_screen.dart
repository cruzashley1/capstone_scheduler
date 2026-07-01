// screens/absent_management_screen.dart
//
// Shown when the "Absent Today" box is tapped on the dashboard.
// Lists, per station and per shift (Morning/Afternoon/Night), everyone who
// is absent today.
import 'package:flutter/material.dart';
import 'main_layout.dart';

// One absent person's row.
class _AbsenceRow {
  final String id;
  final String name;
  final String status; // 'Regular' or 'Reliever'
  final String time;

  const _AbsenceRow({
    required this.id,
    required this.name,
    required this.status,
    required this.time,
  });
}

// One shift block within a station (Morning / Afternoon / Night).
class _ShiftAbsence {
  final String shiftLabel;
  final List<_AbsenceRow> rows;

  const _ShiftAbsence({
    required this.shiftLabel,
    required this.rows,
  });
}

// One station's block: name + its Morning/Afternoon/Night absence tables.
class _StationAbsence {
  final String stationName;
  final List<_ShiftAbsence> shifts;

  const _StationAbsence({
    required this.stationName,
    required this.shifts,
  });

  int get totalAbsent => shifts.fold(0, (sum, s) => sum + s.rows.length);
}

class AbsentManagementContent extends StatelessWidget {
  final Function(ScreenType, {dynamic data}) onNavigate;

  const AbsentManagementContent({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String get _formattedToday {
    final now = DateTime.now();
    return '${_months[now.month - 1]} ${now.day}, ${now.year}';
  }

  // Column widths for the ID | Name | Status | Time table below.
  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(80),  // ID
    1: FlexColumnWidth(3),    // Name
    2: FixedColumnWidth(110), // Status
    3: FlexColumnWidth(2),    // Time
  };

  // DUMMY DATA: 3 stations, each with a Morning/Afternoon/Night absence
  // entry, mixing Regular and Reliever statuses. Swap this out for real
  // attendance data once it's tracked on the models.
  static const List<_StationAbsence> _stations = [
    _StationAbsence(
      stationName: '5th Avenue',
      shifts: [
        _ShiftAbsence(shiftLabel: 'Morning Shift', rows: [
          _AbsenceRow(id: '002', name: 'Carol Smith', status: 'Regular', time: '0600H - 1400H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Afternoon Shift', rows: [
          _AbsenceRow(id: '010', name: 'Mark Dela Cruz', status: 'Reliever', time: '1400H - 2200H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Night Shift', rows: [
          _AbsenceRow(id: '015', name: 'Liza Domingo', status: 'Regular', time: '2200H - 0600H'),
        ]),
      ],
    ),
    _StationAbsence(
      stationName: 'Abad Santos',
      shifts: [
        _ShiftAbsence(shiftLabel: 'Morning Shift', rows: [
          _AbsenceRow(id: '021', name: 'Ana Bautista', status: 'Regular', time: '0600H - 1400H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Afternoon Shift', rows: [
          _AbsenceRow(id: '022', name: 'Jojo Reyes', status: 'Reliever', time: '1400H - 2200H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Night Shift', rows: [
          _AbsenceRow(id: '023', name: 'Pedro Santos', status: 'Regular', time: '2200H - 0600H'),
        ]),
      ],
    ),
    _StationAbsence(
      stationName: 'Central Terminal',
      shifts: [
        _ShiftAbsence(shiftLabel: 'Morning Shift', rows: [
          _AbsenceRow(id: '031', name: 'Maria Cruz', status: 'Reliever', time: '0600H - 1400H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Afternoon Shift', rows: [
          _AbsenceRow(id: '032', name: 'Carlo Garcia', status: 'Regular', time: '1400H - 2200H'),
        ]),
        _ShiftAbsence(shiftLabel: 'Night Shift', rows: [
          _AbsenceRow(id: '033', name: 'Mark Ramirez', status: 'Reliever', time: '2200H - 0600H'),
        ]),
      ],
    ),
  ];

  int get _totalAbsent => _stations.fold(0, (sum, s) => sum + s.totalAbsent);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Custom AppBar area — same treatment as Station Detail
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                  onPressed: () => onNavigate(ScreenType.dashboard),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Absent Today',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Absences by station and shift',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat cards — Date + Total Absent
                  Row(
                    children: [
                      _buildStatCard(
                        'Date',
                        _formattedToday,
                        Icons.calendar_today,
                        const Color(0xFF1034A6),
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Total Absent',
                        _totalAbsent.toString(),
                        Icons.warning_rounded,
                        const Color(0xFFDC2626),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Section title
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
                        'Absences by Station',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Station sections — each with Station name, then a
                  // Shift Type subsection + table per the requested layout.
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildStationSections(),
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

  List<Widget> _buildStationSections() {
    final widgets = <Widget>[];
    for (int i = 0; i < _stations.length; i++) {
      widgets.add(_buildStationSection(_stations[i]));
      if (i != _stations.length - 1) widgets.add(_buildDivider());
    }
    return widgets;
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color iconColor) {
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

  // One station block: Station name title (+ absent count badge), then a
  // Morning/Afternoon/Night shift subsection for each, each with its own
  // ID | Name | Status | Time table.
  Widget _buildStationSection(_StationAbsence station) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              station.stationName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${station.totalAbsent} absent',
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final shift in station.shifts) ...[
          _buildShiftSection(shift),
          if (shift != station.shifts.last) const SizedBox(height: 20),
        ],
      ],
    );
  }

  // One Shift Type subsection: small label, then its table.
  Widget _buildShiftSection(_ShiftAbsence shift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shift.shiftLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
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
            columnWidths: _columnWidths,
            border: TableBorder.all(
              color: Colors.grey[200]!,
              width: 1,
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              _buildHeaderRow(),
              ...shift.rows.map(_buildDataRow),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6).withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      children: const [
        _HeaderCell('ID'),
        _HeaderCell('NAME'),
        _HeaderCell('STATUS'),
        _HeaderCell('TIME'),
      ],
    );
  }

  TableRow _buildDataRow(_AbsenceRow row) {
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
          child: _buildStatusBadge(row.status),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(row.time, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  // Reliever -> green, Regular -> brand blue. Same convention as the
  // Reliever Availability screen.
  Widget _buildStatusBadge(String status) {
    final bool isReliever = status == 'Reliever';
    final Color color = isReliever ? const Color(0xFF059669) : const Color(0xFF1034A6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  // Thin grey separator with breathing room between station sections.
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 1,
      color: Colors.grey[300],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

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