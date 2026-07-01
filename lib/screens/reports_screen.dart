// screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'main_layout.dart';

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────
const _kAccent      = Color(0xFF1D4ED8);
const _kAccentLight = Color(0xFFEFF6FF);
const _kBorder      = Color(0xFFE2E8F0);
const _kBorderDark  = Color(0xFFCBD5E1);
const _kText        = Color(0xFF0F172A);
const _kTextMuted   = Color(0xFF64748B);
const _kSurface     = Color(0xFFF8FAFC);
const _kHeaderBlue  = Color(0xFFDBEAFE);
const _kHeaderBlueDk= Color(0xFFBFDBFE);
const _kRelText     = Color(0xFF854D0E);
const _kRelBg       = Color(0xFFFEF9C3);
const _kRelBorder   = Color(0xFFCA8A04);

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────
class GuardEntry {
  final int    no;
  final String id;
  final String name;
  final String post;
  final String time;
  final double hours;
  final String date;        // reliever date
  final String reliever;
  final String absenceReason;

  const GuardEntry({
    required this.no,
    required this.id,
    required this.name,
    required this.post,
    required this.time,
    required this.hours,
    this.date          = '',
    this.reliever      = '',
    this.absenceReason = '',
  });

  bool get hasReliever => reliever.isNotEmpty;
}

class StationInfo {
  final int    no;
  final String name;
  const StationInfo({required this.no, required this.name});
  String get label => '$no. $name';
}

class BiPeriod {
  final int    year, month, half;
  final String label;
  const BiPeriod(this.year, this.month, this.half, this.label);
}

// ─────────────────────────────────────────────
// STATIONS
// ─────────────────────────────────────────────
const _kStations = [
  StationInfo(no:  1, name: 'Fernando Poe Jr. Station'),
  StationInfo(no:  2, name: 'Balintawak Station'),
  StationInfo(no:  3, name: 'Monumento Station'),
  StationInfo(no:  4, name: '5th Avenue Station'),
  StationInfo(no:  5, name: 'R. Papa Station'),
  StationInfo(no:  6, name: 'Abad Santos Station'),
  StationInfo(no:  7, name: 'Blumentritt Station'),
  StationInfo(no:  8, name: 'Tayuman Station'),
  StationInfo(no:  9, name: 'Bambang Station'),
  StationInfo(no: 10, name: 'Doroteo Jose Station'),
  StationInfo(no: 11, name: 'Carriedo Station'),
  StationInfo(no: 12, name: 'Central Terminal Station'),
  StationInfo(no: 13, name: 'United Nations Station'),
  StationInfo(no: 14, name: 'Pedro Gil Station'),
  StationInfo(no: 15, name: 'Quirino Station'),
  StationInfo(no: 16, name: 'Vito Cruz Station'),
  StationInfo(no: 17, name: 'Gil Puyat Station'),
  StationInfo(no: 18, name: 'Libertad Station'),
  StationInfo(no: 19, name: 'EDSA Station'),
  StationInfo(no: 20, name: 'Baclaran Station'),
  StationInfo(no: 21, name: 'Redemptorist-Aseana Station'),
  StationInfo(no: 22, name: 'MIA Road Station'),
  StationInfo(no: 23, name: 'PITX (Asia World) Station'),
  StationInfo(no: 24, name: 'Ninoy Aquino Avenue Station'),
  StationInfo(no: 25, name: 'Dr. Santos Station'),
];

// ─────────────────────────────────────────────
// PERIOD GENERATOR
// ─────────────────────────────────────────────
const _kMonths = [
  '', 'January','February','March','April','May','June',
  'July','August','September','October','November','December',
];

const _kMonthsShort = [
  '', 'Jan','Feb','Mar','Apr','May','Jun',
  'Jul','Aug','Sep','Oct','Nov','Dec',
];

List<BiPeriod> _generatePeriods() {
  final now = DateTime.now();
  final out = <BiPeriod>[];
  for (int offset = -6; offset <= 3; offset++) {
    int m = now.month + offset, y = now.year;
    while (m < 1)  { m += 12; y--; }
    while (m > 12) { m -= 12; y++; }
    final last = DateUtils.getDaysInMonth(y, m);
    out.add(BiPeriod(y, m, 0, '${_kMonths[m]} 1–15, $y'));
    out.add(BiPeriod(y, m, 1, '${_kMonths[m]} 16–$last, $y'));
  }
  return out;
}

