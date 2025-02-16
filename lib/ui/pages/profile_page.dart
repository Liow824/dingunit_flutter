import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Format date only
  String formatDateOnly(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
    return formattedDate;
  }

  Future<void> _loadUserDetails() async {
    final userGuid = SessionManager.currentUserGuid;
    if (userGuid != null) {
      try {
        final userDetails = await ApiService.getUserDetails(userGuid);
        setState(() {
          user = userDetails['data'];
          isLoading = false;
        });
      } catch (e) {
        debugPrint("Failed to load user details: $e");
        setState(() => isLoading = false);
      }
    } else {
      debugPrint("User GUID not found in session.");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Failed to load user data'))
              : Column(
                  children: [
                    // Upper Area: User Information
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(thickness: 1, color: Colors.black),
                          const SizedBox(height: 10),
                          _infoRow('Username:', user!['Username']),
                          _infoRow('Email:', user!['Email']),
                          _infoRow('Account Status:', user!['AccessRight']),
                          _infoRow('Member Since:', formatDateOnly(user!['CreatedTime'])),
                        ],
                      ),
                    ),

                    // Lower Area: Reservation History
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reservation History',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1, color: Colors.black),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    elevation: 3,
                                    child: ListTile(
                                      title: Text('Reservation ${index + 1}'),
                                      subtitle: const Text('Date: 2024-10-01 | Status: Completed'),
                                      trailing: const Icon(Icons.arrow_forward_ios),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
