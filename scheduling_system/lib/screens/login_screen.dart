// screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'securityguardui/security_guard_layout.dart';
import 'headguardui/head_guard_layout.dart';

// TEMP: Dummy credentials for testing without a backend.
// username -> (password, role)
class _DummyCredential {
  final String password;
  final String role; // 'admin', 'headguard', or 'security'
  const _DummyCredential(this.password, this.role);
}

const Map<String, _DummyCredential> _dummyCredentials = {
  'admin01': _DummyCredential('admin01', 'admin'),
  'headguard02': _DummyCredential('headguard02', 'headguard'),
  'security03': _DummyCredential('security03', 'security'),
};

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  // Login controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Signup controllers
  final _surnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'Admin';
  final List<String> _roles = ['Admin', 'Head Guard', 'Regular Employee', 'Reliever'];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _surnameController.dispose();
    _firstNameController.dispose();
    _signupEmailController.dispose();
    _mobileController.dispose();
    _signupPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    final credential = _dummyCredentials[username];

    if (credential == null || credential.password != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    switch (credential.role) {
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
        break;
      case 'headguard':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HeadGuardLayout(username: username),
          ),
        );
        break;
      case 'security':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SecurityGuardLayout(username: username),
          ),
        );
        break;
    }
  }

  void _handleSignup() {
    // Fake signup - switch back to login
    setState(() {
      _isLogin = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created! Please login.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Below this width we're effectively on a phone (security guard app),
  // so we drop the branding panel and just show the form full-width.
  static const double _wideBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= _wideBreakpoint;

          if (isWide) {
            // Web / Admin layout - branding panel + form side by side
            return Row(
              children: [
                Expanded(flex: 2, child: _buildBrandingPanel()),
                Expanded(flex: 3, child: _buildFormPanel(isWide: true)),
              ],
            );
          }

          // Mobile / Security Guard layout - form only, full width
          return _buildFormPanel(isWide: false);
        },
      ),
    );
  }

  // Left Side - Branding (web/admin only)
  Widget _buildBrandingPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1034A6),
            Color(0xFF1E88E5),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Schedulr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'A Smart Scheduling System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Right Side - Auth Form (always shown; full width on mobile)
  Widget _buildFormPanel({required bool isWide}) {
    if (isWide) {
      // Web layout keeps the plain light background on the form panel
      return Container(
        color: const Color(0xFFF8FAFC),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLogin ? _buildLoginForm(isWide: true) : _buildSignupForm(isWide: true),
              ),
            ),
          ),
        ),
      );
    }

    // Mobile layout — full-screen gradient background
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D2B8E), // deep navy at top-left
            Color(0xFF1A4DC8), // mid blue
            Color(0xFF2B6DD4), // lighter blue at bottom
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLogin ? _buildLoginForm(isWide: false) : _buildSignupForm(isWide: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm({bool isWide = true}) {
    final Color labelColor = isWide ? const Color(0xFF1E293B) : Colors.white;
    final Color subLabelColor = isWide ? const Color(0xFF64748B) : Colors.white70;
    final Color hintColor = isWide ? Colors.grey.shade400 : Colors.white54;
    final Color iconColor = isWide ? Colors.grey.shade500 : Colors.white60;
    final Color fillColor = isWide ? Colors.white : Colors.white.withOpacity(0.12);
    final Color borderColor = isWide ? Colors.grey.shade300 : Colors.white.withOpacity(0.25);

    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo + Header (centered)
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo placeholder.
              // TODO: Replace this Container/Icon with your own logo, e.g.:
              // Image.asset('assets/logo.png', width: 72, height: 72)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isWide
                      ? const Color(0xFF1034A6).withOpacity(0.1)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: isWide
                      ? null
                      : Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                ),
                child: Icon(
                  Icons.schedule,
                  color: isWide ? const Color(0xFF1034A6) : Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),

              // Header
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 14, color: subLabelColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Username Field
        _buildTextField(
          controller: _loginEmailController,
          label: 'Username',
          hint: 'e.g. admin01',
          icon: Icons.person_outline,
          keyboardType: TextInputType.text,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildTextField(
          controller: _loginPasswordController,
          label: 'Password',
          hint: '••••••••',
          icon: Icons.lock_outlined,
          obscureText: _obscurePassword,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: isWide ? Colors.grey[600] : Colors.white60,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 12),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: isWide ? const Color(0xFF1034A6) : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: isWide ? const Color(0xFF1034A6) : Colors.white,
              foregroundColor: isWide ? Colors.white : const Color(0xFF1034A6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isWide ? 0 : 4,
              shadowColor: Colors.black.withOpacity(0.25),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSignupForm({bool isWide = true}) {
    final Color labelColor = isWide ? const Color(0xFF1E293B) : Colors.white;
    final Color subLabelColor = isWide ? Colors.grey.shade600 : Colors.white70;
    final Color hintColor = isWide ? Colors.grey.shade400 : Colors.white54;
    final Color iconColor = isWide ? Colors.grey.shade500 : Colors.white60;
    final Color fillColor = isWide ? Colors.white : Colors.white.withOpacity(0.12);
    final Color borderColor = isWide ? Colors.grey.shade300 : Colors.white.withOpacity(0.25);

    return Column(
      key: const ValueKey('signup'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in your details to get started',
          style: TextStyle(
            fontSize: 16,
            color: subLabelColor,
          ),
        ),
        const SizedBox(height: 32),

        // Role Selection
        _buildDropdownField(
          label: 'Account Type',
          value: _selectedRole,
          items: _roles,
          icon: Icons.badge_outlined,
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
        ),
        const SizedBox(height: 20),

        // Name Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _surnameController,
                label: 'Surname',
                hint: 'Doe',
                icon: Icons.person_outline,
                labelColor: labelColor,
                hintColor: hintColor,
                iconColor: iconColor,
                fillColor: fillColor,
                borderColor: borderColor,
                isOnGradient: !isWide,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'John',
                icon: Icons.person_outline,
                labelColor: labelColor,
                hintColor: hintColor,
                iconColor: iconColor,
                fillColor: fillColor,
                borderColor: borderColor,
                isOnGradient: !isWide,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Email Field
        _buildTextField(
          controller: _signupEmailController,
          label: 'Email Address',
          hint: 'john.doe@company.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
        ),
        const SizedBox(height: 20),

        // Mobile Field
        _buildTextField(
          controller: _mobileController,
          label: 'Mobile Number',
          hint: '+1 234-567-8900',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildTextField(
          controller: _signupPasswordController,
          label: 'Password',
          hint: '••••••••',
          icon: Icons.lock_outlined,
          obscureText: _obscurePassword,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: isWide ? Colors.grey[600] : Colors.white60,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 20),

        // Confirm Password Field
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hint: '••••••••',
          icon: Icons.lock_outlined,
          obscureText: _obscureConfirmPassword,
          labelColor: labelColor,
          hintColor: hintColor,
          iconColor: iconColor,
          fillColor: fillColor,
          borderColor: borderColor,
          isOnGradient: !isWide,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: isWide ? Colors.grey[600] : Colors.white60,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        const SizedBox(height: 32),

        // Login Link
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: subLabelColor),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = true;
                  });
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: isWide ? const Color(0xFF1034A6) : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    Color? labelColor,
    Color? hintColor,
    Color? iconColor,
    Color? fillColor,
    Color? borderColor,
    bool isOnGradient = false,
  }) {
    final Color resolvedLabel = labelColor ?? const Color(0xFF1E293B);
    final Color resolvedHint = hintColor ?? Colors.grey.shade400;
    final Color resolvedIcon = iconColor ?? Colors.grey.shade500;
    final Color resolvedFill = fillColor ?? Colors.white;
    final Color resolvedBorder = borderColor ?? Colors.grey.shade300;
    final Color focusedBorder = isOnGradient ? Colors.white : const Color(0xFF1034A6);
    final Color inputTextColor = isOnGradient ? Colors.white : const Color(0xFF1E293B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: resolvedLabel,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(color: inputTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: resolvedHint),
            prefixIcon: Icon(icon, color: resolvedIcon),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: resolvedFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: resolvedBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: resolvedBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusedBorder, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1034A6)),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}