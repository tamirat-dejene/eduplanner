import 'package:flutter/material.dart';

UserAccountsDrawerHeader buildDrawerHeader(BuildContext context) {
  return UserAccountsDrawerHeader(
    accountName: const Text(
      'Tamirat Dejenie',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    accountEmail: const Text('tamirat.dejenie@gmail.com'),
    currentAccountPicture: const CircleAvatar(
      backgroundImage: AssetImage('assets/icons/avatar.png'),
    ),
    onDetailsPressed: () {
      Navigator.pushNamed(context, '/profile');
    },
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange,
          Colors.green,
        ],
      ),
    ),
    margin: const EdgeInsets.only(bottom: 0),
  );
}