// ─────────────────────────────────────────────
// DUMMY DATA BUILDER
// ─────────────────────────────────────────────
List<GuardEntry> _buildMorningShift(BiPeriod p) {
  final month = _kMonthsShort[p.month];
  final startDay = p.half == 0 ? 1 : 16;
  final names = [
    ('Juan Dela Cruz',   '2001', 'Head Guard'),
    ('Maria Santos',     '2002', 'Shift Guard'),
    ('Pedro Garcia',     '2003', 'Shift Guard'),
    ('Liza Ramirez',     '2004', 'Shift Guard'),
    ('Carlo Cruz',       '2005', 'Shift Guard'),
    ('Ana Reyes',        '2006', 'Shift Guard'),
    ('Mark Santos',      '2007', 'Shift Guard'),
  ];
  final relievers = ['Carlo Cruz','Mark Santos','–','Jojo Bautista','Carlo Cruz','–','Ana Reyes'];
  final relDates  = ['$month ${startDay}','$month ${startDay+1}','','$month ${startDay+3}','$month ${startDay+4}','','$month ${startDay+6}'];

  return List.generate(7, (i) => GuardEntry(
    no: i + 1,
    id: names[i].$2,
    name: names[i].$1,
    post: names[i].$3,
    time: '0600H – 1400H',
    hours: 8.00,
    date: relDates[i],
    reliever: relievers[i] == '–' ? '' : relievers[i],
    absenceReason: relievers[i] == '–' ? '' : 'Day Off',
  ));
}

List<GuardEntry> _buildAfternoonShift(BiPeriod p) {
  final month = _kMonthsShort[p.month];
  final startDay = p.half == 0 ? 1 : 16;
  final names = [
    ('Roberto Luna',     '2101', 'Head Guard'),
    ('Carla Mendoza',    '2102', 'Shift Guard'),
    ('Jose Reyes',       '2103', 'Shift Guard'),
    ('Nina Torres',      '2104', 'Shift Guard'),
    ('Ben Villanueva',   '2105', 'Shift Guard'),
    ('Gloria Santos',    '2106', 'Shift Guard'),
    ('Ricky Flores',     '2107', 'Shift Guard'),
  ];
  final relievers = ['–','Ricky Flores','–','Carlos Bautista','–','Nina Torres','–'];
  final relDates  = ['','$month ${startDay+2}','','$month ${startDay+5}','','$month ${startDay+7}',''];

  return List.generate(7, (i) => GuardEntry(
    no: i + 1,
    id: names[i].$2,
    name: names[i].$1,
    post: names[i].$3,
    time: '1400H – 2200H',
    hours: 8.00,
    date: relDates[i],
    reliever: relievers[i] == '–' ? '' : relievers[i],
    absenceReason: relievers[i] == '–' ? '' : 'Sick Leave',
  ));
}

List<GuardEntry> _buildNightShift(BiPeriod p) {
  final month = _kMonthsShort[p.month];
  final startDay = p.half == 0 ? 1 : 16;
  final names = [
    ('Eduardo Bautista', '2201', 'Shift Guard'),
    ('Lourdes Garcia',   '2202', 'Shift Guard'),
  ];
  final relievers = ['Jeremy Moico','–'];
  final relDates  = ['$month ${startDay+1}',''];

  return List.generate(2, (i) => GuardEntry(
    no: i + 1,
    id: names[i].$2,
    name: names[i].$1,
    post: names[i].$3,
    time: '2200H – 0600H',
    hours: 8.00,
    date: relDates[i],
    reliever: relievers[i] == '–' ? '' : relievers[i],
    absenceReason: relievers[i] == '–' ? '' : 'Vacation Leave',
  ));
}

