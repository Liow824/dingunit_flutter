import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../../nav/routes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        final username = _usernameController.text;
        final email = _emailController.text;
        final password = _passwordController.text;

        // Call the registration API
        final result = await ApiService.register(username, email, password);

        if (result['status_code'] == 0) { 
          _showMessage("Registration successful! Please wait for admin approval.", () {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
          });
        } else {
          // Show error message
          _showMessage("Registration failed: ${result['message']}", null);
        }
      } catch (e) {
        _showMessage("An error occurred: $e", null);
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showMessage(String message, VoidCallback? onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: const Text("OK"),
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
      appBar: AppBar(
        title: const Text("User Registration"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Username Input
                TextFormField(
                  controller: _usernameController,
                  decoration: inputDecoration.copyWith(labelText: "Username"),
                  validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                ),
                const SizedBox(height: 20),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration.copyWith(labelText: "Email"),
                  validator: (value) => value!.isEmpty ? "Please enter your email" : null,
                  keyboardType: TextInputType.emailAddress,
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

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
