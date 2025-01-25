import '../data/class/user.dart'; // Import the User class
import '../data/class/mHubCredentials.dart'; // Import the MHubCredentials class
import '../data/dataset/user.dart'; // Import the user dataset
import '../data/dataset/credential.dart'; // Import the credentials dataset


class Authentication {

  // Function to verify user credentials across datasets
  static int verifyCredentials(String email, String password) {
    try {
      // Find the credentials
      final credential = credentialsDataset.firstWhere(
        (cred) => cred.email == email && cred.hashedPassword == password,
      );

      // Find the associated user
      final user = userDataset.firstWhere(
        (usr) => usr.id == credential.userId,
      );

      return user.id; // Return the user ID if everything is valid
    } catch (e) {
      // Return -1 or any other default value to indicate failure
      return -1;
    }
  }

  // Registration logic 
  static bool register(Map<String, dynamic> newUser) {
    final emailExists = credentialsDataset.any((cred) => cred.email == newUser['email']);
    if (emailExists) {
      return false; // Registration fails if email already exists
    }

    // Add the new user to both datasets
    int newUserId = userDataset.length + 1; // Example logic for generating IDs
    userDataset.add(User(
      id: newUserId,
      username: newUser['username'],
      email: newUser['email'],
      role: newUser['role'],
      accessRight: 'Pending', // Default to pending
      credentialsId: newUserId,
      clientIds: [],
      reservationIds: [],
    ));

    credentialsDataset.add(MHubCredentials(
      id: newUserId,
      email: newUser['email'],
      hashedPassword: newUser['password'],
      userId: newUserId,
    ));

    return true;
  }
}
