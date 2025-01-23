import 'package:flutter/material.dart';

BottomNavigationBar buildBottomNavigationBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
}) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: onTap,
    selectedItemColor: Colors.green,
    unselectedItemColor: const Color.fromARGB(255, 239, 168, 2),
    showSelectedLabels: true,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Tasks',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Schedules',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Reminders',
      ),
    ],
  );
}
