// screens/employee_detail_screen.dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/employee.dart';
import 'main_layout.dart'; // For ScreenType enum

// CHANGED: Now accepts onBack and onNavigate callbacks
// REASON: Allows navigation without using Navigator (fixes double drawer issue)
class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onBack;  // NEW: Callback for back navigation
  final Function(ScreenType, {dynamic data})? onNavigate;  // NEW: Callback for internal navigation

  const EmployeeDetailScreen({
    Key? key,
    required this.employee,
    this.onBack,
    this.onNavigate,
  }) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _stationController;
  late EmployeeType _selectedType;
  bool _isEditing = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _emailController = TextEditingController(text: widget.employee.email);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _stationController = TextEditingController(text: widget.employee.station);
    _selectedType = widget.employee.type;
    _isActive = widget.employee.isActive;
  }

  void _saveChanges() {
    final updatedEmployee = widget.employee.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      station: _stationController.text,
      type: _selectedType,
      isActive: _isActive,
    );

    final index = DummyData.employees.indexWhere((e) => e.id == widget.employee.id);
    if (index != -1) {
      DummyData.employees[index] = updatedEmployee;
    }

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee updated successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // CHANGED: Use callback instead of Navigator.pop
    // REASON: Prevents creating new routes, keeps single MainLayout structure
    if (widget.onBack != null) {
      widget.onBack!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: Removed outer Scaffold, using Container instead
    // REASON: MainLayout already provides Scaffold, prevents double drawer
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // CHANGED: Converted AppBar to custom header container
          // REASON: AppBar requires Scaffold, we use custom header in content area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                  onPressed: () {
                    // CHANGED: Use callback if available, fallback to Navigator
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _isEditing ? 'Edit Employee' : 'Employee Details',
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _isEditing = true),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1034A6),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save, size: 16),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // REST OF YOUR UI - EXACTLY AS BEFORE (landscape layout)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side - Profile Section (your exact code)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
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
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Profile Image
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF1034A6),
                                            const Color(0xFF1034A6).withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF1034A6).withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.employee.name.substring(0, 1),
                                          style: const TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_isEditing)
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                          color: Color(0xFF1034A6),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Name
                                Text(
                                  widget.employee.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.employee.id,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Status Badge
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _selectedType == EmployeeType.regular
                                        ? const Color(0xFFEDE9FE)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedType == EmployeeType.regular
                                          ? const Color(0xFF8B5CF6)
                                          : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Employee Type',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _selectedType == EmployeeType.regular
                                                ? Icons.badge
                                                : Icons.swap_horiz,
                                            color: _selectedType == EmployeeType.regular
                                                ? const Color(0xFF7C3AED)
                                                : const Color(0xFFD97706),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _selectedType == EmployeeType.regular ? 'Regular' : 'Reliever',
                                            style: TextStyle(
                                              color: _selectedType == EmployeeType.regular
                                                  ? const Color(0xFF7C3AED)
                                                  : const Color(0xFFD97706),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_isEditing) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ChoiceChip(
                                              label: const Text('Regular'),
                                              selected: _selectedType == EmployeeType.regular,
                                              selectedColor: const Color(0xFF8B5CF6),
                                              labelStyle: TextStyle(
                                                color: _selectedType == EmployeeType.regular
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              onSelected: (selected) {
                                                if (selected) {
                                                  setState(() => _selectedType = EmployeeType.regular);
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            ChoiceChip(
                                              label: const Text('Reliever'),
                                              selected: _selectedType == EmployeeType.reliever,
                                              selectedColor: const Color(0xFFF59E0B),
                                              labelStyle: TextStyle(
                                                color: _selectedType == EmployeeType.reliever
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              onSelected: (selected) {
                                                if (selected) {
                                                  setState(() => _selectedType = EmployeeType.reliever);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // NEW: View Schedule Button
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Navigate to schedule view
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Schedule view coming soon'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.calendar_month, size: 18),
                                    label: const Text('View Schedule'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1034A6),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // CHANGED: Active/Inactive → On Duty/Day Off
                                if (_isEditing)
                                  SwitchListTile(
                                    title: const Text('Active Status'),
                                    value: _isActive,
                                    activeColor: const Color(0xFF1034A6),
                                    onChanged: (value) => setState(() => _isActive = value),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: _isActive
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _isActive ? Colors.green : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          // CHANGED: Active → On Duty, Inactive → Day Off
                                          _isActive ? 'On Duty' : 'Day Off',
                                          style: TextStyle(
                                            color: _isActive ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Delete Button
                        if (!_isEditing)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _showDeleteConfirmation,
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              label: const Text(
                                'Delete Employee',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
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

                  const SizedBox(width: 24),

                  // Right Side - Details Section (your exact code)
                  Expanded(
                    flex: 3,
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
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Employee Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form Grid
                            LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 4,
                                  children: [
                                    _buildDetailField(
                                      'Full Name',
                                      _nameController,
                                      Icons.person_outline,
                                      enabled: _isEditing,
                                    ),
                                    _buildDetailField(
                                      'Email Address',
                                      _emailController,
                                      Icons.email_outlined,
                                      enabled: _isEditing,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    _buildDetailField(
                                      'Phone Number',
                                      _phoneController,
                                      Icons.phone_outlined,
                                      enabled: _isEditing,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    _buildDetailField(
                                      'Station Assignment',
                                      _stationController,
                                      Icons.location_on_outlined,
                                      enabled: _isEditing,
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            // Additional Information Section
                            const Text(
                              'Additional Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildInfoRow('Employee ID', widget.employee.id),
                            _buildInfoRow('Date Joined', 'January 15, 2023'),
                            _buildInfoRow('Department', 'Security Operations'),
                            _buildInfoRow('Reports To', 'Manager Name'),

                            if (_isEditing) ...[
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => setState(() => _isEditing = false),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: const BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _saveChanges,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1034A6),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Save Changes'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
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

  // YOUR EXACT HELPER METHODS - NO CHANGES
  Widget _buildDetailField(
      String label,
      TextEditingController controller,
      IconData icon, {
        required bool enabled,
        TextInputType? keyboardType,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1034A6)),
            filled: !enabled,
            fillColor: enabled ? null : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1034A6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete ${widget.employee.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              DummyData.employees.removeWhere((e) => e.id == widget.employee.id);
              Navigator.pop(context);
              // CHANGED: Use callback instead of Navigator.pop
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
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