// models/employee.dart (Updated with name formatting)
class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String station;
  final EmployeeType type;
  final String? profileImage;
  final bool isActive;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.station,
    required this.type,
    this.profileImage,
    this.isActive = true,
  });

  // NEW: Format name as "Surname, First Name M."
  String get formattedName {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      final firstName = parts[0];
      final lastName = parts.last;
      final middleInitial = parts.length > 2 ? '${parts[1][0]}.' : '';
      return '$lastName, $firstName $middleInitial'.trim();
    }
    return name;
  }

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? station,
    EmployeeType? type,
    String? profileImage,
    bool? isActive,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      station: station ?? this.station,
      type: type ?? this.type,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum EmployeeType { regular, reliever }