import 'package:flutter/material.dart';
import 'package:flutter_application/nav/routes.dart';
import 'package:flutter_application/ui/widgets/header.dart';
import 'package:flutter_application/ui/pages/reservation_select.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Data Manager Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.draftManage);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Data Manager"),
                  ),

                  const SizedBox(height: 20),

                  // Reservation Button (Opens Draft Selection Dialog)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ReservationSelectDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Reservation"),
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
