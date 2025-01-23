import 'package:edu_planner/screens/schedule_screen.dart';
import 'package:edu_planner/screens/reminder_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer_header.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/home_task_tab.dart';
import '../widgets/app_bar.dart'; // Import the app_bar.dart file

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Add a GlobalKey to control the drawer and app bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeTaskTab(),
    const ScheduleScreen(),
    const ReminderScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context, _scaffoldKey),
      drawer: Drawer(
        width: 250,
        child: ListView(
          children: [
            const CustomDrawerHeader(),
            buildDrawerMenu(
              context: context,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
