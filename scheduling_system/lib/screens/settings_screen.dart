// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'main_layout.dart';

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────
const _kPrimary      = Color(0xFF1D4ED8);
const _kPrimaryLight = Color(0xFFEFF6FF);
const _kBorder       = Color(0xFFE2E8F0);
const _kText         = Color(0xFF0F172A);
const _kTextMuted    = Color(0xFF64748B);
const _kSurface      = Color(0xFFF8FAFC);
const _kSuccess      = Color(0xFF16A34A);
const _kDanger       = Color(0xFFDC2626);

// ─────────────────────────────────────────────
// SETTINGS TABS
// ─────────────────────────────────────────────
enum _SettingsTab {
  profile,
  password,
  notifications,
  scheduleInfo,
  companyInfo,
}

// ─────────────────────────────────────────────
// MAIN WIDGET
// ─────────────────────────────────────────────
class SettingsContent extends StatefulWidget {
  final Function(ScreenType, {dynamic data})? onNavigate;
  const SettingsContent({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  _SettingsTab _activeTab = _SettingsTab.profile;

  // Password fields
  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl     = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _showCurrent    = false;
  bool _showNew        = false;
  bool _showConfirm    = false;
  String? _pwError;
  bool   _pwSuccess    = false;

  // Notifications
  bool _notifAbsent     = true;
  bool _notifReliever   = true;
  bool _notifSchedule   = false;
  bool _notifUnassigned = true;

  // Prefs
  String _language = 'English';

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    setState(() { _pwError = null; _pwSuccess = false; });
    if (_currentPwCtrl.text.isEmpty || _newPwCtrl.text.isEmpty || _confirmPwCtrl.text.isEmpty) {
      setState(() => _pwError = 'Please fill in all password fields.');
      return;
    }
    if (_newPwCtrl.text.length < 8) {
      setState(() => _pwError = 'New password must be at least 8 characters.');
      return;
    }
    if (_newPwCtrl.text != _confirmPwCtrl.text) {
      setState(() => _pwError = 'New passwords do not match.');
      return;
    }
    setState(() {
      _pwSuccess = true;
      _currentPwCtrl.clear();
      _newPwCtrl.clear();
      _confirmPwCtrl.clear();
    });
  }

  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left sub-nav ──
                  _buildSubNav(),
                  const SizedBox(width: 20),
                  // ── Right content ──
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildContent(),
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

  // ══════════════════════════════════════════
  // TOP BAR
  // ══════════════════════════════════════════
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.settings_rounded, color: _kPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Settings',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800,
                        color: _kText, letterSpacing: -0.3)),
                Text('Manage your account, preferences, and system settings',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: _kTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // LEFT SUB-NAV
  // ══════════════════════════════════════════
  Widget _buildSubNav() {
    final tabs = [
      (_SettingsTab.profile,      Icons.person_rounded,         'Profile Settings'),
      (_SettingsTab.password,     Icons.lock_rounded,           'Password'),
      (_SettingsTab.notifications,Icons.notifications_rounded,  'Notifications'),
      (_SettingsTab.scheduleInfo, Icons.calendar_month_rounded, 'Schedule Info'),
      (_SettingsTab.companyInfo,  Icons.business_rounded,       'Company Info'),
    ];

    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Nav header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _kPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('A',
                        style: TextStyle(color: Colors.white,
                            fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Administrator',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w700, color: _kText),
                          overflow: TextOverflow.ellipsis),
                      Text('Super Admin',
                          style: TextStyle(fontSize: 10, color: _kTextMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Nav items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              children: tabs.map((t) => _navItem(t.$1, t.$2, t.$3)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(_SettingsTab tab, IconData icon, String label) {
    final isActive = _activeTab == tab;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: isActive ? _kPrimaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: _kPrimary.withOpacity(0.15))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 17,
                color: isActive ? _kPrimary : _kTextMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? _kPrimary : _kTextMuted)),
            ),
            if (isActive)
              Container(
                width: 4, height: 4,
                decoration: const BoxDecoration(
                    color: _kPrimary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // RIGHT CONTENT PANEL
  // ══════════════════════════════════════════
  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(
        key: ValueKey(_activeTab),
        child: switch (_activeTab) {
          _SettingsTab.profile       => _buildProfilePanel(),
          _SettingsTab.password      => _buildPasswordPanel(),
          _SettingsTab.notifications => _buildNotificationsPanel(),
          _SettingsTab.scheduleInfo  => _buildScheduleInfoPanel(),
          _SettingsTab.companyInfo   => _buildCompanyInfoPanel(),
        },
      ),
    );
  }

  // ── Panel wrapper ──
  Widget _panel({required String title, required String subtitle, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800, color: _kText)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 13, color: _kTextMuted)),
              ],
            ),
          ),
          const Divider(height: 1, color: _kBorder),
          // Panel content
          Padding(
            padding: const EdgeInsets.all(28),
            child: child,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // 1. PROFILE PANEL
  // ══════════════════════════════════════════
  Widget _buildProfilePanel() {
    return _panel(
      title: 'Profile Settings',
      subtitle: 'View your account information and role details.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar row
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _kPrimary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text('A',
                          style: TextStyle(color: Colors.white,
                              fontSize: 32, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _kBorder, width: 1.5),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 14, color: _kTextMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Administrator',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w800, color: _kText)),
                    const SizedBox(height: 4),
                    const Text('admin@kaizensecurity.com',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: _kTextMuted)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kSuccess.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _kSuccess.withOpacity(0.3)),
                      ),
                      child: const Text('Super Admin',
                          style: TextStyle(fontSize: 11,
                              fontWeight: FontWeight.w700, color: _kSuccess)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: _kBorder, height: 1),
          const SizedBox(height: 28),

          // Info grid
          _fieldRow(
            left: _readOnlyField('Full Name', 'Administrator'),
            right: _readOnlyField('Role', 'OPNS/Man Loading Officer'),
          ),
          const SizedBox(height: 20),
          _fieldRow(
            left: _readOnlyField('Email Address', 'admin@kaizensecurity.com'),
            right: _readOnlyField('Organization', 'Kaizen Security Agency Corp.'),
          ),
          const SizedBox(height: 20),
          _fieldRow(
            left: _readOnlyField('Account Type', 'Single Administrator'),
            right: _readOnlyField('Last Login', _todayDate()),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kPrimary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 15, color: _kPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Profile information is managed by the system. '
                        'Contact your IT department to update account details.',
                    style: TextStyle(fontSize: 12, color: _kPrimary.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // 2. PASSWORD PANEL
  // ══════════════════════════════════════════
  Widget _buildPasswordPanel() {
    return _panel(
      title: 'Change Password',
      subtitle: 'Update your password to keep your account secure.',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pwField('Current Password', _currentPwCtrl, _showCurrent,
                    () => setState(() => _showCurrent = !_showCurrent)),
            const SizedBox(height: 20),
            _pwField('New Password', _newPwCtrl, _showNew,
                    () => setState(() => _showNew = !_showNew)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 13, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text('Minimum 8 characters required.',
                    style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              ],
            ),
            const SizedBox(height: 20),
            _pwField('Confirm New Password', _confirmPwCtrl, _showConfirm,
                    () => setState(() => _showConfirm = !_showConfirm)),
            const SizedBox(height: 24),

            if (_pwError != null) ...[
              _feedbackBanner(_pwError!, isError: true),
              const SizedBox(height: 16),
            ],
            if (_pwSuccess) ...[
              _feedbackBanner('Password updated successfully!', isError: false),
              const SizedBox(height: 16),
            ],

            ElevatedButton(
              onPressed: _handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 3. NOTIFICATIONS PANEL
  // ══════════════════════════════════════════
  Widget _buildNotificationsPanel() {
    return _panel(
      title: 'Notification Settings',
      subtitle: 'Choose which events trigger alerts in the system.',
      child: Column(
        children: [
          _notifTile(
            icon: Icons.person_off_rounded,
            color: _kDanger,
            title: 'Absent Guard Reported',
            subtitle: 'Alert when a head guard reports an absent employee via the mobile app.',
            value: _notifAbsent,
            onChanged: (v) => setState(() => _notifAbsent = v),
          ),
          _notifDivider(),
          _notifTile(
            icon: Icons.swap_horiz_rounded,
            color: const Color(0xFFD97706),
            title: 'Reliever Successfully Assigned',
            subtitle: 'Notify when the AI assigns and the admin approves a reliever replacement.',
            value: _notifReliever,
            onChanged: (v) => setState(() => _notifReliever = v),
          ),
          _notifDivider(),
          _notifTile(
            icon: Icons.calendar_month_rounded,
            color: _kPrimary,
            title: 'Schedule Published',
            subtitle: 'Alert when a bi-weekly schedule is published and visible on the mobile app.',
            value: _notifSchedule,
            onChanged: (v) => setState(() => _notifSchedule = v),
          ),
          _notifDivider(),
          _notifTile(
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFF7C3AED),
            title: 'Unassigned Shifts Warning',
            subtitle: 'Alert when a shift position has no assigned guard before the period starts.',
            value: _notifUnassigned,
            onChanged: (v) => setState(() => _notifUnassigned = v),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.phone_android_rounded, size: 15, color: Colors.grey[400]),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Notifications will also be pushed to connected mobile devices '
                        'once the employee mobile app is released.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // 4. SCHEDULE INFO PANEL
  // ══════════════════════════════════════════
  Widget _buildScheduleInfoPanel() {
    return _panel(
      title: 'Schedule Configuration',
      subtitle: 'Fixed scheduling rules applied across all 25 stations.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info tiles
          Row(
            children: [
              Expanded(child: _infoTile(Icons.date_range_rounded,    _kPrimary,                'Schedule Type',           'Bi-Weekly',    '1–15 and 16–end of month')),
              const SizedBox(width: 14),
              Expanded(child: _infoTile(Icons.location_city_rounded, const Color(0xFF7C3AED), 'Total Stations',           '25 Stations',  '20 Main Line  ·  5 Extension')),
              const SizedBox(width: 14),
              Expanded(child: _infoTile(Icons.people_alt_rounded,    _kSuccess,               'Guards per Station',       '16 Guards',    '7 Morning · 7 Afternoon · 2 Night')),
              const SizedBox(width: 14),
              Expanded(child: _infoTile(Icons.work_rounded,          const Color(0xFFD97706), 'Position Types',           '10 Positions', 'Per station per shift')),
            ],
          ),
          const SizedBox(height: 28),

          // Shift schedule
          const Text('Shift Schedule',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _kText)),
          const SizedBox(height: 4),
          const Text('Default shift times. Guards may report earlier for mandatory meetings.',
              style: TextStyle(fontSize: 12, color: _kTextMuted)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _shiftCard('Morning Shift',   '0600H – 1400H', Icons.wb_sunny_rounded,  const Color(0xFF1D4ED8))),
              const SizedBox(width: 14),
              Expanded(child: _shiftCard('Afternoon Shift', '1400H – 2200H', Icons.wb_cloudy_rounded,  const Color(0xFF0369A1))),
              const SizedBox(width: 14),
              Expanded(child: _shiftCard('Night Shift',     '2200H – 0600H', Icons.nightlight_rounded, const Color(0xFF065F46))),
            ],
          ),
          const SizedBox(height: 24),

          // Positions list
          const Text('Security Positions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _kText)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Head Guard', 'SW Platform', 'SE Jackman', 'SE Platform',
              'Roving', 'K9 Unit', 'S Street Roving Guard',
              'N SM Roving Guard', 'Inspection Guard', 'Train Marshall',
            ].asMap().entries.map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: _kPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${e.key + 1}',
                          style: const TextStyle(fontSize: 9,
                              fontWeight: FontWeight.w800, color: _kPrimary)),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(e.value,
                      style: const TextStyle(fontSize: 12,
                          fontWeight: FontWeight.w600, color: _kText)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // 5. COMPANY INFO PANEL
  // ══════════════════════════════════════════
  Widget _buildCompanyInfoPanel() {
    return _panel(
      title: 'Company Information',
      subtitle: 'Details about Kaizen Security Agency Corp. used across the system.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + name
          Row(
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: _kPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('KSA',
                      style: TextStyle(color: Colors.white,
                          fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('KAIZEN SECURITY AGENCY CORP.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w900, color: _kText, letterSpacing: 0.3)),
                    SizedBox(height: 4),
                    Text('Security Services Provider',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: _kTextMuted)),
                    SizedBox(height: 8),
                    Text('Client: Light Rail Transit Authority',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12,
                            fontWeight: FontWeight.w600, color: _kTextMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: _kBorder, height: 1),
          const SizedBox(height: 28),

          _fieldRow(
            left: _readOnlyField('Company Name', 'Kaizen Security Agency Corp.'),
            right: _readOnlyField('Client', 'Light Rail Transit Authority'),
          ),
          const SizedBox(height: 20),
          _fieldRow(
            left: _readOnlyField('Total Stations Covered', '25 LRT Stations'),
            right: _readOnlyField('Total Security Personnel', '464 Guards'),
          ),
          const SizedBox(height: 20),
          _fieldRow(
            left: _readOnlyField('Schedule System Version', 'v1.0.0-beta'),
            right: _readOnlyField('Report Signatories', 'Prepared · Approved · Endorsed'),
          ),
          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 15, color: Colors.grey[400]),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Company information is read-only and managed by the system. '
                        'Contact your IT department for any updates.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  // SHARED HELPERS
  // ══════════════════════════════════════════
  Widget _fieldRow({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w600, color: _kText)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kBorder),
          ),
          child: Text(value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13,
                  fontWeight: FontWeight.w500, color: _kTextMuted)),
        ),
      ],
    );
  }

  Widget _pwField(String label, TextEditingController ctrl,
      bool visible, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w600, color: _kText)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: !visible,
          style: const TextStyle(fontSize: 13, color: _kText),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon: Icon(
                  visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 18, color: _kTextMuted),
              onPressed: toggle,
            ),
            filled: true,
            fillColor: _kSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _kPrimary, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _feedbackBanner(String message, {required bool isError}) {
    final color = isError ? _kDanger : _kSuccess;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _notifTile({
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required bool value, required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w700, color: _kText)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: _kTextMuted)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: _kPrimary),
        ],
      ),
    );
  }

  Widget _notifDivider() => const Divider(height: 1, color: _kBorder);

  Widget _infoTile(IconData icon, Color color, String label, String value, String note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 3),
          Text(label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kText)),
          const SizedBox(height: 3),
          Text(note,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 10, color: _kTextMuted)),
        ],
      ),
    );
  }

  Widget _shiftCard(String label, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 2),
                Text(time,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _kTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _todayDate() {
    final n = DateTime.now();
    const months = ['','Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[n.month]} ${n.day}, ${n.year}';
  }
}