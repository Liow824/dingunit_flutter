class User {
  final int id; // User ID
  String username; // Username
  String email; // Email
  String password; // Password
  String role; // Role (e.g., Admin/User)
  String accessRight; // AccessRight (Pending, Active, etc.)
  DateTime createdTime; // CreatedTime
  String guid; // GUID

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.accessRight,
    required this.createdTime,
    required this.guid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      username: json['Username'],
      email: json['Email'],
      password: json['Password'] ?? '',
      role: json['Role'],
      accessRight: json['AccessRight'],
      createdTime: DateTime.parse(json['CreatedTime']),
      guid: json['GUID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Username': username,
      'Email': email,
      'Password': password,
      'Role': role,
      'AccessRight': accessRight,
      'CreatedTime': createdTime.toIso8601String(),
      'GUID': guid,
    };
  }
}
