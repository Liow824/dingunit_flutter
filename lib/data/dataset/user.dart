import '../class/user.dart';

List<User> userDataset = [
  // Create the admin user
  User(
    id: 1,
    username: "Jian Hao",
    email: "jianhao.wee@gmail.com",
    role: "Admin",
    accessRight: "Active",
    credentialsId: 1, // Link to credentials dataset
    clientIds: [1], // List of client IDs
    reservationIds: [1], // List of reservation IDs
  ),

  // Regular User
  User(
    id: 2,
    username: "Alex Tan",
    email: "alex.tan@example.com",
    role: "User",
    accessRight: "Active",
    credentialsId: 2, // Link to credentials dataset
    clientIds: [2], // List of client IDs
    reservationIds: [2], // List of reservation IDs
  ),

    // Pending User
  User(
    id: 3,
    username: "Pending User",
    email: "pending.user@example.com",
    role: "User",
    accessRight: "Pending", // Pending status
    credentialsId: 3, // Link to credentials dataset
    clientIds: [], // No clients yet
    reservationIds: [], // No reservations yet
  ),

  // New terminated user
  User(
    id: 4, // Unique ID for the user
    username: "TerminatedUser",
    email: "terminated@example.com",
    role: "User",
    accessRight: "Terminated", // Set accessRight to Terminated
    credentialsId: 4, // Link to credentials dataset
    clientIds: [], // No client data
    reservationIds: [3], // List containing one reservation ID
  ),
];
