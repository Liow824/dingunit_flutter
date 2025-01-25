import 'package:flutter/material.dart';
import 'package:flutter_application/nav/routes.dart';
import '../widgets/header.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(context: context), // Add header at the top
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Handle "Data Manage" action
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.draftManage); // Navigate to the Draft Manage Page
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Data Manager"),
                  ),

                  
                  // Space between buttons
                  const SizedBox(height: 20), 
                  
                  // Handle "Season Start" action
                  ElevatedButton(
                    onPressed: () {
                      print("Season Start button pressed");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Season Start"),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
