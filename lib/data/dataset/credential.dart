import '../class/mHubCredentials.dart';

List<MHubCredentials> credentialsDataset = [
  MHubCredentials(
    id: 1,
    email: "jianhao.wee@gmail.com",
    hashedPassword: "Qwert12345", // Placeholder password
    userId: 1, // Link to user ID， maybe dont need
  ),

  MHubCredentials(
    id: 2,
    email: "alex.tan@example.com",
    hashedPassword: "Alex12345", // Placeholder password
    userId: 2, // Link to user ID
  ),

  MHubCredentials(
    id: 3,
    email: "pending.user@example.com",
    hashedPassword: "Pending123", // Placeholder password
    userId: 3, // Link to user ID
  ),

  // New terminated user credentials
  MHubCredentials(
    id: 4, // Match the credentials ID with the user's credentialsId
    email: "terminated@example.com",
    hashedPassword: "Term12345", // Placeholder password
    userId: 4, // Link to the terminated user
  ),
];
