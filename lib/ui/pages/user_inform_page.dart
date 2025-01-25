import 'package:flutter/material.dart';
import 'package:flutter_application/data/class/bookingTrx.dart';
import '../../data/class/clientData.dart';
import '../../data/dataset/booking.dart';
import '../../data/dataset/client.dart';
import '../../data/dataset/user.dart';

class UserInformPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userStatus;

  const UserInformPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userStatus,
  });

  @override
  State<UserInformPage> createState() => _UserInformPageState();
}

class _UserInformPageState extends State<UserInformPage> {
  late List<BookingTrx> reservationHistory;

  @override
  void initState() {
    super.initState();
    // Fetch reservation history for the user
    reservationHistory = bookingDataset
        .where((booking) => booking.authorId == widget.userId)
        .toList();
  }

  // Approve or Reject actions for pending users
  void _approveUser() {
    setState(() {
      final user = userDataset.firstWhere((user) => user.id == widget.userId);
      user.status = 'Active';
    });
    Navigator.pop(context);
  }

  void _rejectUser() {
    setState(() {
      final user = userDataset.firstWhere((user) => user.id == widget.userId);
      user.status = 'Terminated';
    });
    Navigator.pop(context);
  }

  // Terminate or Activate actions for users
  void _terminateUser() {
    setState(() {
      final user = userDataset.firstWhere((user) => user.id == widget.userId);
      user.status = 'Terminated';
    });
    Navigator.pop(context);
  }

  void _activateUser() {
    setState(() {
      final user = userDataset.firstWhere((user) => user.id == widget.userId);
      user.status = 'Active';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User: ${widget.userName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (widget.userStatus == 'Active')
                      ElevatedButton(
                        onPressed: _terminateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Terminate'),
                      ),
                    if (widget.userStatus == 'Pending') ...[
                      ElevatedButton(
                        onPressed: _approveUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _rejectUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                    if (widget.userStatus == 'Terminated')
                      ElevatedButton(
                        onPressed: _activateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Activate'),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // User Information Section
            const Text(
              'User Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildUserInformation(),

            // Reservation History (only for Active users)
            if (widget.userStatus == 'Active') ...[
              const SizedBox(height: 20),
              const Text(
                'Reservation History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: reservationHistory.isEmpty
                    ? const Center(child: Text('No reservations found'))
                    : ListView.builder(
                        itemCount: reservationHistory.length,
                        itemBuilder: (context, index) {
                          final booking = reservationHistory[index];
                          return _buildReservationTile(booking);
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper to build user information
  Widget _buildUserInformation() {
    final user = userDataset.firstWhere((user) => user.id == widget.userId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Name', user.username),
        _buildInfoRow('Email', user.email),
        _buildInfoRow('Role', user.role),
        _buildInfoRow('Status', widget.userStatus),
      ],
    );
  }

  // Helper to build reservation history tile
  Widget _buildReservationTile(BookingTrx booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation ID: ${booking.id}'),
          Text('Status: ${booking.status}'),
          Text('Created Date: ${booking.createdDate.toLocal()}'),
          Text('Client Name: ${booking.clientData.fullName}'),
        ],
      ),
    );
  }

  // Helper to build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
