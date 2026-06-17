// screens/station_detail_screen.dart (Updated requirements)
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/station.dart';
import '../models/employee.dart';
import 'main_layout.dart';
import 'employee_detail_screen.dart';

class StationDetailContent extends StatelessWidget {
  final Station station;
  final Function(ScreenType, {dynamic data}) onNavigate;

  const StationDetailContent({
    Key? key,
    required this.station,
    required this.onNavigate,
  }) : super(key: key);

  // NEW: Hardcoded required employees to 16
  static const int requiredEmployees = 16;

  // UPDATED: Get sorted employees by surname
  List<Employee> get assignedEmployees {
    final employees = DummyData.employees
        .where((e) => e.station == station.name)
        .toList();

    // Sort by surname alphabetically using formattedName
    employees.sort((a, b) {
      final aSurname = a.formattedName.split(',').first;
      final bSurname = b.formattedName.split(',').first;
      return aSurname.compareTo(bSurname);
    });

    return employees;
  }

  // NEW: Check if complete (16 employees)
  bool get isComplete => assignedEmployees.length >= requiredEmployees;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Custom AppBar area - EXACTLY AS YOU DESIGNED
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                  onPressed: () => onNavigate(ScreenType.stationManagement),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        station.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Station'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1034A6),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body - EXACTLY AS YOU DESIGNED
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Stats - UPDATED labels and logic
                  Row(
                    children: [
                      _buildStatCard(
                          'Total Assigned',
                          assignedEmployees.length.toString(),
                          Icons.people
                      ),
                      const SizedBox(width: 16),
                      // CHANGED: Capacity → Required Employees, value 16
                      _buildStatCard(
                          'Required Employees',
                          requiredEmployees.toString(),
                          Icons.meeting_room
                      ),
                      const SizedBox(width: 16),
                      // CHANGED: Active → Complete/Not Complete based on count
                      _buildStatCard(
                          'Status',
                          isComplete ? 'Complete' : 'Not Complete',
                          isComplete ? Icons.check_circle : Icons.warning,
                          isPositive: isComplete
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Section Title - EXACTLY AS YOU DESIGNED
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
                        'Assigned Employees',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Employee List - Now sorted alphabetically by surname
                  Expanded(
                    child: assignedEmployees.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                      itemCount: assignedEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = assignedEmployees[index];
                        return _buildEmployeeListTile(employee);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {bool isPositive = false}) {
    // UPDATED: Color logic for Complete vs Not Complete
    Color iconColor = const Color(0xFF1034A6);
    if (label == 'Status') {
      iconColor = isPositive ? Colors.green : Colors.orange;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
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
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UPDATED: Use formattedName for display
  Widget _buildEmployeeListTile(Employee employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          onNavigate(ScreenType.employeeDetail, data: employee);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1034A6),
                      const Color(0xFF1034A6).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    employee.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CHANGED: Use formattedName instead of name
                    Text(
                      employee.formattedName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.id,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: employee.type == EmployeeType.regular
                      ? const Color(0xFFEDE9FE)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: employee.type == EmployeeType.regular
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                child: Text(
                  employee.type == EmployeeType.regular ? 'Regular' : 'Reliever',
                  style: TextStyle(
                    color: employee.type == EmployeeType.regular
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFFD97706),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No employees assigned',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Assign Employee'),
          ),
        ],
      ),
    );
  }
}