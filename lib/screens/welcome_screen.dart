import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

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
      // Dynamically set the next screen based on user authentication status
      nextScreen: FutureBuilder(
        future: _checkUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            // User is logged in, navigate to DashboardScreen
            return const DashboardScreen();
          } else {
            // User is not logged in, navigate to LoginScreen
            return const LoginScreen();
          }
        },
      ),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color.fromARGB(255, 207, 199, 199),
    );
  }

  Future<bool> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
