import 'package:flutter/material.dart';
import 'user_inform_page.dart';
import '../../api_service.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => UserManagerState();
}

class UserManagerState extends State<UserManager> {
  List<Map<String, dynamic>> _users = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  String _searchTerm = '';
  bool _hasNextPage = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// 🚀 Fetch Users from Backend
  Future<void> _fetchUsers() async {
    try {
      int pageStart = (_currentPage - 1) * _pageSize;
      
      // Fetch _pageSize + 1 users to check if more pages exist
      final result = await ApiService.getUsersList(
        pageStart: pageStart,
        pageSize: _pageSize + 1, // Fetch one extra user
        searchTerm: _searchTerm,
      );

      if (result['status']) {
        List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(result['users']);

        setState(() {
          if (users.length > _pageSize) {
            // More users exist -> Set _hasNextPage to true
            _hasNextPage = true;
            users.removeLast(); // Remove the extra user we fetched
          } else {
            // No more users -> Set _hasNextPage to false
            _hasNextPage = false;
          }
          _users = users;
        });
      } else {
        _showErrorDialog(result['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      _showErrorDialog('Failed to load users: $e');
    }
  }

  /// 🔄 General Refresh Function
  void _refreshPage() {
    setState(() {
      _currentPage = 1;
      _searchTerm = '';
      _searchController.clear();
    });
    _fetchUsers();
  }

  /// ⬅️ Previous Page
  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchUsers();
    }
  }

  /// ➡️ Next Page
  void _goToNextPage() {
    if (_hasNextPage) {
      setState(() {
        _currentPage++;
      });
      _fetchUsers();
    }
  }

  /// 💥 Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// 🟢 Navigate to User Info
  void _onUserTap(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInformPage(
          userGuid: user['GUID'], 
        ),
      ),
    ).then((_) => _refreshPage()); // Refresh after returning from details page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🟡 Search Bar with Refresh Button
            Row(
              children: [
                // Search Bar (Flexible to take available space)
                Flexible(
                  child:      
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value.trim(); // Update search term dynamically
                          _currentPage = 1; // Reset to first page when searching
                        });
                        _fetchUsers(); // Fetch users immediately when typing
                      },
                      decoration: InputDecoration(
                        labelText: 'Search Users',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchTerm = ''; // Reset search term
                              _currentPage = 1; // Reset to first page
                            });
                            _fetchUsers(); // Fetch full user list again
                          },
                        ),
                      ),
                    )
                ),
                const SizedBox(width: 8), // Spacing between search bar and button

                // 🔄 Refresh Button (Same row)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshPage,
                  tooltip: 'Refresh Users',
                  color: Colors.blueAccent,
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🟢 User List
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return GestureDetector(
                    onTap: () => _onUserTap(user),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 2,
                      child: ListTile(
                          title: Text(
                            '${user['Username']?.toString() ?? 'Unknown'} (${user['AccessRight']?.toString() ?? 'N/A'})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(user['Email']?.toString() ?? 'No Email Provided'),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🟡 Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPage > 1)
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _goToPreviousPage,
                  ),
                Text(
                  'Page $_currentPage',
                  style: const TextStyle(fontSize: 16),
                ),
                if (_hasNextPage)
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _goToNextPage,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
