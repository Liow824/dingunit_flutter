import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/dataset/user.dart'; // Import your dataset
import '../widgets/header.dart';

class HomePage extends StatelessWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Fetch user details using userId
    final user = userDataset.firstWhere((usr) => usr.id == userId);

    // Format current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    final formattedTime = DateFormat('hh:mm:ss a').format(now);

    return Scaffold(
      body: Column(
        children: [
          Header(context: context), // Reusable header
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ${user.username}!', // Dynamically fetch username
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Today is $formattedDate'),
                      const SizedBox(height: 20),
                      Text('Current time: $formattedTime'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
