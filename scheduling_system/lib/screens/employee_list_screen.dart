// screens/employee_list_content.dart (Updated with your requirements)
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/employee.dart';
import 'main_layout.dart';
import 'employee_detail_screen.dart';

class EmployeeListContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data}) onNavigate;

  const EmployeeListContent({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<EmployeeListContent> createState() => _EmployeeListContentState();
}

class _EmployeeListContentState extends State<EmployeeListContent> {
  EmployeeType _selectedType = EmployeeType.regular;
  List<Employee> _employees = [];
  // NEW: Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filterEmployees();
    // NEW: Listen to search changes
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

  // Update this method to sort by surname alphabetically
  void _filterEmployees() {
    setState(() {
      _employees = DummyData.employees
          .where((e) => e.type == _selectedType)
          .toList()
        ..sort((a, b) {
          // Extract surnames for alphabetical sorting
          final aSurname = a.formattedName.split(',').first;
          final bSurname = b.formattedName.split(',').first;
          return aSurname.compareTo(bSurname);
        });
    });
  }

  // NEW: Filter employees based on search
  List<Employee> get _filteredEmployees {
    if (_searchQuery.isEmpty) return _employees;

    return _employees.where((e) {
      final searchLower = _searchQuery;
      return e.id.toLowerCase().contains(searchLower) ||
          e.name.toLowerCase().contains(searchLower) ||
          e.station.toLowerCase().contains(searchLower) ||
          e.email.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header - UPDATED with Search Bar
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => widget.onNavigate(ScreenType.dashboard),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your staff and assignments',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // NEW: Search Bar added here
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1034A6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Toggle Buttons - EXACTLY AS YOU DESIGNED
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              _buildToggleButton(
                'Regular Employee',
                EmployeeType.regular,
                Icons.badge,
              ),
              const SizedBox(width: 12),
              _buildToggleButton(
                'Reliever Employee',
                EmployeeType.reliever,
                Icons.swap_horiz,
              ),
            ],
          ),
        ),

        // NEW: Show search results count
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredEmployees.length} result${_filteredEmployees.length != 1 ? 's' : ''} found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),

        // Employee Table - EXACTLY AS YOU DESIGNED
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header - EXACTLY AS YOU DESIGNED
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1034A6).withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTableHeader('Employee ID', 1),
                        // ADDED: Vertical divider
                        const VerticalDividerWidget(),
                        _buildTableHeader('Name', 2),
                        // ADDED: Vertical divider
                        const VerticalDividerWidget(),
                        _buildTableHeader('Station Assignment', 2),
                        // ADDED: Vertical divider
                        const VerticalDividerWidget(),
                        _buildTableHeader('Status', 1),
                        // ADDED: Vertical divider
                        const VerticalDividerWidget(),
                        _buildTableHeader('Actions', 1),
                      ],
                    ),
                  ),

                  // Table Body - UPDATED to use filtered list
                  Expanded(
                    child: _filteredEmployees.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? 'No employees found' : 'No results found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                        : ListView.separated(
                      itemCount: _filteredEmployees.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final employee = _filteredEmployees[index];
                        return _buildEmployeeRow(employee);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // ALL YOUR EXACT ORIGINAL METHODS
  Widget _buildToggleButton(String label, EmployeeType type, IconData icon) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _filterEmployees();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1034A6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1034A6) : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF1034A6).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${DummyData.employees.where((e) => e.type == type).length}',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1034A6),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildEmployeeRow(Employee employee) {
    return InkWell(
      onTap: () {
        widget.onNavigate(ScreenType.employeeDetail, data: employee);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                employee.id,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            // ADDED: Vertical divider
            const VerticalDividerWidget(),
            Expanded(
              flex: 2,
              child: Text(
                employee.formattedName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // ADDED: Vertical divider
            const VerticalDividerWidget(),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(employee.station),
                ],
              ),
            ),
            // ADDED: Vertical divider
            const VerticalDividerWidget(),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: employee.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  employee.isActive ? 'On Duty' : 'Day Off',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: employee.isActive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // ADDED: Vertical divider
            const VerticalDividerWidget(),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                    onPressed: () {
                      widget.onNavigate(ScreenType.employeeDetail, data: employee);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => _showDeleteDialog(employee),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                DummyData.employees.removeWhere((e) => e.id == employee.id);
                _filterEmployees();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Employee deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ADDED: Reusable vertical divider widget for table columns
class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[300],
    );
  }
}