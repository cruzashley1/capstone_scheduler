// models/schedule.dart
enum ScheduleStatus { unpublished, published }

class ScheduleEntry {
  final String id;
  final String employeeId;
  final String employeeName;
  final String shift; // 'Day' or 'Night'

  ScheduleEntry({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.shift,
  });
}

class ScheduleDay {
  final DateTime date;
  final List<ScheduleEntry> entries;

  ScheduleDay({
    required this.date,
    required this.entries,
  });
}

class Schedule {
  final String id;
  final String stationId;
  final String stationName;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final ScheduleStatus status;
  final List<ScheduleDay> days;

  Schedule({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.status,
    required this.days,
  });

  int get totalDays => days.length;

  int get totalAssignments =>
      days.fold(0, (sum, day) => sum + day.entries.length);

  Schedule copyWith({
    String? id,
    String? stationId,
    String? stationName,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    ScheduleStatus? status,
    List<ScheduleDay>? days,
  }) {
    return Schedule(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      days: days ?? this.days,
    );
  }
}