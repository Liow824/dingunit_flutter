import 'package:flutter/material.dart';
import 'package:flutter_application/api_service.dart';
import 'package:flutter_application/nav/routes.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:intl/intl.dart';

class DraftManager extends StatefulWidget {
  const DraftManager({super.key});

  @override
  DraftManagerState createState() => DraftManagerState();
}

class DraftManagerState extends State<DraftManager> {
  List<dynamic> draftList = [];
  bool isLoading = true;
  int draftCount = 0;
  final int maxDrafts = 20;
  String? authorGuid;

  final int initialLoad = 20;
  final int pageSize = 6;
  int currentLimit = 20;
  bool isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadUserAndFetchDrafts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isFetchingMore &&
          draftList.length < draftCount) {
        loadMoreDrafts();
      }
    });
  }

  Future<void> loadUserAndFetchDrafts() async {
    await SessionManager.loadSession();
    authorGuid = SessionManager.currentUserGuid;

    if (authorGuid != null) {
      fetchDrafts();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No user session found.")),
      );
    }
  }

  Future<void> fetchDrafts() async {
    if (authorGuid == null) return;
    setState(() {
      isLoading = true;
    });

    final response = await ApiService.getDraftList(authorGuid!);

    if (response['status']) {
      final allDrafts =
          List<Map<String, dynamic>>.from(response['drafts'] ?? [])
              .where((draft) => draft['DraftStatus'] == 0)
              .toList();

      if (mounted) {
        setState(() {
          draftList = allDrafts.take(currentLimit).toList();
          draftCount = allDrafts.length;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  Future<void> deleteDraft(String draftGuid) async {
    try {
      final response = await ApiService.deleteDraft(draftGuid);

      if (response['status']) {
        setState(() {
          draftList.removeWhere((draft) => draft['GUID'] == draftGuid);
          draftCount = draftList.length;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        await fetchDrafts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to delete draft: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting draft: $e")),
      );
    }
  }

  Widget draftItem(Map<String, dynamic> draft, int orderNumber) {
    String createdDate = "N/A";
    if (draft['CreatedTime'] != null) {
      DateTime parsedDate = DateTime.parse(draft['CreatedTime']);
      createdDate = DateFormat('dd/MM/yy HH:mm:ss').format(parsedDate);
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.draftDetail,
          arguments: draft['GUID'],
        ).then((_) => fetchDrafts());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$orderNumber. ${draft['FullName'] ?? 'Unknown'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  "Last modified time: $createdDate",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),

                // Email (Newly Added)
                Text(
                  "Email: ${draft['ClientEmail'] ?? 'No Email'}", // ✅ Now showing Email
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Deletion"),
                        content: const Text(
                            "Are you sure you want to delete this draft?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () async {
                              try {
                                await deleteDraft(draft['GUID']);

                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error deleting draft: $e")),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadMoreDrafts() async {
    setState(() {
      isFetchingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      currentLimit += pageSize;
    });

    await fetchDrafts();

    setState(() {
      isFetchingMore = false;
    });

    // Auto scroll a bit after loading
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draft Manager"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Draft Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.draftCreate)
                    .then((result) {
                  if (result == true) {
                    fetchDrafts();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add Draft",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Scrollable Draft List
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : draftList.isEmpty
                      ? const Center(
                          child: Text(
                            "No drafts available",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              ...List.generate(
                                (draftList.length / 2).ceil(),
                                (index) {
                                  int leftIndex = index * 2;
                                  int rightIndex = leftIndex + 1;

                                  return Row(
                                    children: [
                                      Expanded(
                                          child: draftItem(draftList[leftIndex],
                                              leftIndex + 1)),
                                      const SizedBox(width: 10),
                                      if (rightIndex < draftList.length)
                                        Expanded(
                                            child: draftItem(
                                                draftList[rightIndex],
                                                rightIndex + 1))
                                      else
                                        Expanded(child: Container()),
                                    ],
                                  );
                                },
                              ),
                              if (isFetchingMore)
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
