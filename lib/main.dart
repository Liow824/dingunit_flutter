import 'package:flutter/material.dart';
import 'nav/session_manager.dart';
import 'nav/routes.dart';

void main() {
  runApp(const DingUnit());
}

class DingUnit extends StatelessWidget {
  const DingUnit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ding Unit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login, // Start with login
      onGenerateRoute: SessionManager.generateRoute, // Use SessionManager for routing
    );
  }
}
