import 'package:flutter/material.dart';

Column buildDrawerMenu(BuildContext context) {
  return Column(
    children: <ListTile>[
      ListTile(
        title: const Text('Home'),
        leading: const Icon(Icons.home),
        onTap: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
      ListTile(
        title: const Text('Calendar'),
        leading: const Icon(Icons.calendar_today),
        onTap: () {
          Navigator.pushNamed(context, '/calendar');
        },
      ),
      ListTile(
        title: const Text('Notifications'),
        leading: const Icon(Icons.notifications),
        onTap: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
    ],
  );
}
