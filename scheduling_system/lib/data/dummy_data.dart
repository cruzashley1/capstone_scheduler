// data/dummy_data.dart
import '../models/employee.dart';
import '../models/station.dart';
import '../models/schedule.dart';

class DummyData {
  static List<Employee> employees = [
    Employee(
      id: 'EMP001',
      name: 'John Smith',
      email: 'john.smith@company.com',
      phone: '+1 234-567-8901',
      station: 'Monumento',
      type: EmployeeType.regular,
      isActive: true,
    ),
    Employee(
      id: 'EMP002',
      name: 'Sarah Johnson',
      email: 'sarah.j@company.com',
      phone: '+1 234-567-8902',
      station: '5th Avenue',
      type: EmployeeType.regular,
      isActive: true,
    ),
    Employee(
      id: 'EMP003',
      name: 'Mike Chen',
      email: 'mike.chen@company.com',
      phone: '+1 234-567-8903',
      station: 'Doroteo Jose',
      type: EmployeeType.reliever,
      isActive: true,
    ),
    Employee(
      id: 'EMP004',
      name: 'Emily Davis',
      email: 'emily.d@company.com',
      phone: '+1 234-567-8904',
      station: 'Carriedo',
      type: EmployeeType.regular,
      isActive: false,
    ),
    Employee(
      id: 'EMP005',
      name: 'Robert Wilson',
      email: 'rob.w@company.com',
      phone: '+1 234-567-8905',
      station: 'Central Terminal',
      type: EmployeeType.reliever,
      isActive: true,
    ),
    Employee(
      id: 'EMP006',
      name: 'Lisa Anderson',
      email: 'lisa.a@company.com',
      phone: '+1 234-567-8906',
      station: 'Blumentrit',
      type: EmployeeType.reliever,
      isActive: true,
    ),
  ];

  static List<Station> stations = [
    Station(id: 'ST001', name: 'Fernando Poe Jr.', location: 'Station', capacity: 10),
    Station(id: 'ST002', name: 'Balintawak', location: 'Station', capacity: 10),
    Station(id: 'ST003', name: 'Monumento', location: 'Station', capacity: 10),
    Station(id: 'ST004', name: '5th Avenue', location: 'Station', capacity: 10),
    Station(id: 'ST005', name: 'Abad Santos', location: 'Station', capacity: 10),
    Station(id: 'ST006', name: 'Blumentritt', location: 'Station', capacity: 10),
    Station(id: 'ST007', name: 'Tayuman', location: 'Station', capacity: 10),
    Station(id: 'ST008', name: 'Bambang', location: 'Station', capacity: 10),
    Station(id: 'ST009', name: 'Doroteo Jose', location: 'Station', capacity: 10),
    Station(id: 'ST0010', name: 'Carriedo', location: 'Station', capacity: 10),
    Station(id: 'ST0011', name: 'Central Terminal', location: 'Station', capacity: 10),
    Station(id: 'ST0012', name: 'United Nations', location: 'Station', capacity: 10),
    Station(id: 'ST0013', name: 'Pedro Gil', location: 'Station', capacity: 10),
    Station(id: 'ST0014', name: 'Quirino', location: 'Station', capacity: 10),
    Station(id: 'ST0015', name: 'Vito Cruz', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Gil Puyat ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Libertad ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'EDSA ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Baclaran ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Redemptorist-Aseana ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'MIA Road ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'PITX ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Ninoy Aquino Avenue ', location: 'Station', capacity: 10),
    Station(id: 'ST0016', name: 'Dr. Santos ', location: 'Station', capacity: 10),
  ];

  // NEW: Bi-weekly (15-day) schedules, some unpublished, some published.
  static List<Schedule> schedules = _generateSchedules();

  static List<Schedule> _generateSchedules() {
    final activeEmployees = employees.where((e) => e.isActive).toList();
    if (activeEmployees.isEmpty) return [];

    // Each config represents one bi-weekly schedule for a station.
    final configs = [
      {'stationIndex': 2, 'start': DateTime(2026, 6, 17), 'status': ScheduleStatus.unpublished}, // Monumento
      {'stationIndex': 3, 'start': DateTime(2026, 6, 17), 'status': ScheduleStatus.unpublished}, // 5th Avenue
      {'stationIndex': 8, 'start': DateTime(2026, 6, 3), 'status': ScheduleStatus.published}, // Doroteo Jose
      {'stationIndex': 9, 'start': DateTime(2026, 6, 3), 'status': ScheduleStatus.published}, // Carriedo
      {'stationIndex': 10, 'start': DateTime(2026, 6, 3), 'status': ScheduleStatus.published}, // Central Terminal
    ];

    final List<Schedule> result = [];
    int scheduleCounter = 1;

    for (final config in configs) {
      final station = stations[config['stationIndex'] as int];
      final start = config['start'] as DateTime;
      final status = config['status'] as ScheduleStatus;
      final end = start.add(const Duration(days: 14)); // 15 days inclusive

      final days = List.generate(15, (i) {
        final date = start.add(Duration(days: i));
        final dayEmployee = activeEmployees[i % activeEmployees.length];
        final nightEmployee =
        activeEmployees[(i + 1) % activeEmployees.length];

        return ScheduleDay(
          date: date,
          entries: [
            ScheduleEntry(
              id: 'SCH${scheduleCounter}D${i}E1',
              employeeId: dayEmployee.id,
              employeeName: dayEmployee.formattedName,
              shift: 'Day',
            ),
            ScheduleEntry(
              id: 'SCH${scheduleCounter}D${i}E2',
              employeeId: nightEmployee.id,
              employeeName: nightEmployee.formattedName,
              shift: 'Night',
            ),
          ],
        );
      });

      result.add(Schedule(
        id: 'SCHD00$scheduleCounter',
        stationId: station.id,
        stationName: station.name,
        startDate: start,
        endDate: end,
        createdAt: start.subtract(const Duration(days: 3)),
        status: status,
        days: days,
      ));

      scheduleCounter++;
    }

    return result;
  }

  static Map<String, dynamic> getDashboardStats() {
    final totalEmployees = employees.length;
    final totalStations = stations.length;
    final activeEmployees = employees.where((e) => e.isActive).length;
    final relieversAvailable = employees.where((e) => e.type == EmployeeType.reliever && e.isActive).length;
    final regularEmployees = employees.where((e) => e.type == EmployeeType.regular).length;
    final absentToday = 2; // Dummy data

    return {
      'totalEmployees': totalEmployees,
      'totalStations': totalStations,
      'activeEmployees': activeEmployees,
      'relieversAvailable': relieversAvailable,
      'regularEmployees': regularEmployees,
      'absentToday': absentToday,
    };
  }
}