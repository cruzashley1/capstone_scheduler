// screens/schedule_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/schedule.dart';
import 'main_layout.dart';

// Internal row model just for the duty-roster table below.
// Kept separate from ScheduleEntry so editing Name/Reliever here doesn't
// require touching the shared Schedule model used by other screens.
class _DutyRow {
  final int no;
  final String employeeId;
  String employeeName;
  final String post;
  final String time;
  final double hours;
  final String dateLabel;
  String? reliever;

  _DutyRow({
    required this.no,
    required this.employeeId,
    required this.employeeName,
    required this.post,
    required this.time,
    required this.hours,
    required this.dateLabel,
    this.reliever,
  });
}

class ScheduleDetailScreen extends StatefulWidget {
  final Schedule schedule;
  final VoidCallback onBack;
  final Function(ScreenType, {dynamic data})? onNavigate;

  const ScheduleDetailScreen({
    Key? key,
    required this.schedule,
    required this.onBack,
    this.onNavigate,
  }) : super(key: key);

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  // Local copy so the Publish button can flip the badge for demo purposes
  // without needing to wire up real persistence yet.
  late ScheduleStatus _status;
  late List<_DutyRow> _morningRows;
  late List<_DutyRow> _afternoonRows;
  late List<_DutyRow> _nightRows;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Mock reliever names cycled in for display purposes only.
  static const List<String> _relieverPool = [
    'Carlo Cruz', 'Mark Santos', 'Ana Reyes', 'Jojo Bautista'
  ];

  // Mock employee names for the Morning/Afternoon/Night dummy rows below —
  // purely for previewing the shift-grouped layout, not wired to real
  // assignments yet. Swap in real per-shift data when it's available.
  static const List<String> _dummyNamePool = [
    'Juan Dela Cruz', 'Maria Santos', 'Pedro Garcia', 'Liza Ramirez',
    'Carlo Cruz', 'Ana Reyes', 'Mark Santos', 'Jojo Bautista',
  ];

