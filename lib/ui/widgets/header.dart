import 'package:flutter/material.dart';
import 'package:flutter_application/data/class/user.dart';
import '../../nav/routes.dart';
import '../../nav/session_manager.dart';
import '../../data/dataset/user.dart';

class Header extends StatelessWidget {
  final BuildContext context;

  const Header({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
// Get the current user ID from SessionManager
    final currentUserId = SessionManager.currentUserId;

    // Find the user's role based on their ID
    String userRole = 'User'; // Default role
    if (currentUserId != null) {
      final user = userDataset.firstWhere(
        (u) => u.id == currentUserId,
        orElse: () => User(
          id: -1,
          username: 'Unknown',
          email: 'unknown@example.com',
          role: 'User', // Default to 'User'
          accessRight: 'Terminated', // Default to 'Terminated' if no match
          credentialsId: -1,
          clientIds: [],
          reservationIds: [],
        ),
      );
      userRole = user.role; // Assign the found user's role
    }

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
              _buildHeaderButton('Logout', () {
                SessionManager.logout(); // Reset session
                Navigator.pushReplacementNamed(
                    context, AppRoutes.login); // Redirect to login
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
