import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../api_service.dart';
import '../../nav/session_manager.dart';
import '../../nav/routes.dart';


class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // debugPrint("Attempting login with email: $email");

        final result = await ApiService.login(email, password);

        if (result['status']) {
          final userGuid = result['guid'];

          // Fetch user details directly here
          final userDetails = await ApiService.getUserDetails(userGuid);
          final String userRole = userDetails['data']['Role'] ?? 'User';

          // Save session details
          await SessionManager.login(userGuid, userRole);

          // Navigate to Home
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => HomePage(),
            ));
          }
        } else {
          showMessageDialog("Login Failed", result['message']);
        }
      } catch (e) {
        // debugPrint("Error during login: $e");
        showMessageDialog("Error", "An unexpected error occurred. Please try again.");
      }
    }
  }

  void showMessageDialog(String title, String message, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (onConfirm != null) onConfirm(); // If there's a confirmation action, execute it
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Title
                const Text(
                  "DingUnit",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration.copyWith(labelText: "Email"),
                  validator: (value) => value!.isEmpty ? "Please enter your email" : null,
                ),
                const SizedBox(height: 20),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: inputDecoration.copyWith(labelText: "Password"),
                  validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                ),
                const SizedBox(height: 30),

                // Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Register Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      ),
                      child: const Text("Register"),
                    ),

                    const SizedBox(width: 20), // Space between buttons

                    // Login Button
                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      ),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
