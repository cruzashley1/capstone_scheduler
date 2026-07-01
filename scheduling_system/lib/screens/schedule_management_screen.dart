// screens/schedule_management_screen.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/schedule.dart';
import 'main_layout.dart';

class ScheduleManagementContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data}) onNavigate;

  const ScheduleManagementContent({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<ScheduleManagementContent> createState() => _ScheduleManagementContentState();
}

class _ScheduleManagementContentState extends State<ScheduleManagementContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  String _formatRange(DateTime start, DateTime end) =>
      '${_formatDate(start)} \u2013 ${_formatDate(end)}';

  // NEW: Filter schedules by station name, same pattern as Station Management
  List<Schedule> get _filteredSchedules {
    if (_searchQuery.isEmpty) return DummyData.schedules;
    return DummyData.schedules
        .where((s) => s.stationName.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _publishAll() {
    setState(() {
      for (var i = 0; i < DummyData.schedules.length; i++) {
        if (DummyData.schedules[i].status == ScheduleStatus.unpublished) {
          DummyData.schedules[i] =
              DummyData.schedules[i].copyWith(status: ScheduleStatus.published);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All schedules published')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSchedules;
    final unpublished =
    filtered.where((s) => s.status == ScheduleStatus.unpublished).toList();
    final published =
    filtered.where((s) => s.status == ScheduleStatus.published).toList();
    final hasUnpublished =
    DummyData.schedules.any((s) => s.status == ScheduleStatus.unpublished);

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Header - back button, title, search bar, Publish All
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
                  onPressed: () => widget.onNavigate(ScreenType.dashboard),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Schedule Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Review unpublished schedules and manage published ones',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  width: 280,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search schedules...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500], size: 18),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Publish All — bulk-publishes every unpublished schedule
                ElevatedButton.icon(
                  onPressed: hasUnpublished ? _publishAll : null,
                  icon: const Icon(Icons.publish, size: 18),
                  label: const Text('Publish All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1034A6),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search results count
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtered.length} result${filtered.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (unpublished.isNotEmpty) ...[
                    _buildSectionHeader(
                      'Unpublished Schedules',
                      unpublished.length,
                      const Color(0xFFD97706),
                      Icons.edit_calendar_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildScheduleGrid(unpublished),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionHeader(
                    'Published Schedules',
                    published.length,
                    const Color(0xFF059669),
                    Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 16),
                  if (published.isEmpty)
                    _buildEmptyState()
                  else
                    _buildScheduleGrid(published),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // 2 columns instead of the Station grid's 3 — each tile here carries more
  // info (period, staffing, actions), so the extra width keeps it readable.
  Widget _buildScheduleGrid(List<Schedule> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 20.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map((s) => SizedBox(
            width: cardWidth,
            child: _buildScheduleCard(s),
          ))
              .toList(),
        );
      },
    );
  }

  // YOUR STATION CARD PATTERN, adapted: icon + status badge on top,
  // station name, created date, staffing details box, then edit/delete actions.
  Widget _buildScheduleCard(Schedule schedule) {
    final isPublished = schedule.status == ScheduleStatus.published;
    final statusColor = isPublished ? const Color(0xFF059669) : const Color(0xFFD97706);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavigate(ScreenType.scheduleDetail, data: schedule),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isPublished ? Colors.transparent : statusColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1034A6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        color: Color(0xFF1034A6),
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration:
                            BoxDecoration(color: statusColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPublished ? 'Published' : 'Unpublished',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Station name on top, created date right below it
                Text(
                  schedule.stationName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Created ${_formatDate(schedule.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // Staffing / employee details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatRange(schedule.startDate, schedule.endDate),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            '${schedule.totalAssignments} shifts \u00b7 ${schedule.totalDays} days',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Edit / Delete actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showComingSoon(context, 'Edit schedule'),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showComingSoon(context, 'Delete schedule'),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[400],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'No schedules found' : 'No published schedules yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 4),
            Text(
              'Generate a schedule from Auto Scheduler to see it here.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action \u2014 coming soon')),
    );
  }
}