  // Fixed pixel widths per column — this is what makes the table's total
  // width deterministic, so the card hugs it exactly (no blank space) and
  // it scrolls cleanly once the screen is narrower than this total.
  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(50),  // No.
    1: FixedColumnWidth(70),  // ID
    2: FixedColumnWidth(170), // Name
    3: FixedColumnWidth(130), // Post
    4: FixedColumnWidth(150), // Time
    5: FixedColumnWidth(110), // No. of Hours
    6: FixedColumnWidth(90),  // Date
    7: FixedColumnWidth(150), // Reliever
  };

  @override
  void initState() {
    super.initState();
    _status = widget.schedule.status;
    _morningRows = _buildDummyShiftRows(
      idPrefix: 20,
      time: '0600H - 1400H',
      hours: 8.0,
    );
    _afternoonRows = _buildDummyShiftRows(
      idPrefix: 30,
      time: '1400H - 2200H',
      hours: 8.0,
    );
    _nightRows = _buildDummyShiftRows(
      idPrefix: 40,
      time: '2200H - 0600H',
      hours: 8.0,
    );
  }

  // Dummy duty-roster rows for one shift block (8 people), used purely to
  // preview the Morning/Afternoon/Night layout. Swap this out for real
  // per-shift data once the Schedule model tracks more than Day/Night.
  List<_DutyRow> _buildDummyShiftRows({
    required int idPrefix,
    required String time,
    required double hours,
  }) {
    final rows = <_DutyRow>[];
    for (int i = 1; i <= 8; i++) {
      // Every third row has no reliever assigned, just to show both states.
      String? reliever;
      if (i % 3 != 0) {
        reliever = _relieverPool[(i - 1) % _relieverPool.length];
      }

      rows.add(_DutyRow(
        no: i,
        employeeId: '$idPrefix${i.toString().padLeft(2, '0')}',
        employeeName: _dummyNamePool[(i - 1) % _dummyNamePool.length],
        post: i == 1 ? 'Head Guard' : 'Shift Guard',
        time: time,
        hours: hours,
        dateLabel: 'Jul $i',
        reliever: reliever,
      ));
    }
    return rows;
  }

  String _formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  void _editRow(_DutyRow row) {
    final nameController = TextEditingController(text: row.employeeName);
    final relieverController = TextEditingController(text: row.reliever ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Assignment'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Row ${row.no} \u00b7 ${row.post} \u00b7 ${row.time}',
                  style: TextStyle(color: Colors.grey[900], fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Employee Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: relieverController,
                  decoration: const InputDecoration(
                    labelText: 'Reliever',
                    hintText: 'Leave blank if none',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                final newReliever = relieverController.text.trim();
                setState(() {
                  if (newName.isNotEmpty) row.employeeName = newName;
                  row.reliever = newReliever.isEmpty ? null : newReliever;
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assignment updated')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1034A6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.schedule;
    final isPublished = _status == ScheduleStatus.published;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Header — unchanged
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
                  onPressed: widget.onBack,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.stationName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '${_formatDate(schedule.startDate)} \u2013 ${_formatDate(schedule.endDate)} \u00b7 ${schedule.totalDays}-day schedule',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(isPublished),
                const SizedBox(width: 12),
                if (!isPublished)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _status = ScheduleStatus.published);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Schedule published')),
                      );
                    },
                    icon: const Icon(Icons.publish, size: 18),
                    label: const Text('Publish Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1034A6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _status = ScheduleStatus.unpublished);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Schedule unpublished')),
                      );
                    },
                    icon: const Icon(Icons.unpublished_outlined, size: 18),
                    label: const Text('Unpublish'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1034A6),
                      side: const BorderSide(color: Color(0xFF1034A6)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
              ],
            ),
          ),

          // Content — redesigned duty-roster table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        'July 1 - July 15 2026',
                        style: TextStyle(
                          fontSize: 20,
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
                          '${_morningRows.length + _afternoonRows.length + _nightRows.length}',
                          style: const TextStyle(
                            color: Color(0xFF1034A6),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '...',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // The card hugs the table's fixed width exactly (no
                  // leftover blank space), and scrolls horizontally once
                  // the viewport is narrower than that width.
                  _buildShiftSection('Morning Shift', _morningRows),
                  _buildShiftDivider(),
                  _buildShiftSection('Afternoon Shift', _afternoonRows),
                  _buildShiftDivider(),
                  _buildShiftSection('Night Shift', _nightRows),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
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
        _HeaderCell('NO.'),
        _HeaderCell('ID'),
        _HeaderCell('NAME'),
        _HeaderCell('POST'),
        _HeaderCell('TIME'),
        _HeaderCell('NO. OF HOURS'),
        _HeaderCell('DATE'),
        _HeaderCell('RELIEVER'),
      ],
    );
  }

  TableRow _buildDataRow(_DutyRow row) {
    return TableRow(
      children: [
        _dataCell(row, Text('${row.no}', style: const TextStyle(fontSize: 13))),
        _dataCell(
          row,
          Text(row.employeeId, style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
        ),
        _dataCell(
          row,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  row.employeeName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.edit, size: 13, color: Colors.grey[400]),
            ],
          ),
        ),
        _dataCell(row, Text(row.post, style: const TextStyle(fontSize: 13))),
        _dataCell(row, Text(row.time, style: const TextStyle(fontSize: 13))),
        _dataCell(row, Text(row.hours.toStringAsFixed(2), style: const TextStyle(fontSize: 13))),
        _dataCell(row, Text(row.dateLabel, style: const TextStyle(fontSize: 13))),
        _dataCell(
          row,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  row.reliever ?? '\u2014',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: row.reliever == null ? Colors.grey[400] : const Color(0xFF1E293B),
                    fontWeight: row.reliever == null ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.edit, size: 13, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }

  // Every cell in the row shares the same tap target, so tapping anywhere
  // on the row opens the edit dialog — same behavior as before, just
  // rebuilt on top of Table instead of DataTable.
  Widget _dataCell(_DutyRow row, Widget child) {
    return InkWell(
      onTap: () => _editRow(row),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: child,
      ),
    );
  }

  // One shift block: subtitle + headcount pill, then the same table
  // styling as before, with a totals row appended at the bottom.
  Widget _buildShiftSection(String title, List<_DutyRow> rows) {
    final totalHours = rows.fold<double>(0, (sum, r) => sum + r.hours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
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
                '${rows.length}',
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
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
                ...rows.map(_buildDataRow),
                _buildTotalRow(rows.length, totalHours),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Thin grey separator with breathing room between shift sections.
  Widget _buildShiftDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 1,
      color: Colors.grey[300],
    );
  }

  // Summary row appended to each shift's Table — it shares the exact same
  // columnWidths as the data rows above it, so "Total: N" lands directly
  // under NAME and the hours figure lands directly under NO. OF HOURS
  // with no separate alignment math needed.
  TableRow _buildTotalRow(int peopleCount, double totalHours) {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6).withOpacity(0.04),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      children: [
        const SizedBox(),
        const SizedBox(),
        _totalCell('Total: $peopleCount'),
        const SizedBox(),
        const SizedBox(),
        _totalCell(totalHours.toStringAsFixed(2)),
        const SizedBox(),
        const SizedBox(),
      ],
    );
  }

  Widget _totalCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1034A6),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isPublished) {
    final color = isPublished ? const Color(0xFF059669) : const Color(0xFFD97706);
    final label = isPublished ? 'Published' : 'Unpublished';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
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