import 'package:flutter/material.dart';
import 'package:flutter_application/data/dataset/user.dart';
import '../../backend/authentication.dart';
import '../widgets/register_dialog.dart';

class AuthenticationPage extends StatefulWidget {
  final Function(int userId) onLoginSuccess;

  const AuthenticationPage({super.key, required this.onLoginSuccess});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final userId = Authentication.verifyCredentials(email, password);

      if (userId != -1) {
        final user = userDataset.firstWhere((u) => u.id == userId);

        if (user.accessRight == 'Pending') {
          // Show dialog for pending accounts
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Account Pending'),
              content: const Text(
                  'Your account is still pending approval. Please wait for admin approval.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (user.accessRight == 'Active') {
          // Proceed to home page if account is active
          widget.onLoginSuccess(userId); // Pass the user ID to the session manager
        } else if (user.accessRight == 'Terminated') {
          // Show dialog for terminated accounts
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Account Terminated'),
              content: const Text(
                  'Your account has been terminated. Please contact support for further assistance.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Invalid email or password.",
            ),
          ),
        );
      }
    }
  }

  void handleRegister() {
    showDialog(
      context: context,
      builder: (context) => RegisterDialog(
        onRegister: (newUser) {
          bool success = Authentication.register(newUser);
          if (success) {
            Navigator.of(context).pop(); // Close the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration successful!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email already exists.")),
            );
          }
        },
      ),
    );
  }

  Widget buildCustomButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Colors.blue, width: 1.5), // Border line
        backgroundColor: Colors.white, // Button background color
        foregroundColor: Colors.blue, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        elevation: 2, // Shadow effect
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 500, // Increased width
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "DingUnit",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration.copyWith(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: inputDecoration.copyWith(labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                buildCustomButton("Login", handleLogin), // Styled login button
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCustomButton("Register", handleRegister),
                    buildCustomButton(
                      "Forget Password",
                      () {
                        // Forget password functionality placeholder
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Forget Password not implemented")),
                        );
                      },
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
