// screens/auto_scheduler_content.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/employee.dart';
import 'main_layout.dart';

class AutoSchedulerContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data})? onNavigate;  // Make nullable with ?

  const AutoSchedulerContent({
    Key? key,
    this.onNavigate,  // Remove required
  }) : super(key: key);

  @override
  State<AutoSchedulerContent> createState() => _AutoSchedulerContentState();
}

class _AutoSchedulerContentState extends State<AutoSchedulerContent> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isGenerating = false;
  bool _showPreview = false;

  // Scheduling rules
  bool _dayShift = true;
  bool _nightShift = true;
  int _maxHoursPerWeek = 40;
  int _minRestHours = 12;
  bool _preferSameStation = true;

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
                  onPressed: () => (ScreenType.dashboard),
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
                  // Quick Stats Cards
                  Row(
                    children: [
                      _buildStatCard(
                        'Total Shifts',
                        '56',
                        Icons.calendar_today,
                        const Color(0xFF1034A6),
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Available Staff',
                        '${DummyData.employees.where((e) => e.isActive).length}',
                        Icons.people,
                        const Color(0xFF059669),
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Coverage Target',
                        '100%',
                        Icons.check_circle,
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

                            // Shift Rules Card
                            _buildCard(
                              title: 'Shift Configuration',
                              icon: Icons.schedule,
                              child: Column(
                                children: [
                                  _buildToggleRow(
                                    'Day Shift (7AM - 7PM)',
                                    _dayShift,
                                        (val) => setState(() => _dayShift = val),
                                  ),
                                  const Divider(height: 24),
                                  _buildToggleRow(
                                    'Night Shift (7PM - 7AM)',
                                    _nightShift,
                                        (val) => setState(() => _nightShift = val),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Employee Rules Card
                            _buildCard(
                              title: 'Employee Constraints',
                              icon: Icons.rule,
                              child: Column(
                                children: [
                                  _buildSliderRow(
                                    'Max Hours/Week',
                                    _maxHoursPerWeek.toDouble(),
                                    20,
                                    60,
                                        (val) => setState(() => _maxHoursPerWeek = val.round()),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSliderRow(
                                    'Min Rest Between Shifts',
                                    _minRestHours.toDouble(),
                                    8,
                                    24,
                                        (val) => setState(() => _minRestHours = val.round()),
                                  ),
                                  const Divider(height: 24),
                                  _buildToggleRow(
                                    'Prefer Same Station',
                                    _preferSameStation,
                                        (val) => setState(() => _preferSameStation = val),
                                  ),
                                ],
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

                            // Preview Panel (shown after generation)
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
                                child: Column(
                                  children: [
                                    _buildPreviewHeader(),
                                    const SizedBox(height: 12),
                                    ..._buildPreviewRows(),
                                  ],
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

  Widget _buildSliderRow(
      String label,
      double value,
      double min,
      double max,
      Function(double) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1034A6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.round()} hrs',
                style: const TextStyle(
                  color: Color(0xFF1034A6),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: const Color(0xFF1034A6),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPreviewHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1034A6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 2, child: Text('SHIFT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 3, child: Text('STATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 3, child: Text('ASSIGNED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
          Expanded(flex: 1, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1034A6)))),
        ],
      ),
    );
  }

  List<Widget> _buildPreviewRows() {
    // Dummy preview data
    final previewData = [
      {'date': '04/10/2026', 'shift': 'Day', 'station': 'Main Entrance A', 'assigned': 'Smith, John D.', 'status': 'OK'},
      {'date': '04/10/2026', 'shift': 'Night', 'station': 'Parking Lot B', 'assigned': 'Johnson, Sarah M.', 'status': 'OK'},
      {'date': '04/11/2026', 'shift': 'Day', 'station': 'Lobby C', 'assigned': 'Chen, Mike L.', 'status': 'OK'},
      {'date': '04/11/2026', 'shift': 'Night', 'station': 'Warehouse D', 'assigned': 'Davis, Emily R.', 'status': 'PENDING'},
    ];

    return previewData.map((data) {
      final isPending = data['status'] == 'PENDING';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(data['date']!, style: const TextStyle(fontSize: 13))),
            Expanded(flex: 2, child: Text(data['shift']!, style: const TextStyle(fontSize: 13))),
            Expanded(flex: 3, child: Text(data['station']!, style: const TextStyle(fontSize: 13))),
            Expanded(flex: 3, child: Text(data['assigned']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['status']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isPending ? Colors.orange : Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

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