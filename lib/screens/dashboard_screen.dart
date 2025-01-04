import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/drawer_header.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/task_tab_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: Drawer(
        width: 250,
        child: ListView(
          children: [
            buildDrawerHeader(context),
            buildDrawerMenu(context),
          ],
        ),
      ),
      body: buildBody('Tamiru'),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildBody(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(child: TaskTabView()),
        ],
      ),
    );
  }
}
