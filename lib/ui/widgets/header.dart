import 'package:flutter/material.dart';
import '../../nav/routes.dart';
import '../../nav/session_manager.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String userRole = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  /// Load user role securely
  void _loadUserRole() async {
    await SessionManager.loadSession(); // Ensure session data is loaded
    
    setState(() {
      userRole = SessionManager.currentUserRole ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'DingUnit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _buildHeaderButton('Home', () {
                Navigator.pushNamed(context, AppRoutes.home);
              }),
              const SizedBox(width: 16),
              _buildHeaderButton('Action', () {
                Navigator.pushNamed(context, AppRoutes.action);
              }),
              if (userRole == 'Admin') ...[
                const SizedBox(width: 16),
                _buildHeaderButton('Manage', () {
                  Navigator.pushNamed(context, AppRoutes.manage);
                }),
              ],
              const SizedBox(width: 16),
              _buildHeaderButton('Profile', () {
                Navigator.pushNamed(context, AppRoutes.profile);
              }),
              const SizedBox(width: 16),
              _buildHeaderButton('Logout', () {
                SessionManager.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
