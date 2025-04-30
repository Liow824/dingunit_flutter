import 'package:flutter/material.dart';
import 'package:flutter_application/api_service.dart';
import 'package:flutter_application/nav/session_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/ui/pages/reservation_duration_select.dart';

class ReservationSelectDialog extends StatefulWidget {
  const ReservationSelectDialog({super.key});

  @override
  ReservationSelectDialogState createState() => ReservationSelectDialogState();
}

class ReservationSelectDialogState extends State<ReservationSelectDialog> {
  List<dynamic> draftList = [];
  bool isLoading = true;
  String? selectedDraftGuid;
  String? authorGuid;

  int currentLimit = 10;
  bool isFetchingMore = false;
  String searchQuery = '';
  List<Map<String, dynamic>> allDrafts = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadDrafts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isFetchingMore &&
          draftList.length < allDrafts.length) {
        loadMoreDrafts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadDrafts() async {
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
    final response = await ApiService.getDraftList(authorGuid!);

    if (response['status']) {
      final all = List<Map<String, dynamic>>.from(response['drafts'] ?? []);
      // Show all drafts (both DraftStatus == 0 and DraftStatus == 1)
      allDrafts = all.toList();

      setState(() {
        draftList = _applyFilters();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  Future<void> _showRetryDurationDialog() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) => const RetryDurationDialog(),
    );

    if (minutes != null && selectedDraftGuid != null) {
      final selectedDraft = draftList.firstWhere(
        (draft) => draft['GUID'] == selectedDraftGuid,
      );

      final response = await ApiService.runAutoReserve(
        selectedDraftGuid!,
        minutes,
      );

      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Reservation started: ${response['message']}")),
        );
        Navigator.pop(context, selectedDraft);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response['message']}")),
        );
      }
    }
  }

  List<Map<String, dynamic>> _applyFilters() {
    final filtered = allDrafts.where((d) {
      final name = d['FullName']?.toLowerCase() ?? '';
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return filtered.take(currentLimit).toList();
  }

  Future<void> loadMoreDrafts() async {
    if (isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      currentLimit += 10;
      draftList = _applyFilters();
      isFetchingMore = false;
    });
  }

  Widget _buildDraftItem(Map<String, dynamic> draft) {
    String draftGuid = draft['GUID'];
    bool isSelected = draftGuid == selectedDraftGuid;
    bool isUsed = draft['DraftStatus'] == 1;

    String createdDate = "N/A";
    if (draft['CreatedTime'] != null) {
      DateTime parsedDate = DateTime.parse(draft['CreatedTime']);
      createdDate = DateFormat('dd/MM/yy HH:mm:ss').format(parsedDate);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDraftGuid = draftGuid;
        });
      },
      child: Container(
        width: 420,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (isUsed ? Colors.green : Colors.grey),
            width: isSelected ? 3 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  draft["FullName"] ?? "Unknown",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isUsed
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isUsed ? "Used" : "Unused",
                    style: TextStyle(
                      fontSize: 12,
                      color: isUsed ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text("Last modified time: $createdDate"),
            Text("Email: ${draft['ClientEmail'] ?? 'No Email'}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500, // Reduce dialog width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light gray background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select a Draft",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by full name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    currentLimit = 10;
                    draftList = _applyFilters();
                  });
                },
              ),
            ),

            // Draft List with Scrolling
            SizedBox(
              height: 400,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : draftList.isEmpty
                      ? const Center(
                          child: Text(
                            "No drafts available",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              ...draftList
                                  .map((draft) => _buildDraftItem(draft))
                                  .toList(),

                              //  Add loading spinner if more items are being fetched
                              if (isFetchingMore)
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                            ],
                          ),
                        ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedDraftGuid != null
                      ? _showRetryDurationDialog
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedDraftGuid != null ? Colors.blue : Colors.grey,
                  ),
                  child: const Text("Start"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
