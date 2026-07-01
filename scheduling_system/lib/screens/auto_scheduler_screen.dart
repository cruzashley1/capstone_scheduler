// screens/auto_scheduler_content.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'main_layout.dart';

class AutoSchedulerContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data})? onNavigate; // Make nullable with ?

  const AutoSchedulerContent({
    Key? key,
    this.onNavigate, // Remove required
  }) : super(key: key);

  @override
  State<AutoSchedulerContent> createState() => _AutoSchedulerContentState();
}

class _ShiftItem {
  String label;
  TimeOfDay start;
  TimeOfDay end;

  _ShiftItem({required this.label, required this.start, required this.end});
}

class _AutoSchedulerContentState extends State<AutoSchedulerContent> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isGenerating = false;
  bool _showPreview = false;

  // Group selector (top stat row)
  String _selectedGroup = 'Group 1';
  bool _isGroupHovered = false;
  static const List<String> _groupOptions = ['Group 1', 'Group 2', 'Group 3'];

  // Shift Configuration
  late List<_ShiftItem> _shifts;

  // Scheduling rules
  bool _rotationSchedule = true;

  // Dummy generated preview data (station-based, replaces table)
  static const List<Map<String, String>> _generatedStations = [
    {'station': 'Monumento', 'shift': 'Morning', 'assigned': '12 Guards'},
    {'station': '5th Ave', 'shift': 'Afternoon', 'assigned': '9 Guards'},
    {'station': '10th Ave', 'shift': 'Night', 'assigned': '7 Guards'},
  ];

  @override
  void initState() {
    super.initState();
    _shifts = [
      _ShiftItem(
        label: 'Morning',
        start: const TimeOfDay(hour: 6, minute: 0),
        end: const TimeOfDay(hour: 14, minute: 0),
      ),
      _ShiftItem(
        label: 'Afternoon',
        start: const TimeOfDay(hour: 14, minute: 0),
        end: const TimeOfDay(hour: 23, minute: 30),
      ),
      _ShiftItem(
        label: 'Night',
        start: const TimeOfDay(hour: 23, minute: 0),
        end: const TimeOfDay(hour: 6, minute: 0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                        'Auto Scheduler',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Generate optimal schedules automatically',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Group selector + Employee count + Station count
                  Row(
                    children: [
                      _buildGroupCard(),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Total Employees',
                        '${DummyData.employees.length}',
                        Icons.people,
                        const Color(0xFF059669),
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Total Stations',
                        '${DummyData.stations.length}',
                        Icons.location_on,
                        const Color(0xFFD97706),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Main Configuration Panel
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Date Range & Rules
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Date Range Card
                            _buildCard(
                              title: 'Schedule Period',
                              icon: Icons.date_range,
                              child: Column(
                                children: [
                                  _buildDateField(
                                    label: 'Start Date',
                                    date: _startDate,
                                    onTap: () => _selectDate(true),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDateField(
                                    label: 'End Date',
                                    date: _endDate,
                                    onTap: () => _selectDate(false),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Shift Configuration Card
                            _buildCard(
                              title: 'Shift Configuration',
                              icon: Icons.schedule,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._shifts
                                      .asMap()
                                      .entries
                                      .map((e) => _buildShiftRow(e.value, e.key)),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showShiftDialog(),
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Add Shift'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF1034A6),
                                        side: const BorderSide(color: Color(0xFF1034A6)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Scheduling Preference Card
                            _buildCard(
                              title: 'Scheduling Preference',
                              icon: Icons.sync_alt,
                              child: _buildToggleRow(
                                'Rotation Schedule',
                                _rotationSchedule,
                                    (val) => setState(() => _rotationSchedule = val),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Right: Actions & Preview
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            // Generate Button Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1034A6),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1034A6).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.auto_fix_high,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Ready to Generate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'AI will optimize assignments based on your rules',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _isGenerating ? null : _generateSchedule,
                                      icon: _isGenerating
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                          : const Icon(Icons.play_arrow),
                                      label: Text(_isGenerating ? 'Generating...' : 'Generate Schedule'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF1034A6),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Preview Panel (shown after generation) - rectangle station boxes
                            if (_showPreview)
                              _buildCard(
                                title: 'Generated Preview',
                                icon: Icons.preview,
                                action: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.save, size: 18),
                                  label: const Text('Apply Schedule'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF1034A6),
                                  ),
                                ),
                                child: Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: _generatedStations
                                      .map(_buildStationPreviewCard)
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Top row cards
  // ---------------------------------------------------------------------

  Widget _buildGroupCard() {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isGroupHovered = true),
        onExit: (_) => setState(() => _isGroupHovered = false),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) => setState(() => _selectedGroup = value),
          itemBuilder: (context) => _groupOptions
              .map((g) => PopupMenuItem<String>(value: g, child: Text(g)))
              .toList(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isGroupHovered ? const Color(0xFF1034A6) : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1034A6).withOpacity(_isGroupHovered ? 0.18 : 0.1),
                  blurRadius: _isGroupHovered ? 14 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1034A6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.groups, color: Color(0xFF1034A6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedGroup,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Scheduling Group',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: _isGroupHovered ? const Color(0xFF1034A6) : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
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
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Shared card / field widgets
  // ---------------------------------------------------------------------

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

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${date.month}/${date.day}/${date.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1034A6),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Shift Configuration (Morning / Afternoon / Night, editable)
  // ---------------------------------------------------------------------

  String _formatShiftTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h${m}H';
  }

  Color _shiftDotColor(String label) {
    switch (label.toLowerCase()) {
      case 'morning':
        return const Color(0xFFD97706);
      case 'afternoon':
        return const Color(0xFF1034A6);
      case 'night':
        return const Color(0xFF4C1D95);
      default:
        return Colors.grey;
    }
  }

  Widget _buildShiftRow(_ShiftItem shift, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _shiftDotColor(shift.label),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${shift.label} (${_formatShiftTime(shift.start)} - ${_formatShiftTime(shift.end)})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 18, color: Colors.grey[600]),
            tooltip: 'Edit',
            onPressed: () => _showShiftDialog(existing: shift, index: index),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
            tooltip: 'Delete',
            onPressed: () => _deleteShift(index),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  _formatShiftTime(time),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showShiftDialog({_ShiftItem? existing, int? index}) async {
    final nameController = TextEditingController(text: existing?.label ?? '');
    TimeOfDay start = existing?.start ?? const TimeOfDay(hour: 6, minute: 0);
    TimeOfDay end = existing?.end ?? const TimeOfDay(hour: 14, minute: 0);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(existing == null ? 'Add Shift' : 'Edit Shift'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Shift Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerField(
                            label: 'Start Time',
                            time: start,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: dialogContext,
                                initialTime: start,
                              );
                              if (picked != null) {
                                setDialogState(() => start = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimePickerField(
                            label: 'End Time',
                            time: end,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: dialogContext,
                                initialTime: end,
                              );
                              if (picked != null) {
                                setDialogState(() => end = picked);
                              }
                            },
                          ),
                        ),
                      ],
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1034A6)),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    setState(() {
                      final item = _ShiftItem(
                        label: nameController.text.trim(),
                        start: start,
                        end: end,
                      );
                      if (index != null) {
                        _shifts[index] = item;
                      } else {
                        _shifts.add(item);
                      }
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: Text(existing == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteShift(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Shift'),
        content: Text('Remove "${_shifts[index].label}" from shift configuration?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() => _shifts.removeAt(index));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Generated Preview (rectangle station boxes instead of a table)
  // ---------------------------------------------------------------------

  Widget _buildStationPreviewCard(Map<String, String> data) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onNavigate?.call(ScreenType.scheduleManagement),
        child: Container(
          width: 230,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1034A6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.location_on, size: 18, color: Color(0xFF1034A6)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      data['station']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['shift']!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['assigned']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => widget.onNavigate?.call(ScreenType.scheduleManagement),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1034A6),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _generateSchedule() {
    setState(() {
      _isGenerating = true;
    });

    // Simulate generation delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _showPreview = true;
      });
    });
  }
}