import 'package:flutter/material.dart';
import 'package:flutter_application/ui/pages/user_inform_page.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  _UserManagerPageState createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManager> {
  final List<Map<String, String>> _allUsers = List.generate(
    200,
    (index) => {
      'name': 'User $index',
      'role': index % 3 == 0 ? 'Admin' : 'User',
      'status': index % 4 == 0
          ? 'Active'
          : index % 4 == 1
              ? 'Pending'
              : 'Terminated',
    },
  ); // All users with roles and statuses

  final List<Map<String, String>> _displayedUsers = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  static const int _batchSize = 15; // Number of users per page
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMoreUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreUsers();
    }
  }

  void _loadMoreUsers() {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final filteredUsers = _allUsers
            .where((user) =>
                user['role'] != 'Admin' && // Exclude admins
                user['name']!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

        final int remainingUsers = filteredUsers.length - _displayedUsers.length;
        final int loadCount = remainingUsers > _batchSize
            ? _batchSize
            : remainingUsers;

        _displayedUsers.addAll(
            filteredUsers.sublist(_displayedUsers.length, _displayedUsers.length + loadCount));
        _isLoading = false;
      });
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _displayedUsers.clear();
      _loadMoreUsers();
    });
  }

  void _onUserTap(Map<String, String> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInformPage(
          userId: _allUsers.indexOf(user), // Use index as ID
          userName: user['name']!,
          userStatus: user['status']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Manager (${_allUsers.where((user) => user['role'] != 'Admin').length})"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search by name (e.g., User 1)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _displayedUsers.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _displayedUsers.length) {
                    final user = _displayedUsers[index];
                    return GestureDetector(
                      onTap: () => _onUserTap(user),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0), // Space between rows
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
