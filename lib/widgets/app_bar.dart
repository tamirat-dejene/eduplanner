import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    title: const Text(
      'EduPlanner📚',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
    backgroundColor: const Color.fromARGB(0, 150, 208, 56),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
        behavior: HitTestBehavior.translucent,
        child: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/icons/avatar.png'),
          ),
        ),
      ),
    ],
  );
}
