// screens/headguardui/headguard_report_screen.dart
import 'package:flutter/material.dart';

class HeadGuardReportScreen extends StatefulWidget {
  const HeadGuardReportScreen({Key? key}) : super(key: key);

  @override
  State<HeadGuardReportScreen> createState() => _HeadGuardReportScreenState();
}

class _HeadGuardReportScreenState extends State<HeadGuardReportScreen> {
  final String shiftTitle = 'Morning Shift';
  final String shiftDate = 'Friday, April 11, 2025';

  // TEMP: Dummy attendance data for the current shift.
  final List<Map<String, dynamic>> personnel = [
    {
      'name': 'James Reyes',
      'initials': 'JR',
      'avatarColor': const Color(0xFF22C55E),
      'station': 'Main Gate',
      'time': '06:00 AM',
      'employeeId': 'SG-2024-001',
      'isPresent': true,
    },
    {
      'name': 'Maria Santos',
      'initials': 'MS',
      'avatarColor': const Color(0xFFEC4899),
      'station': 'North Wing',
      'time': '06:00 AM',
      'employeeId': 'SG-2023-012',
      'isPresent': true,
    },
    {
      'name': 'Roberto Cruz',
      'initials': 'RC',
      'avatarColor': const Color(0xFF8B5CF6),
      'station': 'South Entrance',
      'time': '06:00 AM',
      'employeeId': 'SG-2022-008',
      'isPresent': true,
    },
    {
      'name': 'Anna Lim',
      'initials': 'AL',
      'avatarColor': const Color(0xFFF59E0B),
      'station': 'East Gate',
      'time': '06:00 AM',
      'employeeId': 'SG-2023-045',
      'isPresent': false,
    },
    {
      'name': 'Mark Dela Cruz',
      'initials': 'MD',
      'avatarColor': const Color(0xFF1034A6),
      'station': 'West Wing',
      'time': '06:00 AM',
      'employeeId': 'SG-2021-009',
      'isPresent': true,
    },
    {
      'name': 'Patricia Ramos',
      'initials': 'PR',
      'avatarColor': const Color(0xFF14B8A6),
      'station': 'Main Gate',
      'time': '06:00 AM',
      'employeeId': 'SG-2024-018',
      'isPresent': true,
    },
    {
      'name': 'Daniel Torres',
      'initials': 'DT',
      'avatarColor': const Color(0xFFEF4444),
      'station': 'North Wing',
      'time': '06:00 AM',
      'employeeId': 'SG-2022-031',
      'isPresent': true,
    },
    {
      'name': 'Carla Villanueva',
      'initials': 'CV',
      'avatarColor': const Color(0xFF0EA5E9),
      'station': 'South Entrance',
      'time': '06:00 AM',
      'employeeId': 'SG-2023-027',
      'isPresent': true,
    },
  ];

  int get _totalCount => personnel.length;
  int get _presentCount => personnel.where((p) => p['isPresent'] == true).length;
  int get _absentCount => _totalCount - _presentCount;
  bool get _isComplete => _presentCount == _totalCount;
  bool _isSubmitting = false;

  void _toggleAttendance(int index) {
    setState(() {
      personnel[index]['isPresent'] = !personnel[index]['isPresent'];
    });
  }

  Future<void> _handleSubmitPressed() async {
    final confirmed = await _showSubmitConfirmationDialog();
    if (confirmed == true) {
      await _submitReport();
    }
  }

  Future<bool?> _showSubmitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Submit Attendance Report?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          content: Text(
            _isComplete
                ? 'You are about to submit the attendance report for $shiftTitle with $_presentCount of $_totalCount personnel marked present. This action cannot be undone.'
                : 'You are about to submit the attendance report for $shiftTitle with $_absentCount personnel marked absent. Please make sure all records are correct before proceeding, as this action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1034A6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReport() async {
    setState(() => _isSubmitting = true);

    // TODO: Replace with actual API call to submit the attendance report.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Attendance report submitted successfully.'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header - square corners to match Schedule/Alerts/Profile
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width < 360 ? 14 : 20,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1034A6),
                    Color(0xFF1E4AD0),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Attendance Report',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width < 360 ? 17 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isComplete ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isComplete ? 'Complete' : 'Incomplete',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Shift summary card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shiftTitle,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shiftDate,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$_presentCount/$_totalCount',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[400],
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    'Present',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red[300],
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _totalCount == 0 ? 0 : _presentCount / _totalCount,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            color: const Color(0xFF1034A6),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Present / Absent / Total
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 8,
                          children: [
                            _buildStatItem(
                              icon: Icons.check_circle,
                              iconColor: Colors.green,
                              label: '$_presentCount Present',
                            ),
                            _buildStatItem(
                              icon: Icons.cancel,
                              iconColor: Colors.red,
                              label: '$_absentCount Absent',
                            ),
                            _buildStatItem(
                              icon: Icons.groups_outlined,
                              iconColor: const Color(0xFF1034A6),
                              label: '$_totalCount Total',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personnel section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Personnel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tap to toggle',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...personnel.asMap().entries.map((entry) {
                    return _buildPersonnelCard(entry.key, entry.value);
                  }),

                  const SizedBox(height: 24),

                  // Submit Report button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmitPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1034A6),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        const Color(0xFF1034A6).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_outlined, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Submit Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonnelCard(int index, Map<String, dynamic> guard) {
    final bool isPresent = guard['isPresent'] as bool;

    return GestureDetector(
      onTap: () => _toggleAttendance(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: guard['avatarColor'] as Color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  guard['initials'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name + details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guard['name'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          guard['time'] as String,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    guard['employeeId'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Present / Absent toggle pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isPresent
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPresent ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: isPresent ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}