// models/station.dart
class Station {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final bool isActive;

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    this.isActive = true,
  });
}

