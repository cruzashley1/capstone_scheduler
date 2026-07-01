// screens/available_management_screen.dart
//
// Shown when the "Relievers Available" box is tapped on the dashboard.
// Lists, per station, every assigned employee's status (Regular vs
// Reliever) so it's easy to see who's on standby today.
import 'package:flutter/material.dart';
import 'main_layout.dart';

// One person's row in a station's availability table.
class _AvailabilityRow {
  final String id;
  final String name;
  final String status; // 'Regular' or 'Reliever'

  const _AvailabilityRow({
    required this.id,
    required this.name,
    required this.status,
  });
}

// One station's block: name + the people assigned to it.
class _StationAvailability {
  final String stationName;
  final List<_AvailabilityRow> rows;

  const _StationAvailability({
    required this.stationName,
    required this.rows,
  });
}

class AvailableManagementContent extends StatelessWidget {
  final Function(ScreenType, {dynamic data}) onNavigate;

  const AvailableManagementContent({
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

  // Column widths for the ID | Name | Status table below.
  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(80), // ID
    1: FlexColumnWidth(3),   // Name
    2: FlexColumnWidth(2),   // Status
  };

  // DUMMY DATA: at least 3 stations, at least 3 people per station, mixing
  // Regular and Reliever statuses. Swap this out for real data once
  // station/employee availability is tracked on the models.
  static const List<_StationAvailability> _stations = [
    _StationAvailability(
      stationName: '5th Avenue',
      rows: [
        _AvailabilityRow(id: '001', name: 'John Smith', status: 'Reliever'),
        _AvailabilityRow(id: '002', name: 'Carol Smith', status: 'Regular'),
        _AvailabilityRow(id: '003', name: 'Mark Santos', status: 'Reliever'),
      ],
    ),
    _StationAvailability(
      stationName: 'Abad Santos',
      rows: [
        _AvailabilityRow(id: '004', name: 'Ana Reyes', status: 'Regular'),
        _AvailabilityRow(id: '005', name: 'Jojo Bautista', status: 'Reliever'),
        _AvailabilityRow(id: '006', name: 'Liza Ramirez', status: 'Regular'),
      ],
    ),
    _StationAvailability(
      stationName: 'Central Terminal',
      rows: [
        _AvailabilityRow(id: '007', name: 'Pedro Garcia', status: 'Reliever'),
        _AvailabilityRow(id: '008', name: 'Maria Santos', status: 'Regular'),
        _AvailabilityRow(id: '009', name: 'Carlo Cruz', status: 'Reliever'),
      ],
    ),
  ];

  int get _totalRelievers => _stations
      .expand((s) => s.rows)
      .where((r) => r.status == 'Reliever')
      .length;

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
                        'Reliever Availability',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Regular and reliever staff, per station',
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
                  // Stat cards — Date + Total Relievers Available
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
                        'Relievers Available',
                        _totalRelievers.toString(),
                        Icons.swap_horiz_rounded,
                        const Color(0xFF059669),
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
                        'Availability by Station',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Station sections — Date + Station name + table per the
                  // requested layout, stacked for every station.
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

  // One station block: Station name title (+ headcount badge), then the
  // ID | Name | Status table for everyone assigned there.
  Widget _buildStationSection(_StationAvailability station) {
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
                color: const Color(0xFF1034A6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${station.rows.length}',
                style: const TextStyle(
                  color: Color(0xFF1034A6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
            columnWidths: _columnWidths,
            border: TableBorder.all(
              color: Colors.grey[200]!,
              width: 1,
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              _buildHeaderRow(),
              ...station.rows.map(_buildDataRow),
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
      ],
    );
  }

  TableRow _buildDataRow(_AvailabilityRow row) {
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
      ],
    );
  }

  // Reliever -> green (on standby/available), Regular -> brand blue.
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

  // Thin grey separator with breathing room between station sections —
  // same treatment used on the other detail screens.
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