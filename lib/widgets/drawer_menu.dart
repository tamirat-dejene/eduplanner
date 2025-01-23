import 'package:flutter/material.dart';

Column buildDrawerMenu({
  required BuildContext context,
  required int currentIndex,
  required ValueChanged<int> onTap,
}) {
  return Column(
    children: <Widget>[
      ListTile(
        title: const Text('Home'),
        leading: const Icon(Icons.home),
        selected: currentIndex == 0,
        selectedColor: Colors.green,
        onTap: () {
          onTap(0);
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Schedules'),
        leading: const Icon(Icons.calendar_today),
        selected: currentIndex == 1,
        selectedColor: Colors.green,
        onTap: () {
          onTap(1);
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Reminders'),
        leading: const Icon(Icons.notifications),
        selected: currentIndex == 2,
        selectedColor: Colors.green,
        onTap: () {
          onTap(2);
          Navigator.pop(context);
        },
      ),
    ],
  );
}
