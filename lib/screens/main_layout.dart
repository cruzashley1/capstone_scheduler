import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../models/employee.dart';
import '../models/station.dart';
import 'dashboard_screen.dart';
import 'employee_list_screen.dart';
import 'station_management_screen.dart';
import 'station_detail_screen.dart';
import 'employee_detail_screen.dart';
import 'auto_scheduler_screen.dart';
import 'ai_smart_replace_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

enum ScreenType {
  dashboard,
  employeeList,
  employeeDetail,
  stationManagement,
  stationDetail,
  autoScheduler,
  aiSmartReplace,
  reports,
  settings,
}

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  ScreenType _currentScreen = ScreenType.dashboard;
  dynamic _screenData;

  void _navigateTo(ScreenType screen, {dynamic data}) {
    setState(() {
      _currentScreen = screen;
      _screenData = data;
    });
  }

  int _getSelectedIndex() {
    switch (_currentScreen) {
      case ScreenType.dashboard:
        return 0;
      case ScreenType.employeeList:
      case ScreenType.employeeDetail:
        return 1;
      case ScreenType.stationManagement:
      case ScreenType.stationDetail:
        return 2;
      case ScreenType.autoScheduler:
        return 3;
      case ScreenType.aiSmartReplace:
        return 4;
      case ScreenType.reports:
        return 5;
      case ScreenType.settings:
        return 6;
      default:
        return 0;
    }
  }

  void _handleSidebarNavigation(int index) {
    switch (index) {
      case 0:
        _navigateTo(ScreenType.dashboard);
        break;
      case 1:
        _navigateTo(ScreenType.employeeList);
        break;
      case 2:
        _navigateTo(ScreenType.stationManagement);
        break;
      case 3:
        _navigateTo(ScreenType.autoScheduler);
        break;
      case 4:
        _navigateTo(ScreenType.aiSmartReplace);
        break;
      case 5:
        _navigateTo(ScreenType.reports);
        break;
      case 6:
        _navigateTo(ScreenType.settings);
        break;
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case ScreenType.dashboard:
        return DashboardContent(onNavigate: _navigateTo);
      case ScreenType.employeeList:
        return EmployeeListContent(onNavigate: _navigateTo);

    // FIXED: EmployeeDetailScreen → EmployeeDetailContent
    // REASON: EmployeeDetailScreen is StatefulWidget with different params
    // EmployeeDetailContent accepts onBack + onNavigate
      case ScreenType.employeeDetail:
        return EmployeeDetailScreen(
          employee: _screenData as Employee,
          onBack: () => _navigateTo(ScreenType.employeeList),
          onNavigate: _navigateTo,
        );

      case ScreenType.stationManagement:
        return StationManagementContent(onNavigate: _navigateTo);

      case ScreenType.stationDetail:
        return StationDetailContent(
          station: _screenData as Station,
          onNavigate: _navigateTo,
        );

    // FIXED: Removed onNavigate parameter from tool screens
    // REASON: AutoSchedulerContent, etc. are stateless and don't need navigation callbacks
    // They are leaf nodes in navigation (no internal navigation needed)
      case ScreenType.autoScheduler:
        return const AutoSchedulerContent();
      case ScreenType.aiSmartReplace:
        return const AISmartReplaceContent();
      case ScreenType.reports:
        return const ReportsContent();
      case ScreenType.settings:
        return const SettingsContent();

      default:
        return DashboardContent(onNavigate: _navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _getSelectedIndex(),
            onItemSelected: _handleSidebarNavigation,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey<ScreenType>(_currentScreen),
                child: _buildCurrentScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}