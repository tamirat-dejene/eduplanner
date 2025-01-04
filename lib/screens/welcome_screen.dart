import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:edu_planner/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 200,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 100,
            color: Colors.orange[700],
          ),
          const SizedBox(height: 15),
          Text(
            'EduPlanner📚',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Your Personal Study Planner',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[800],
            ),
          ),
        ],
      ),
      nextScreen: DashboardScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color.fromARGB(255, 207, 199, 199),
    );
  }
}
