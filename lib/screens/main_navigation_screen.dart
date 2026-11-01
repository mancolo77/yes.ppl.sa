import 'package:flutter/material.dart';
import '../services/sports_data_service.dart';
import '../theme/app_theme.dart';
import 'tabs/events_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/progress_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _tabs = const [
    HomeTab(),
    EventsTab(),
    ProgressTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    SportsDataService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkNavy,
          border: Border(
            top: BorderSide(color: AppTheme.secondaryBlue, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppTheme.darkNavy,
          selectedItemColor: AppTheme.orangeAccent,
          unselectedItemColor: const Color(0xFF8A99A8),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.military_tech_outlined),
              activeIcon: Icon(Icons.military_tech_rounded),
              label: 'My Progress',
            ),
          ],
        ),
      ),
    );
  }
}
