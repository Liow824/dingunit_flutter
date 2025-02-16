import 'package:flutter/material.dart';
import '../../api_service.dart';
import '../widgets/header.dart';
import 'package:flutter_application/nav/session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userDetails = await ApiService.getUserDetails(SessionManager.currentUserGuid!);
      if (mounted) {
        setState(() {
          user = userDetails;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Failed to fetch user details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Failed to load user data'))
              : Column(
                  children: [
                    const Header(),
                    Expanded(
                      child: Center(
                        child: Text("Welcome, ${user!['data']['Username']}!"),
                      ),
                    ),
                  ],
                ),
    );
  }
}