// ─────────────────────────────────────────────
// MAIN WIDGET
// ─────────────────────────────────────────────
class ReportsContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data})? onNavigate;
  const ReportsContent({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<ReportsContent> {
  StationInfo _station = _kStations.first;
  late final List<BiPeriod> _periods = _generatePeriods();
  late BiPeriod _period = _periods.firstWhere(
        (p) => p.year  == DateTime.now().year &&
        p.month == DateTime.now().month &&
        p.half  == (DateTime.now().day <= 15 ? 0 : 1),
    orElse: () => _periods[6],
  );

  late List<GuardEntry> _morning   = _buildMorningShift(_period);
  late List<GuardEntry> _afternoon = _buildAfternoonShift(_period);
  late List<GuardEntry> _night     = _buildNightShift(_period);

  String get _printedDate {
    final n = DateTime.now();
    return '${_kMonths[n.month]} ${n.day}, ${n.year}';
  }

  void _refreshData() {
    setState(() {
      _morning   = _buildMorningShift(_period);
      _afternoon = _buildAfternoonShift(_period);
      _night     = _buildNightShift(_period);
    });
  }

  // ── Export confirmation flow ──────────────────
  void _handleExportSingle() {
    _showExportConfirmation(exportAll: false);
  }

  void _handleExportAll() {
    _showExportConfirmation(exportAll: true);
  }

  void _showExportConfirmation({required bool exportAll}) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _kAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: _kAccent, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Export Schedule Report',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w800, color: _kText)),
            ),
          ],
        ),
        content: Text(
          exportAll
              ? 'Export the bi-weekly schedule report for all 25 stations as one combined PDF for ${_period.label}?'
              : 'Export the bi-weekly schedule report for ${_station.label} for ${_period.label}?',
          style: const TextStyle(fontSize: 13.5,
              color: _kTextMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: _kTextMuted,
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _confirmExport(exportAll: exportAll);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _confirmExport({required bool exportAll}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                exportAll
                    ? 'PDF generated for all 25 stations — ${_period.label}'
                    : 'PDF generated — ${_station.name}  ·  ${_period.label}',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── KSA header card ──
                  _buildKsaHeaderCard(),
                  const SizedBox(height: 20),

                  // ── Period + station label ──
                  _buildPeriodStationLabel(),
                  const SizedBox(height: 20),

                  // ── Morning Shift ──
                  _buildShiftSection(
                    label:   'Morning Shift',
                    time:    '0600H – 1400H',
                    color:   const Color(0xFF1D4ED8),
                    icon:    Icons.wb_sunny_rounded,
                    entries: _morning,
                  ),
                  const SizedBox(height: 28),

                  // ── Afternoon Shift ──
                  _buildShiftSection(
                    label:   'Afternoon Shift',
                    time:    '1400H – 2200H',
                    color:   const Color(0xFF0369A1),
                    icon:    Icons.wb_cloudy_rounded,
                    entries: _afternoon,
                  ),
                  const SizedBox(height: 28),

                  // ── Night Shift ──
                  _buildShiftSection(
                    label:   'Night Shift',
                    time:    '2200H – 0600H',
                    color:   const Color(0xFF065F46),
                    icon:    Icons.nightlight_rounded,
                    entries: _night,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar (unchanged from Image 2) ─────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          const Text('Schedule Report',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w800, color: _kText)),
          const SizedBox(width: 28),
          const Text('Station',
              style: TextStyle(fontSize: 12,
                  color: _kTextMuted, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          _buildDropdown<StationInfo>(
            value: _station, width: 240,
            items: _kStations.map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.label, overflow: TextOverflow.ellipsis),
            )).toList(),
            onChanged: (s) => setState(() {
              _station = s!;
              _refreshData();
            }),
          ),
          const SizedBox(width: 16),
          const Text('Period',
              style: TextStyle(fontSize: 12,
                  color: _kTextMuted, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          _buildDropdown<BiPeriod>(
            value: _period, width: 210,
            items: _periods.map((p) => DropdownMenuItem(
              value: p,
              child: Text(p.label, overflow: TextOverflow.ellipsis),
            )).toList(),
            onChanged: (p) => setState(() {
              _period = p!;
              _refreshData();
            }),
          ),
          const Spacer(),
          _buildExportSplitButton(),
        ],
      ),
    );
  }

  // ── KSA header card (Image 2) ─────────────────
  Widget _buildKsaHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000),
              blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _kAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('KSA',
                  style: TextStyle(color: Colors.white,
                      fontSize: 14, fontWeight: FontWeight.w900,
                      letterSpacing: 0.5)),
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('KAIZEN SECURITY AGENCY CORP.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900,
                      color: _kText, letterSpacing: 0.3)),
              SizedBox(height: 2),
              Text('Bi-Weekly Schedule Report',
                  style: TextStyle(fontSize: 12, color: _kTextMuted)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Period + station label ────────────────────
  Widget _buildPeriodStationLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4, height: 28,
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _period.label,
              style: const TextStyle(fontSize: 22,
                  fontWeight: FontWeight.w800, color: _kText),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _kAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_morning.length + _afternoon.length + _night.length}',
                style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w800, color: _kAccent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            _station.label,
            style: const TextStyle(fontSize: 13,
                color: _kTextMuted, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // ── Shift section ─────────────────────────────
  Widget _buildShiftSection({
    required String            label,
    required String            time,
    required Color             color,
    required IconData          icon,
    required List<GuardEntry>  entries,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shift label row
        Row(
          children: [
            Text(label,
                style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: color)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${entries.length}',
                  style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700, color: color)),
            ),
            const SizedBox(width: 10),
            Text(time,
                style: const TextStyle(fontSize: 12,
                    color: _kTextMuted, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 10),
        // Table
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            children: [
              _buildTableHeader(color),
              ...entries.asMap().entries.map(
                      (e) => _buildTableRow(e.key, e.value, color)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Table header ──────────────────────────────
  Widget _buildTableHeader(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          _hCell('NO.',         flex: 1, color: color),
          _hCell('ID',          flex: 2, color: color),
          _hCell('NAME',        flex: 5, color: color),
          _hCell('POST',        flex: 3, color: color),
          _hCell('TIME',        flex: 3, color: color),
          _hCell('NO. OF HOURS',flex: 3, color: color),
          _hCell('DATE',        flex: 2, color: color),
          _hCell('RELIEVER',    flex: 4, color: color),
        ],
      ),
    );
  }

  Widget _hCell(String label, {required int flex, required Color color}) {
    return Expanded(
      flex: flex,
      child: Text(label,
          style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color, letterSpacing: 0.3)),
    );
  }

  // ── Table row ─────────────────────────────────
  Widget _buildTableRow(int index, GuardEntry e, Color shiftColor) {
    final isAlt = index % 2 == 1;
    final bg    = isAlt ? _kSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: bg,
        border: const Border(
            bottom: BorderSide(color: _kBorder, width: 0.6)),
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        children: [
          // No.
          Expanded(
            flex: 1,
            child: Text('${e.no}',
                style: const TextStyle(fontSize: 13,
                    color: _kTextMuted, fontWeight: FontWeight.w500)),
          ),
          // ID
          Expanded(
            flex: 2,
            child: Text(e.id,
                style: const TextStyle(fontSize: 13, color: _kTextMuted)),
          ),
          // Name
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(e.name,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w500, color: _kText)),
              ],
            ),
          ),
          // Post
          Expanded(
            flex: 3,
            child: Text(e.post,
                style: const TextStyle(
                    fontSize: 13, color: _kTextMuted)),
          ),
          // Time
          Expanded(
            flex: 3,
            child: Text(e.time,
                style: const TextStyle(
                    fontSize: 13, color: _kTextMuted)),
          ),
          // No. of Hours
          Expanded(
            flex: 3,
            child: Text(e.hours.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 13, color: _kText,
                    fontWeight: FontWeight.w500)),
          ),
          // Date
          Expanded(
            flex: 2,
            child: Text(
              e.date.isEmpty ? '–' : e.date,
              style: TextStyle(
                  fontSize: 13,
                  color: e.hasReliever
                      ? _kRelText : _kTextMuted,
                  fontWeight: e.hasReliever
                      ? FontWeight.w600 : FontWeight.normal),
            ),
          ),
          // Reliever
          Expanded(
            flex: 4,
            child: e.reliever.isEmpty
                ? Row(
              children: [
                Text('–',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[400])),
              ],
            )
                : Row(
              children: [
                Text(e.reliever,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: shiftColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Export split button (PopupMenuButton style) ──
  Widget _buildExportSplitButton() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: _kAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main action — Export current station
          InkWell(
            onTap: _handleExportSingle,
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8)),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.picture_as_pdf_rounded,
                      size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Export PDF',
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 22,
              color: Colors.white.withOpacity(0.3)),
          // Dropdown trigger
          PopupMenuButton<String>(
            tooltip: 'More export options',
            offset: const Offset(0, 44),
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'single') _handleExportSingle();
              if (value == 'all')    _handleExportAll();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'single',
                height: 44,
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 17, color: _kAccent),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Export PDF',
                            style: TextStyle(fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kText)),
                        Text('Current station only',
                            style: TextStyle(fontSize: 10.5,
                                color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'all',
                height: 44,
                child: Row(
                  children: [
                    const Icon(Icons.layers_outlined,
                        size: 17, color: _kAccent),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Export All PDF',
                            style: TextStyle(fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kText)),
                        Text('All 25 stations · combined',
                            style: TextStyle(fontSize: 10.5,
                                color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dropdown helper ───────────────────────────
  Widget _buildDropdown<T>({
    required T value, required double width,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      width: width, height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value, isDense: true, isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: _kTextMuted, size: 18),
          style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w600, color: _kText),
          items: items, onChanged: onChanged,
        ),
      ),
    );
  }
}