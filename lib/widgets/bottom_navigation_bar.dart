import 'package:flutter/material.dart';

BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: 0,
    onTap: (index) {
      Navigator.pushNamed(context, '/home');
    },
    selectedItemColor: Colors.green,
    unselectedItemColor: const Color.fromARGB(255, 239, 168, 2),
    showSelectedLabels: true,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ],
  );
}
