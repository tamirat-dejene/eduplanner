import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({super.key});

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  bool _isMenuExpanded = false;

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'New Password',
            hintText: 'Enter new password',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPassword = passwordController.text.trim();
              if (newPassword.isEmpty || newPassword.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Password must be at least 6 characters long!')),
                );
                return;
              }
              try {
                await FirebaseAuth.instance.currentUser
                    ?.updatePassword(newPassword);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password changed successfully!')),
                );
                Navigator.pop(context); // Close the dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error changing password: $e')),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            user?.displayName ?? user?.email?.split('@').first ?? 'Guest',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          accountEmail: Text(user?.email ?? 'guest@home.com'),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
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
          onDetailsPressed: () {
            setState(() {
              _isMenuExpanded = !_isMenuExpanded;
            });
          },
        ),
        if (_isMenuExpanded)
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () => {
                  Navigator.pop(context),
                  _showChangePasswordDialog(context)
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _logout(context),
              ),

              // separator
              const Divider(),
            ],
          ),
      ],
    );
  }
}
