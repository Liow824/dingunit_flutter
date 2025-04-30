import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'package:intl/intl.dart';

class UserInformPage extends StatefulWidget {
  final String userGuid;

  const UserInformPage({super.key, required this.userGuid});

  @override
  State<UserInformPage> createState() => _UserInformPageState();
}

class _UserInformPageState extends State<UserInformPage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  /// 🚀 Load User Details from Backend
  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await ApiService.getUserDetails(widget.userGuid);
      final data = userDetails['data'];
      setState(() {
        user = {
          'Username': data['Username'] ?? 'N/A',
          'Email': data['ClientEmail'] ?? 'N/A',
          'AccessRight': data['AccessRight'] ?? 'N/A',
          'CreatedTime': data['CreatedTime'] != null
              ? formatDateOnly(data['CreatedTime'])
              : 'N/A',
          'GUID': data['GUID'] ?? 'N/A',
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// 🚀 Update User Status
  Future<void> _updateUserStatus(int newStatus) async {
    try {
      final response =
          await ApiService.updateUserStatus(user?['GUID'], newStatus);
      if (response['status_code'] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User status updated successfully.')),
        );
        _loadUserDetails();
      } else {
        throw Exception(response['message'] ?? 'Failed to update status.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: ${e.toString()}')),
      );
    }
  }

  /// 🚀 Delete User
  Future<void> _deleteUser() async {
    try {
      await ApiService.deleteUser(user?['GUID']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  /// 📅 Format Date
  String formatDateOnly(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  /// 🟡 Buttons Based on Access Right
  Widget _buildAccessButtons(String accessRight) {
    switch (accessRight.toLowerCase()) {
      case 'pending':
        return Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Approve'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => _updateUserStatus(0), // Change to Active
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('Reject'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _deleteUser, // Delete User
            ),
          ],
        );

      case 'active':
        return ElevatedButton.icon(
          icon: const Icon(Icons.block, color: Colors.white),
          label: const Text('Block'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () => _updateUserStatus(2), // Block User
        );

      case 'block': // ✅ Corrected keyword
        return ElevatedButton.icon(
          icon: const Icon(Icons.replay, color: Colors.white),
          label: const Text('Reactivate'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () => _updateUserStatus(0), // Reactivate (Active)
        );

      default:
        return const SizedBox(); // No buttons for unknown status
    }
  }

  /// 🟢 User Information UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟡 Header & Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'User Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _buildAccessButtons(user?['AccessRight'] ?? ''),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🟢 User Information Card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow('Username:', user?['Username'] ?? 'N/A'),
                          _infoRow('Email:', user?['ClientEmail'] ?? 'N/A'),
                          _infoRow(
                              'Account Status:', user?['AccessRight'] ?? 'N/A'),
                          _infoRow(
                              'Member Since:', user?['CreatedTime'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// 📝 Info Row
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
