import 'package:edu_planner/screens/welcome_screen.dart';
import 'package:edu_planner/screens/calendar_screen.dart';
import 'package:edu_planner/screens/home_screen.dart';
import 'package:edu_planner/screens/notification_screen.dart';
import 'package:edu_planner/screens/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPlanner',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
      routes: {
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/notifications': (context) => NotificationScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
