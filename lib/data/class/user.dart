class User {
  final int id; // User ID
  String username; // Unique username
  String email; // Unique email
  String role; // Account type: Admin/User
  String accessRight; // Access status: Pending, Active, Terminated
  final int? credentialsId; // Link to credentials by ID
  List<int> clientIds; // List of associated client IDs
  List<int> reservationIds; // List of associated reservation IDs

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.accessRight,
    this.credentialsId, // Link to credentials ID
    List<int>? clientIds,
    List<int>? reservationIds,
  })  : clientIds = clientIds ?? [],
        reservationIds = reservationIds ?? [];

  set status(String status) {
    this.status = status;
  }
}

